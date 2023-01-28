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


#' Model survival data using the Gompertz function
#'
#' @param x Numeric vector representing age.
#' @param b0 Numeric value representing the baseline hazard rate.
#' @param b1 Numeric value representing the shape parameter.
#' @return A data frame with columns for time (x), hazard (hx), cumulative hazard (Hx), survivorship (Sx) and survival probability within interval (gx).
#' @examples
#' gompertz(0:10, 0.01, 0.5)
#' @export
gompertz <- function(x, b0, b1) {
  # hazard
  hx <- b0 * exp(b1 * x)

  # Cumulative hazard (Hx)
  Hx <- cumulative_auc(x = x, y = hx)

  # Survivorship (Sx)
  Sx <- exp(-Hx)

  # Survival probability within interval x[n], x[n+1]
  gx <- survival_probability_from_survivorship(Sx)

  out <- data.frame(x, hx, Hx, Sx, gx)
  return(out)
}


#' Model survival data using the Exponential function
#'
#' @param x Numeric vector representing age.
#' @param b0 Numeric value representing the hazard rate parameter.
#' @return A data frame with columns for time (x), hazard (hx), cumulative hazard (Hx), survivorship (Sx) and survival probability within interval (gx).
#' @examples
#' exponential(0:10, 0.01)
#' @export
exponential <- function(x, b0) {
  # hazard
  hx <- rep(b0, length(x))

  # Cumulative hazard (Hx)
  Hx <- cumulative_auc(x = x, y = hx)

  # Survivorship (Sx)
  Sx <- exp(-Hx)

  # Survival probability within interval x[n], x[n+1]
  gx <- survival_probability_from_survivorship(Sx)

  out <- data.frame(x, hx, Hx, Sx, gx)
  return(out)
}


#' Model survival data using the Gompertz-Makeham function
#'
#' @param x Numeric vector representing age.
#' @param b0 Numeric value representing the baseline hazard rate.
#' @param b1 Numeric value representing the Gompertz shape parameter.
#' @param C Numeric value representing the Makeham constant.
#' @return A data frame with columns for time (x), hazard (hx), cumulative hazard (Hx), survivorship (Sx) and survival probability within interval (gx).
#' @examples
#' gompertz_makeham(0:10, 0.01, 0.5, 0.1)
#' @export
gompertz_makeham <- function(x, b0, b1, C) {
  hx <- b0 * exp(b1 * x) + C

  # Cumulative hazard (Hx)
  Hx <- cumulative_auc(x = x, y = hx)

  # Survivorship (Sx)
  Sx <- exp(-Hx)

  # Survival probability within interval x[n], x[n+1]
  gx <- survival_probability_from_survivorship(Sx)

  out <- data.frame(x, hx, Hx, Sx, gx)
  return(out)
}

#' Compute Siler Model
#'
#' @param x a numeric vector representing time
#' @param a0 a numeric value representing the first parameter of the hazard function
#' @param a1 a numeric value representing the second parameter of the first exponential term of the hazard function
#' @param C a numeric value representing the constant term of the hazard function
#' @param b0 a numeric value representing the third parameter of the hazard function
#' @param b1 a numeric value representing the fourth parameter of the second exponential term of the hazard function
#'
#' @return A data frame with columns for time (x), hazard (hx), cumulative hazard (Hx), survivorship (Sx) and survival probability within interval (gx).
#' @examples
#' siler(0:10, a0 = 0.5, a1 = 0.2, C = 0.1, b0 = 0.1, b1 = 0.2)
#'
#' @export

siler <- function(x, a0, a1, C, b0, b1) {
  hx <- a0 * exp(-a1 * x) + C + b0 * exp(b1 * x)

  # Cumulative hazard (Hx)
  Hx <- cumulative_auc(x = x, y = hx)

  # Survivorship (Sx)
  Sx <- exp(-Hx)

  # Survival probability within interval x[n], x[n+1]
  gx <- survival_probability_from_survivorship(Sx)

  out <- data.frame(x, hx, Hx, Sx, gx)
  return(out)
}
