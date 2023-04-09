#' Model fertility with age using set functional forms
#'
#' This function computes fertility based on the logistic, step, von
#' Bertalanffy, Hadwiger, and normal models.
#' The logistic model assumes that fertility increases sigmoidally with age from
#' maturity until a maximum fertility is reached.
#' The step model assumes that fertility is zero before the age of maturity and
#' then remains constant.
#' The von Bertalanffy model assumes that, after maturity, fertility increases
#' asymptotically with age until a maximum fertility is reached. In this
#' formulation, the model is set up so that fertility is 0 at the 'age of
#' maturity - 1', and increases from that point.
#' The Hadwiger model is rather complex and is intended to model human fertility
#' with a characteristic hump-shaped fertility.
#' For all models, the output ensures that fertility is zero before the age at
#' maturity.
#'
#'
#' @param age A numeric vector representing age.
#' @param params A numeric vector of parameters for the selected model. The
#'   number and meaning of parameters depend on the selected model.
#' @param maturity A non-negative numeric value indicating the age at maturity.
#'   Whatever model is used, the fertility is forced to be 0 below the age of
#'   maturity.
#' @param model A character string specifying the model to use. Must be one of
#'   "logistic", "step", "vonbertalanffy","normal" or "hadwiger".
#'
#' @return A numeric vector representing the computed fertility values.
#' @details The required parameters varies depending on the fertility model. The
#'   parameters are provided as a vector and the parameters must be provided in
#'   the order mentioned here.
#'
#'   * Logistic: \eqn{f(x) = A / (1 + exp(-k  (x - x_m)))}
#'   * Step: \eqn{f(x)=
#'   \begin{cases}
#'   A, x \geq m \\
#'   A, x <  m
#'   \end{cases}}
#'   * von Bertalanffy: \eqn{f(x) = A  (1 - exp(-k  (x - x_0)))}
#'   * Normal: \eqn{f(x) = A \times \exp\left(
#'   -\frac{1}{2}\left(\frac{x-\mu}{\sigma}\right)^{\!2}\,\right)}
#'   * Hadwiger: \eqn{f(x) = \frac{ab}{c} \left (\frac{c}{x}  \right )
#'    ^\frac{3}{2} \exp \left \{ -b^2  \left ( \frac{c}{x}+\frac{x}{c}-2
#'    \right ) \right \}}
#'
#'
#' @references
#' Bertalanffy, L. von (1938) A quantitative theory of organic growth (inquiries
#' on growth laws. II). Human Biology 10:181–213.
#'
#' Peristera, P. & Kostaki, A. (2007) Modeling fertility in modern populations.
#' Demographic Research. 16. Article 6, 141-194 \doi{10.4054/DemRes.2007.16.6}
#'
#' @examples
#' # Compute fertility using the step model
#' model_fertility(age = 0:20, params = c(A = 10), maturity = 2, model = "step")
#'
#' # Compute fertility using the logistic model
#' model_fertility(
#'   age = 0:20, params = c(A = 10, k = 0.5, x_m = 8), maturity =
#'     0, model = "logistic"
#' )
#'
#' # Compute fertility using the von Bertalanffy model
#' model_fertility(
#'   age = 0:20, params = c(A = 10, k = .3), maturity = 2, model =
#'     "vonbertalanffy"
#' )
#'
#' # Compute fertility using the normal model
#' model_fertility(
#'   age = 0:20, params = c(A = 10, mu = 4, sd = 2), maturity = 0,
#'   model = "normal"
#' )
#'
#' # Compute fertility using the Hadwiger model
#' model_fertility(
#'   age = 0:50, params = c(a = 0.91, b = 3.85, c = 29.78),
#'   maturity = 0, model = "hadwiger"
#' )
#'
#' @family trajectories
#' @author Owen Jones <jones@biology.sdu.dk>
#' @seealso [model_survival()] to model age-specific survival using mortality
#'   models.
#' @export


model_fertility <- function(age = NULL, params, maturity = 0,
                            model = "logistic") {
  # Input validation and input error handling
  if (!is.numeric(age)) stop("Input 'age' must be a numeric vector.")
  if (min(age) < 0) stop("Input 'age' must be non-negative.")

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
    # params: a = 0.91; b = 3.85; c = 29.78 (Sweden 1996)
    # http://www.demographic-research.org/Volumes/Vol16/6/
    # DOI: 10.4054/DemRes.2007.16.6
    a <- params[1]
    b <- params[2]
    c <- params[3]

    out <- ((a * b) / c) * (c / age)^(3 / 2) * exp(-b^2 * ((c / age) +
      (age / c) - 2))
    return(out)
  }
}
