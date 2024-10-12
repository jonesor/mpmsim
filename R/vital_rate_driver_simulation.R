#' Logit function
#'
#' The logit function takes a numeric input \code{p} and applies the logit
#' transformation to it, which maps the input to a value between -Inf and Inf.
#'
#' @param p A numeric input between 0 and 1.
#'
#' @return A numeric output between -Inf and Inf.
#'
#' @examples
#' logit(0.5) # 0
#' logit(0.8) # 1.386294
#' logit(0.2) # -1.386294
#'
#' @author Owen Jones <jones@biology.sdu.dk>
#' @family utility
#' @noRd
logit <- function(p) {
  if (!inherits(p, "numeric")) {
    stop("x must be numeric")
  }
  if (any(p < 0) || any(p > 1)) {
    stop("Input must be between 0 and 1.")
  }
  return(log(p / (1 - p)))
}

#' Inverse logit
#'
#' The inverse logit function takes a numeric input \code{x} and applies the
#' inverse of the logistic function to it, which maps the input to a value
#' between 0 and 1.
#'
#' @param x A numeric input.
#'
#' @return A numeric output between 0 and 1.
#'
#' @examples
#' inverse_logit(0) # 0.5
#' inverse_logit(1) # 0.7310586
#' inverse_logit(-1) # 0.2689414
#'
#' @author Owen Jones <jones@biology.sdu.dk>
#' @family utility
#' @noRd
inverse_logit <- function(x) {
  if (!inherits(x, "numeric")) {
    stop("x must be numeric")
  }
  return(1 / (1 + exp(-x)))
}


