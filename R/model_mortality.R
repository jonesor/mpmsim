#' Model mortality hazard, survivorship and age-specific survival probability
#' using a mortality model
#'
#' Generates an actuarial life table based on a defined mortality model.
#'
#' @param params Numeric vector representing the parameters of the mortality
#'   model.
#' @param model A character string specifying the name of the mortality model to
#'   be used. Options are `gompertz`, `gompertzmakeham`, `exponential`, `siler`,
#'   `weibull`, and `weibullmakeham`. These names are not case-sensitive.
#' @param age Numeric vector representing age. The default is `NULL`, whereby
#'   the survival trajectory is modelled from age 0 to the age at which the
#'   survivorship of the synthetic cohort declines to a threshold defined by the
#'   `truncate` argument, which has a default of `0.01` (i.e. 1% of the cohort
#'   remaining alive).
#' @param truncate a value defining how the life table output should be
#'   truncated. The default is `0.01`, indicating that the life table is
#'   truncated so that survivorship (`lx`) > 0.01 (i.e. the age at which 1% of
#'   the cohort remains alive).
#' @return A dataframe in the form of a lifetable with columns for age (`x`),
#'   hazard (`hx`), survivorship (`lx`) and mortality (`qx`) and survival
#'   probability within interval (`px`).
#' @details The required parameters varies depending on the mortality model. The
#'   parameters are provided as a vector.
#'
#'   *For `gompertz` and `weibull`, the
#'   parameters are `b0`, `b1`.
#'   *For `gompertzmakeham` and `weibullmakeham` the parameters are `b0`, `b1`
#'   and `C`.
#'   *For `exponential`, the parameter is `C`.
#'   *For `siler`, the parameters are `a0`, `a1`, `C`, `b0` and `b1`.
#'
#'   Note that the parameters must be provided in the order mentioned here. `x`
#'   represents age.
#'
#'   * Gompertz: \eqn{h_x = b_0 \mathrm{e}^{b_1  x}}
#'   * Gompertz-Makeham: \eqn{h_x = b_0 \mathrm{e}^{b_1  x} + c}
#'   * Exponential: \eqn{h_x = c}
#'   * Siler: \eqn{h_x = a_0 \mathrm{e}^{-a_1  x} + c + b_0 \mathrm{e}^{b_1 x}}
#'   * Weibull: \eqn{h_x = b_0  b_1  (b_1  x)^(b_0 - 1)}
#'   * Weibull-Makeham: \eqn{h_x = b_0  b_1  (b_1  x)^(b_0 - 1) + c}
#'
#'   In the output, the probability of survival (`px`) (and death (`qx`))
#'   represent the probability of individuals that enter the age interval
#'   \eqn{[x,x+1]} survive until the end of the interval (or die before the end
#'   of the interval). It is not possible to estimate a value for this in the
#'   final row of the life table (because there is no \eqn{x+1} value) and
#'   therefore the input values of `age` (x) may need to be extended to capture
#'   this final interval.
#'
#' @author Owen Jones <jones@biology.sdu.dk>
#' @family trajectories
#' @references Cox, D.R. & Oakes, D. (1984) Analysis of Survival Data. Chapman
#'   and Hall, London, UK.
#'
#'   Pinder III, J.E., Wiener, J.G. & Smith, M.H. (1978) The Weibull
#'   distribution: a method of summarizing survivorship data. Ecology, 59,
#'   175–179.
#'
#'   Pletcher, S. (1999) Model fitting and hypothesis testing for age-specific
#'   mortality data. Journal of Evolutionary Biology, 12, 430–439.
#'
#'   Siler, W. (1979) A competing-risk model for animal mortality. Ecology, 60,
#'   750–757.
#'
#'   Vaupel, J., Manton, K. & Stallard, E. (1979) The impact of heterogeneity in
#'   individual frailty on the dynamics of mortality. Demography, 16, 439–454.
#'
#' @examples
#' model_mortality(params = c(b_0 = 0.1, b_1 = 0.2), model = "Gompertz")
#'
#' model_mortality(
#'   params = c(b_0 = 0.1, b_1 = 0.2, C = 0.1),
#'   model = "GompertzMakeham",
#'   truncate = 0.1
#' )
#'
#' model_mortality(params = c(c = 0.2), model = "Exponential", age = 0:10)
#'
#' model_mortality(
#'   params = c(a_0 = 0.1, a_1 = 0.2, C = 0.1, b_0 = 0.1, b_1 = 0.2),
#'   model = "Siler",
#'   age = 0:10
#' )
#'
#' model_mortality(
#'   params = c(b_0 = 1.4, b_1 = 0.18),
#'   model = "Weibull"
#' )
#'
#' model_mortality(
#'   params = c(b_0 = 1.1, b_1 = 0.05, c = 0.2),
#'   model = "WeibullMakeham"
#' )
#'
#' @seealso [model_fertility()] to model age-specific fertility using various
#'   functions.
#' @export
model_survival <- function(params, age = NULL, model, truncate = 0.01) {
  # Coerce model type to lower case to avoid irritation
  model <- tolower(model)

  if (is.null(age)) {
    age <- 0:1000
  }

  # Validation
  if (!is.numeric(age)) stop("Input 'age' must be a numeric vector.")

  if (min(age) < 0) stop("Input 'age' must be non-negative.")

  if (any(age != floor(age))) warning("Input 'age' must be integers for
                                      use in creating MPMs")

  if (min(diff(age)) <= 0) {
    stop("age must be an increasing sequence")
  }

  if (!model %in% tolower(c(
    "Gompertz", "GompertzMakeham", "Exponential",
    "Siler", "Weibull", "WeibullMakeham"
  ))) {
    stop("model type not recognised")
  }
  if (!inherits(truncate, "numeric")) {
    stop("truncate must be a numeric value")
  }
  if (truncate < 0 || truncate > 1) {
    stop("truncate must be between 0 and 1")
  }

  # hazard
  if (model == "gompertz") {
    # Validate parameters
    if (length(params) != 2) {
      stop("For a Gompertz model, 2 parameters are required.")
    }

    b0 <- params[1]
    b1 <- params[2]

    hx <- b0 * exp(b1 * age)
  }

  if (model == "exponential") {
    # Validate parameters
    if (length(params) != 1) {
      stop("For an Exponential model, 1 parameter is required.")
    }

    b0 <- params[1]

    hx <- rep(b0, length(age))
  }

  if (model == "gompertzmakeham") {
    # Validate parameters
    if (length(params) != 3) {
      stop("For a Gompertz-Makeham model, 3 parameters are required.")
    }

    b0 <- params[1]
    b1 <- params[2]
    C <- params[3]

    hx <- b0 * exp(b1 * age) + C
  }

  if (model == "siler") {
    # Validate parameters
    if (length(params) != 5) {
      stop("For a Siler model, 5 parameters are required.")
    }

    a0 <- params[1]
    a1 <- params[2]
    C <- params[3]
    b0 <- params[4]
    b1 <- params[5]

    hx <- a0 * exp(-a1 * age) + C + b0 * exp(b1 * age)
  }

  if (model == "weibull") {
    # Validate parameters
    if (length(params) != 2) {
      stop("For a Weibull model, 2 parameters are required.")
    }

    b0 <- params[1]
    b1 <- params[2]

    hx <- b0 * b1 * (b1 * age)^(b0 - 1)
  }

  if (model == "weibullmakeham") {
    # Validate parameters
    if (length(params) != 3) {
      stop("For a Weibull-Makeham model, 3 parameters are required.")
    }

    b0 <- params[1]
    b1 <- params[2]
    C <- params[3]

    hx <- b0 * b1 * (b1 * age)^(b0 - 1) + C
  }

  # Cumulative hazard (Hx)
  Hx <- cumulative_auc(x = age, y = hx)

  # Survivorship (lx)
  lx <- exp(-Hx)

  # Survival probability within interval x[n], x[n+1]
  px <- calculate_surv_prob(lx)
  qx <- 1 - px
  x <- age
  temp_df <- data.frame(x, hx, lx, qx, px)
  out <- subset(temp_df, lx >= truncate)
  return(out)
}

#' @rdname model_survival
#' @examples
#' model_mortality(params = c(b_0 = 0.1, b_1 = 0.2), model = "Gompertz")
#' @export
model_mortality <- model_survival

#' Utility function to calculate the cumulative area under the curve (AUC) from
#' x and y data
#'
#' @param x Numeric or Integer vector representing the x-axis values. It must
#'   have the same length as y.
#' @param y Numeric vector representing the y-axis values. It must have the same
#'   length as x.
#' @return A numeric vector representing the cumulative AUC at each point along
#'   the x-axis. The first element of the vector will always be 0.
#' @author Owen Jones <jones@biology.sdu.dk>
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
  areas <- (y[1:(length(y) - 1)] + y[2:length(y)]) *
    (x[2:length(x)] - x[1:(length(x) - 1)]) / 2

  # return the cumulative sum of the areas along the x-axis
  # Value is the cumulative area at point x.
  # It will always start with 0.
  return(c(0, cumsum(areas)))
}

#' Utility function to calculate the age-specific survival probability from a
#' survivorship curve
#'
#' @param lx A numeric vector representing the survivorship curve.
#' @return A numeric value representing the survival probability.
#' @author Owen Jones <jones@biology.sdu.dk>
#' @examples
#' calculate_surv_prob(c(1, 0.8, 0.6, 0.4, 0.2, 0.1))
#' @noRd
calculate_surv_prob <- function(lx) {
  if (length(lx) < 2) {
    stop("lx must be a vector of length 2+")
  }
  if (!inherits(lx, "numeric")) {
    stop("lx must be numeric")
  }
  if (max(diff(lx)) > 0) {
    stop("The survivorship curve (lx) cannot increase. Check your data.")
  }

  lx_1 <- lx[1:(length(lx) - 1)]
  lx_2 <- lx[2:length(lx)]
  return(c(lx_2 / lx_1, NA))
}
