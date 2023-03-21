#' Compute confidence intervals for derived estimates
#'
#' This function estimates the 95% confidence interval for measures derived from
#' a matrix population model. The inputs are the U matrix, which describes the
#' growth and survival process, and the F matrix which describes reproduction.
#' The underlying assumption is that the U matrix is the average of a binomial
#' process while the F matrix is the average of a Poisson process (see the
#' function `simulate_mpm()` for details). The confidence interval will depend
#' largely on the sample size used.
#'
#' @param mat_U A matrix that describes the growth and survival process.
#' @param mat_F A matrix that describes reproduction.
#' @param sample_size An integer or a matrix of integers indicating the sample
#'   size(s) to use for the simulation.
#' @param FUN A function to apply to each simulated matrix population model.
#'   This function must take, as input, a single matrix population model (i.e.,
#'   the A matrix).
#' @param ... Additional arguments to be passed to FUN.
#' @param n_sim An integer indicating the number of simulations to run. Default
#'   is 1000.
#' @param dist.out Logical. If TRUE, returns a list with both the quantiles and
#'   the simulated estimates. Default is FALSE.
#'
#' @return If dist.out is FALSE, a numeric vector of the 2.5th and 97.5th
#'   quantiles of the estimated measures. If dist.out is TRUE, a list with two
#'   elements: "quantiles" and "estimates". "quantiles" is a numeric vector of
#'   the 2.5th and 97.5th quantiles of the estimated measures, and "estimates"
#'   is a numeric vector of the estimated measures.
#'
#' @examples
#' # Data for use in example
#' matU <- matrix(c(
#'   0.1, 0.0,
#'   0.2, 0.4
#' ), byrow = TRUE, nrow = 2)
#'
#' matF <- matrix(c(
#'   0.0, 3.0,
#'   0.0, 0.0
#' ), byrow = TRUE, nrow = 2)
#'
#' # Example of use to calculate 95% CI of lambda
#' compute_ci(
#'   mat_U = matU, mat_F = matF, sample_size = 10, FUN =
#'     popdemo::eigs, what = "lambda"
#' )
#'
#' # Example of use to calculate 95% CI of generation time
#' compute_ci(
#'   mat_U = matU, mat_F = matF, sample_size = 10, FUN =
#'     popbio::generation.time
#' )
#'
#' # Example of use to calculate 95% CI of generation time,
#' xx <- compute_ci(
#'   mat_U = matU, mat_F = matF, sample_size = 100, FUN =
#'     popbio::generation.time, dist.out = TRUE
#' )
#' summary(xx$quantiles)
#' hist(xx$estimates)
#'
#' @importFrom stats quantile
#' @importFrom popdemo eigs
#' @importFrom popbio generation.time
#'
#' @author Owen Jones <jones@biology.sdu.dk>
#'
#' @export
#'
compute_ci <- function(mat_U, mat_F, sample_size, FUN, ..., n_sim = 1000, dist.out = FALSE) {

  # Validation of inputs
  # Check input matrices
  if (!is.matrix(mat_U) || !is.matrix(mat_F)) {
    stop("mat_U and mat_F must be matrices.")
  }
  if (!identical(dim(mat_U), dim(mat_F))) {
    stop("mat_U and mat_F must have the same dimensions.")
  }

  if (!dim(mat_F)[1] == dim(mat_F)[2]) {
    stop("mat_U and mat_F must be square matrices.")
  }
  if (!dim(mat_U)[1] == dim(mat_U)[2]) {
    stop("mat_U and mat_F must be square matrices.")
  }

  # Check sample_size argument
  if (!is.numeric(sample_size) || any(sample_size < 0)) {
    stop("sample size must non-negatives")
  }

  # Check that sample_size is an integer
  if (!min(abs(c(sample_size %% 1, sample_size %% 1 - 1))) <
    .Machine$double.eps^0.5) {
    stop("sample_size must be an integer or a matrix of integers")
  }

  # Check FUN argument
  if (!is.function(FUN)) {
    stop("FUN must be a function.")
  }

  # replicate the simulation of MPMs
  sim_out <- replicate(n_sim, simulate_mpm(mat_U,
    mat_F,
    sample_size,
    split = FALSE
  ),
  simplify = FALSE
  )

  # apply the function FUN to each matrix
  estimates <- sapply(sim_out, FUN, ...)

  # Check the estimates and use warnings if necessary
  if (any(is.infinite(estimates))) {
    warning("Some estimates are Inf. \n
            Try running with argument `dist.out = TRUE` and examine the estimates.")
  }

  emp_quantiles <- quantile(estimates, c(0.025, 0.975), na.rm = TRUE)

  if (dist.out == FALSE) {
    return(emp_quantiles)
  }
  if (dist.out == TRUE) {
    out <- list("quantiles" = emp_quantiles, "estimates" = estimates)
    return(out)
  }
}