#' Calculate driven vital rates
#'
#' This function calculates new values for a vital rate, such as survival or
#' fecundity that is being influenced by a driver (e.g., weather). It does this
#' by using a driver variable and a baseline value, along with a specified slope
#' for the relationship between the driver variable and the vital rate. The
#' function works on a linearised scale, using logit for survival and log for
#' fecundity, and takes into account the error standard deviation.
#'
#' The relationship between the driver variable and the vital rate is assumed to
#' be linear:
#'
#' $$V = a * (d - d_b) + x + E$$
#'
#' Where $$V$$ is the new vital rate (on the scale of the linear predictor),
#' $$a$$ is the slope, $$x$$ is the baseline vital rate, $$d$$ is the driver,
#' $$d_b$$ is the baseline driver and $$E$$ is the error.
#'
#' The input vital rate(s) (`baseline_value`) can be a single-element vector
#' representing a single vital rate (e.g., survival probability or fecundity), a
#' longer vector representing a series of vital rates (e.g., several survival
#' probabilities or fecundity values), or a matrix of values (e.g., a U or F
#' submatrix of a matrix population model). The `slope`s of the relationship
#' between the vital rate (`baseline_value`) and the driver can be provided as a
#' single value, which is applied to all elements of the input vital rates, or
#' as a matrix of values that map onto the matrix of vital rates. This allows
#' users to simulate cases where different vital rates in a matrix model are
#' affected in different ways by the same weather driver. For example, juvenile
#' survival might be more affected by the driver than adult survival. The
#' `baseline_driver` value represents the "normal" state of the driver. If the
#' driver is greater than the `baseline_driver` and the `slope` is positive,
#' then the outcome vital rate will be higher. If the driver is less than the
#' `baseline_driver` variable and the `slope` is positive, then the outcome
#' vital rate will be less than the `baseline_value.` The `error_sd` represents
#' the error in the linear relationship between the driver and the vital rate.
#'
#'
#' @param driver A vector of driver values.
#' @param baseline_value A vector or matrix of baseline values for the vital
#'   rate (e.g., survival) that is being influenced ("driven") by another
#'   variable (e.g. a climatic variable).
#' @param slope A vector or matrix of slopes for the relationship between the
#'   driver variable and the vital rate being driven.
#' @param baseline_driver The `baseline_driver` parameter is a single value
#'   representing the baseline driver value. If the driver value is greater than
#'   this value and the slope is positive, then the resulting vital rate will be
#'   higher. Conversely, if the driver value is less than this variable and the
#'   slope is positive, then the resulting vital rate will be less than the
#'   baseline value.
#' @param error_sd A vector or matrix of error standard deviations for random
#'   normal error to be added to the driven value of the vital rate being
#'   modelled. If set to 0 (the default), no error is added.
#' @param link A character string indicating the type of link function to use.
#'   Valid values are "`logit`" (the default) and "`log`", which are appropriate
#'   for survival (U submatrix) and fecundity (F submatrix) respectively.
#'
#' @return Depending on the input types, either a single value, a vector or a
#'   list of matrices of driven values for the vital rate(s) being modelled. The
#'   list has a length equal to the length of the \code{driver} input parameter.
#'
#' @author Owen Jones <jones@biology.sdu.dk>
#' @family drivers
#' @export driven_vital_rate
#' @importFrom stats rnorm
#' @examples
#' set.seed(42) # set seed for repeatability
#'
#' # A single vital rate and a single driver
#' driven_vital_rate(
#'   driver = 14,
#'   baseline_value = 0.5,
#'   slope = .4,
#'   baseline_driver = 10,
#'   error_sd = 0,
#'   link = "logit"
#' )
#'
#' # A single vital rate and a time series of drivers
#' driven_vital_rate(
#'   driver = runif(10, 5, 15),
#'   baseline_value = 0.5,
#'   slope = .4,
#'   baseline_driver = 10,
#'   error_sd = 0,
#'   link = "logit"
#' )
#'
#' # A matrix of survival values (U submatrix of a Leslie model)
#' # with a series of drivers, and matrices of slopes and errors
#'
#' lt1 <- model_survival(params = c(b_0 = 0.4, b_1 = 0.5), model = "Gompertz")
#' lt1$fecundity <- model_fecundity(
#'   age = 0:max(lt1$x), params = c(A = 10),
#'   maturity = 3, model = "step"
#' )
#'
#' mats <- make_leslie_mpm(
#'   survival = lt1$px, fecundity = lt1$fecundity, n_stages =
#'     nrow(lt1), split = TRUE
#' )
#' mats$mat_U
#' mat_dim <- nrow(mats$mat_U)
#'
#' driven_vital_rate(
#'   driver = runif(5, 5, 15),
#'   baseline_value = mats$mat_U,
#'   slope = matrix(.4,
#'     nrow = mat_dim,
#'     ncol = mat_dim
#'   ),
#'   baseline_driver = 10,
#'   error_sd = matrix(1, nrow = mat_dim, ncol = mat_dim),
#'   link = "logit"
#' )
#'
driven_vital_rate <- function(driver, # vector (can be a single element)
                              baseline_value = NULL, # element, or matrix
                              slope = NULL, # element, or matrix
                              baseline_driver = NULL, # element
                              error_sd = 0,
                              link = "logit") { # element, or matrix

  # Input validation
  # driver
  if (!is.numeric(driver)) {
    stop("driver must be a vector of numeric values.")
  }
  if (anyNA(driver)) {
    stop("driver must not have NA values.")
  }

  # baseline_value
  if (!is.matrix(baseline_value) && !(is.vector(baseline_value) &&
    length(baseline_value) == 1)) {
    stop("baseline_value must be either a matrix or a vector of length 1.")
  }
  if (anyNA(baseline_value)) {
    stop("baseline_value must not have NA values.")
  }
  if (any(baseline_value < 0)) {
    stop("baseline_value must be a greater than or equal to zero.")
  }
  if (link == "logit") {
    if (any(baseline_value > 1)) {
      stop("baseline_value must be between 0 and 1, if link is logit.")
    }
  }

  # slope
  if (!is.matrix(slope) && !(is.vector(slope) && length(slope) == 1)) {
    stop("slope must be either a matrix or a vector of length 1.")
  }
  if (anyNA(slope)) {
    stop("slope must not have NA values.")
  }

  # baseline_driver
  if (!is.numeric(baseline_driver) || length(baseline_driver) != 1) {
    stop("baseline_driver must be a numeric vector of length 1.")
  }

  # error_sd
  if (!is.matrix(error_sd) && !(is.vector(error_sd) &&
    length(error_sd) == 1)) {
    stop("error_sd must be either a matrix or a vector of length 1.")
  }
  if (anyNA(error_sd)) {
    stop("error_sd must not have NA values.")
  }
  if (any(error_sd < 0)) {
    stop("error_sd must be a greater than or equal to zero.")
  }

  # link
  if (!is.character(link)) {
    stop("link must be a character string with a value of 'logit' or 'log'.")
  }
  if (!length(link) == 1) {
    stop("link must be a character string with a value of 'logit' or 'log'.")
  }
  if (!any(link %in% c("logit", "log"))) {
    stop("link must be a character string with a value of 'logit' or 'log'.")
  }


  # Vectorise all matrices as necessary
  baseline_value_vect <- as.vector(baseline_value)

  if (length(slope > 1)) {
    slope_vect <- as.vector(slope)
  } else {
    slope_vect <- rep(slope, length(baseline_value_vect))
  }

  if (length(error_sd > 1)) {
    error_sd_vect <- as.vector(error_sd)
  } else {
    error_sd_vect <- rep(error_sd, length(baseline_value_vect))
  }

  # If link is logit, calculate baseline value (e.g. survival) on the logit
  # scale
  if (link == "logit") {
    baseline_value_lp <- logit(baseline_value_vect)
  }
  if (link == "log") {
    baseline_value_lp <- log(baseline_value_vect)
  }

  output <- list()

  for (i in seq_along(driver)) {
    driver_i <- driver[i]

    # calculate a new value for survival on the logit scale
    driven_value_vect <- slope_vect * (driver_i - baseline_driver) +
      baseline_value_lp

    # add error to the driven value of y.
    # if error_sd = 0 (the default) then no error is added because epsilon is 0.
    epsilon_vect <- rnorm(
      n = length(error_sd_vect),
      mean = 0,
      sd = error_sd_vect
    )
    # transform from the logit scale to natural scale

    if (link == "logit") {
      driven_value_vect <- inverse_logit(driven_value_vect + epsilon_vect)
    }
    if (link == "log") {
      driven_value_vect <- exp(driven_value_vect + epsilon_vect)
    }

    mat_dim <- sqrt(length(driven_value_vect))
    driven_surv_mat <- matrix(driven_value_vect,
      nrow = mat_dim, ncol = mat_dim
    )
    if (nrow(driven_surv_mat) == 1) {
      output[[i]] <- as.vector(driven_surv_mat)
    } else {
      output[[i]] <- driven_surv_mat
    }
  }

  if (length(output) == 1) {
    return(output[[1]])
  }
  if (length(output) > 1) {
    return(output)
  }
}
