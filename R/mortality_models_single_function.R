#' Utility function to calculate the cumulative area under the curve (AUC) from x and y data
#'
#' @param x Numeric or Integer vector representing the x-axis values. It must have the same length as y.
#' @param y Numeric vector representing the y-axis values. It must have the same length as x.
#' @return A numeric vector representing the cumulative AUC at each point along the x-axis. The first element of the vector will always be 0.
#' @examples
#' cumulative_auc(c(0, 1, 2, 3), c(0, 1, 2, 3))
#' @noRd

cumulative_auc <- function(x, y) {
  if (length(x) != length(y)) {
    stop("x and y must have the same length")
  }
  if (!(inherits(x, "numeric") || inherits(x, "integer"))) {
    stop("x must be numeric")
  }
  if (!inherits(y, "numeric")) {
    stop("y must be numeric")
  }

  # calculate the trapezoidal area for each segment
  areas <- (y[1:(length(y) - 1)] + y[2:length(y)]) * (x[2:length(x)] - x[1:(length(x) - 1)]) / 2

  # return the cumulative sum of the areas along the x-axis
  # Value is the cumulative area at point x.
  # It will always start with 0.
  return(c(0, cumsum(areas)))
}

#' Utility function to calculate the age-specific survival probability from a survivorship curve
#'
#' @param Sx A numeric vector representing the survivorship curve.
#' @return A numeric value representing the survival probability.
#' @examples
#' survival_probability_from_survivorship(c(1, 0.8, 0.6, 0.4, 0.2, 0.1))
#' @noRd
survival_probability_from_survivorship <- function(Sx) {
  if (max(diff(Sx)) > 0) {
    stop("The survivorship curve (Sx) cannot increase. Check your data.")
  }
  if (!inherits(Sx, "numeric")) {
    stop("Sx must be numeric")
  }
  if (length(Sx) < 2) {
    stop("Sx must be a vector of length 2+")
  }

  Sx_1 <- Sx[1:(length(Sx) - 1)]
  Sx_2 <- Sx[2:length(Sx)]
  return(c(Sx_2 / Sx_1, NA))
}


#' Model survival data using a mortality model
#'
#' @param x Numeric vector representing age.
#' @param params Numeric vector representing the parameters of the mortality model.
#' @param model Mortality model: `Gompertz`, `GompertzMakeham`, `Exponential`,
#'   `Siler`.
#' @return A data frame with columns for time (`x`), hazard (`hx`), cumulative
#'   hazard (`Hx`), survivorship (`Sx`) and survival probability within interval
#'   (`gx`).
#' @details The required parameters varies depending on the mortality model. The
#'   parameters are provided as a vector. For Gompertz, the parameters are b0,
#'   b1. For Gompertz-Makeham the parameters are b0, b1 and C. For Exponential,
#'   the parameter is C. For Siler, the parameters are a0,a1, C, b0 and b1.
#' @examples
#' model_survival(0:10,c(0.1,0.2),"Gompertz")
#' @export
model_survival <- function(x, params, model) {
  #Validation
  if(!(inherits(x, "integer")||inherits(x, "numeric"))){
    stop("x must be integer or numeric")
  }
  if(min(diff(x))<=0){
    stop("x must be an increasing sequence (it represents advancing age)")
  }
  if(!model %in% c("Gompertz", "GompertzMakeham", "Exponential", "Siler")){
    stop("model type not recognised")
  }

  # hazard
  if(model == "Gompertz"){
    #Validate parameters
    if(length(params)!=2){stop("For a Gompertz model, 2 parameters are required.")}

    b0 <- params[1]
    b1 <- params[2]

    hx <- b0 * exp(b1 * x)}

  if(model == "Exponential"){
    #Validate parameters
    if(length(params)!=1){stop("For an Exponential model, 1 parameter is required.")}

    b0 <- params[1]

    hx <- rep(b0, length(x))}

  if(model == "GompertzMakeham"){
    #Validate parameters
    if(length(params)!=3){stop("For a Gompertz-Makeham model, 3 parameters are required.")}

    b0 <- params[1]
    b1 <- params[2]
    C <- params[3]

    hx <- b0 * exp(b1 * x) + C}

  if(model == "Siler"){
    #Validate parameters
    if(length(params)!=5){stop("For a Siler model, 5 parameters are required.")}

    a0 <- params[1]
    a1 <- params[2]
    C <- params[3]
    b0 <- params[4]
    b1 <- params[5]

    hx <- a0 * exp(-a1 * x) + C + b0 * exp(b1 * x)}

  # Cumulative hazard (Hx)
  Hx <- cumulative_auc(x = x, y = hx)

  # Survivorship (Sx)
  Sx <- exp(-Hx)

  # Survival probability within interval x[n], x[n+1]
  gx <- survival_probability_from_survivorship(Sx)

  out <- data.frame(x, hx, Hx, Sx, gx)
  return(out)
}

