#' Model reproductive output with age using set functional forms
#'
#' This function computes reproductive output (often referred to as fertility in
#' human demography and fecundity in population biology) based on the logistic,
#' step, von Bertalanffy, Hadwiger, and normal models. The logistic model
#' assumes that reproductive output increases sigmoidally with age from maturity
#' until a maximum is reached. The step model assumes that reproductive output
#' is zero before the age of maturity and then remains constant. The von
#' Bertalanffy model assumes that, after maturity, reproductive output increases
#' asymptotically with age until a maximum is reached. In this formulation, the
#' model is set up so that reproductive output is 0 at the 'age of maturity -
#' 1', and increases from that point. The Hadwiger model, while originally
#' intended to model human fertility with a characteristic hump-shaped curve, is
#' applied here to model fecundity (actual offspring production). For all
#' models, the output ensures that reproductive output is zero before the age at
#' maturity.
#'
#'
#' @param params A numeric vector of parameters for the selected model. The
#'   number and meaning of parameters depend on the selected model.
#' @param age A numeric vector representing age. For use in creation of MPMs and
#'   life tables, these should be integers.
#' @param maturity A non-negative numeric value indicating the age at maturity.
#'   Whatever model is used, the reproductive output is forced to be 0 below the
#'   age of maturity.
#' @param model A character string specifying the model to use. Must be one of
#'   "logistic", "step", "vonbertalanffy","normal" or "hadwiger".
#'
#' @return A numeric vector representing the computed reproductive output
#'   values.
#' @details The required parameters varies depending on the model used. The
#'   parameters are provided as a vector and the parameters must be provided in
#'   the order mentioned here.
#'
#'   * Logistic: \eqn{f_x = A / (1 + exp(-k  (x - x_m)))}
#'   * Step: \eqn{f_x=
#'   \begin{cases} A, x \geq m \\ A, x <  m \end{cases}}
#'   * von Bertalanffy: \eqn{f_x = A  (1 - exp(-k  (x - x_0)))}
#'   * Normal: \eqn{f_x = A \times \exp\left(
#'   -\frac{1}{2}\left(\frac{x-\mu}{\sigma}\right)^{2}\,\right)}
#'   * Hadwiger: \eqn{f_x = \frac{ab}{C} \left (\frac{C}{x}  \right )
#'    ^\frac{3}{2} \exp \left \{ -b^2  \left ( \frac{C}{x}+\frac{x}{C}-2
#'    \right ) \right \}}
#'
#'
#' @references Bertalanffy, L. von (1938) A quantitative theory of organic
#'   growth (inquiries on growth laws. II). Human Biology 10:181–213.
#'
#'   Peristera, P. & Kostaki, A. (2007) Modeling fertility in modern
#'   populations. Demographic Research. 16. Article 6, 141-194
#'   \doi{10.4054/DemRes.2007.16.6}
#'
#' @examples
#' # Compute reproductive output using the step model
#' model_fecundity(age = 0:20, params = c(A = 10), maturity = 2, model = "step")
#'
#' # Compute reproductive output using the logistic model
#' model_fecundity(
#'   age = 0:20, params = c(A = 10, k = 0.5, x_m = 8), maturity =
#'     0, model = "logistic"
#' )
#'
#' # Compute reproductive output using the von Bertalanffy model
#' model_fecundity(
#'   age = 0:20, params = c(A = 10, k = .3), maturity = 2, model =
#'     "vonbertalanffy"
#' )
#'
#' # Compute reproductive output using the normal model
#' model_fecundity(
#'   age = 0:20, params = c(A = 10, mu = 4, sd = 2), maturity = 0,
#'   model = "normal"
#' )
#'
#' # Compute reproductive output using the Hadwiger model
#' model_fecundity(
#'   age = 0:50, params = c(a = 0.91, b = 3.85, C = 29.78),
#'   maturity = 0, model = "hadwiger"
#' )
#'
#' @family trajectories
#' @author Owen Jones <jones@biology.sdu.dk>
#' @seealso [model_mortality()] to model age-specific survival using mortality
#'   models.
#' @export

model_fecundity <- function(params, age = NULL, maturity = 0,
                            model = "logistic") {
  # Coerce model type to lower case to avoid irritation
  model <- tolower(model)
  # Input validation and input error handling
  if (!is.numeric(age)) stop("Input 'age' must be a numeric vector.")

  if (min(age) < 0) stop("Input 'age' must be non-negative.")

  if (any(age != floor(age))) warning("Input 'age' must be integers for use
                                      in creating MPMs")

  if (length(age) > 1) {
    if (min(diff(age)) <= 0) {
      stop("age must be an increasing sequence")
    }
  }
  # Check model parameter name
  if (!model %in% c(
    "vonbertalanffy", "logistic", "normal", "step",
    "hadwiger"
  )) {
    stop("Invalid model type (must be one of 'vonbertalanffy',
         'logistic', 'normal', 'hadwiger' or 'step'")
  }

  # Check model parameter count
  if (model == "vonbertalanffy" && length(params) != 2) {
    stop("Invalid number of parameters for selected model.")
  }
  if (model == "logistic" && length(params) != 3) {
    stop("Invalid number of parameters for selected model.")
  }
  if (model == "step" && length(params) != 1) {
    stop("Invalid number of parameters for selected model.")
  }
  if (model == "normal" && length(params) != 3) {
    stop("Invalid number of parameters for selected model.")
  }
  if (model == "hadwiger" && length(params) != 3) {
    stop("Invalid number of parameters for selected model.")
  }

  if (model == "logistic") {
    # params: max_fert, k, midpoint_age

    max_fert <- params[1]
    k <- params[2]
    midpoint_age <- params[3]

    out <- max_fert / (1 + exp(-k * (age - midpoint_age + maturity)))

    return(out)
  }

  if (model == "step") {
    # params: max_fert, maturity
    max_fert <- params[1]

    out <- rep(max_fert, length(age))
    names(out) <- NULL
    out[which(age < maturity)] <- 0

    return(out)
  }


  if (model == "vonbertalanffy") {
    # params: max_fert = 12, k=0.5
    max_fert <- params[1]
    k <- params[2]

    age_0 <- maturity - 1

    out <- max_fert * (1 - exp(-k * (age - age_0)))
    out[which(age < maturity)] <- 0
    return(out)
  }

  # Normal
  if (model == "normal") {
    # params: max_fert = 12, mu=6, sd = 2
    max_fert <- params[1]
    mu <- params[2]
    sd <- params[3]

    out <- max_fert * exp(-0.5 * ((age - mu) / sd)^2)

    out[which(age < maturity)] <- 0

    return(out)
  }

  if (model == "hadwiger") {
    # params: a of 0.91; b of 3.85; c of 29.78 (Sweden 1996)
    # http://www.demographic-research.org/Volumes/Vol16/6/
    a <- params[1]
    b <- params[2]
    c <- params[3]

    out <- ((a * b) / c) * (c / age)^(3 / 2) * exp(-b^2 * ((c / age) +
      (age / c) - 2))
    out[is.nan(out)] <- 0
    out[which(age < maturity)] <- 0

    return(out)
  }
}

#' @rdname model_fecundity
#' @examples
#' model_reproduction(age = 0:20, params = c(A = 10), maturity = 2, model = "step")
#' @export
model_reproduction <- model_fecundity

#' @rdname model_fecundity
#' @examples
#' model_fertility(age = 0:20, params = c(A = 10), maturity = 2, model = "step")
#' @export
model_fertility <- model_fecundity
