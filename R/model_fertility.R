#' Model fertility with age using set functional forms
#'
#' This function computes fertility based on the logistic, step, von
#' Bertalanffy, and normal models. The logistic model assumes that fertility
#' increases sigmoidally with age until a maximum fertility is reached, while
#' the step model assumes that fertility is zero before the age of maturity and
#' then remains constant. The von Bertalanffy model assumes that, after
#' maturity, fertility increases asymptotically with age until a maximum
#' fertility is reached. For all models, the output ensures that fertility is
#' zero before the age at maturity.
#'
#'
#' @param age A numeric vector representing age.
#' @param params A numeric vector of parameters for the selected model. The
#'   number and meaning of parameters depend on the selected model.
#' @param maturity A non-negative numeric value indicating the age at maturity.
#'   Whatever model is used, the fertility is forced to be 0 below the age of
#'   maturity.
#' @param model A character string specifying the model to use. Must be one of
#'   "logistic", "step", or "vonbertalanffy".
#'
#' @return A numeric vector representing the computed fertility values.
#'
#' @examples
#' # Compute fertility using the logistic model
#' model_fertility(age = 0:20, params = c(10, 0.5, 8), maturity = 0, model = "logistic")
#'
#' # Compute fertility using the step model
#' model_fertility(age = 0:20, params = 10, maturity = 2, model = "step")
#'
#' # Compute fertility using the von Bertalanffy model
#' model_fertility(age = 0:20, params = c(10, .3), maturity = 2, model = "vonbertalanffy")
#'
#' # Compute fertility using the normal model
#' model_fertility(age = 0:20, params = c(10, 4, 2), maturity = 0, model = "normal")
#'
#' @author Owen Jones <jones@biology.sdu.dk>
#'
#' @importFrom stats dnorm
#' @export


model_fertility <- function(age = NULL, params, maturity = 0, model = "logistic") {

  # Input validation and input error handling
  if (!is.numeric(age)) stop("Input 'age' must be a numeric vector.")
  if (min(age) < 0) stop("Input 'age' must be non-negative.")

  # Check model parameter name
  if (!model %in% c("vonbertalanffy", "logistic", "normal", "step")) {
    stop("Invalid model type (must be one of 'vonbertalanffy',
         'logistic', 'normal' or 'step'")
  }

  #Check model parameter count
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


  if (model == "logistic") {
    # params: max_fert, k, midpoint_age

    max_fert <- params[1]
    k <- params[2]
    midpoint_age <- params[3]

    out <- max_fert / (1 + exp(-k * (age - midpoint_age)))
    out[which(age < maturity)] <- 0

    return(out)
  }

  if (model == "step") {
    # params: max_fert, maturity
    max_fert <- params[1]

    out <- rep(max_fert, length(age))
    out[which(age < maturity)] <- 0

    return(out)
  }


  if (model == "vonbertalanffy") {
    # params: max_fert = 12, k=0.5
    max_fert <- params[1]
    k <- params[2]

    age_0 <- maturity

    out <- max_fert * (1 - exp(-k * (age - age_0)))^(1 / 3)
    out[which(age < maturity)] <- 0
    return(out)
  }

  # Normal
  if (model == "normal") {
    # params: max_fert = 12, mu=6, sd = 2
    max_fert <- params[1]
    mu <- params[2]
    sd <- params[3]

    dens <- dnorm(age, mean = mu, sd = sd)
    height_of_norm <- 0.3989 / sd

    scaling_factor <- max_fert / height_of_norm
    out <- dens * scaling_factor
    out[which(age < maturity)] <- 0

    return(out)
  }
}
