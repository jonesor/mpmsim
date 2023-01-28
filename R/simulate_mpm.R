#' Simulate survival probability
#'
#' @param prob_survival true survival probability
#' @param sample_size sample size
#' @return mean survival probability based on the simulated data
#' @examples
#' simulate_survival(0.8, 100)
#' simulate_survival(0.5, 1000)
#' @noRd
simulate_survival <- function(prob_survival, sample_size) {
  mean(rbinom(sample_size, 1, prob_survival))
}

#' Simulate reproduction (fecundity)
#'
#' @param mean_fecundity mean value for reproductive output
#' @param sample_size sample size
#' @return mean fecundity based on the simulated data
#' @examples
#' simulate_fecundity(2, 100)
#' simulate_fecundity(5, 1000)
#' @noRd
simulate_fecundity <- function(mean_fecundity, sample_size) {
  mean(rpois(sample_size, mean_fecundity))
}

#' Simulate matrix population models (MPMs) based on expected transition rates
#' and sample sizes
#'
#' Simulates a matrix population model based on expected values in the
#' transition matrix. The expected values are provided in two matrices `mat_U`
#' for the growth/development and survival transitions and `mat_F` for the
#' fecundity transitions.The `mat_U` values are simulated based on expected
#' probabilities, assuming a binomial process with a sample size defined by
#' `sample_size`. The `mat_F` values are simulated using a Poisson process with
#' a sample size defined by `sample_size`.Thus users can expect that large
#' sample sizes will result in simulated matrices that match closely with the
#' expectations, while simulated matrices with small sample sizes will be more
#' variable.
#'
#' @param mat_U matrix of survival probabilities
#' @param mat_F matrix of mean fecundity values
#' @param sample_size matrix of sample size for each element of the matrix, or a
#'   single value applied to the whole matrix
#' @param split logical, whether to split the output into survival and fecundity
#'   matrices or not
#' @return list of matrices of survival and fecundity if split = TRUE, otherwise
#'   a single matrix of the sum of survival and fecundity
#' @examples
#' mats <- make_leslie_matrix(
#'   survival = c(0.1, 0.2, 0.5),
#'   fertility = c(0, 1.2, 2.4),
#'   n_stages = 3, split = TRUE
#' )
#' ssMat <- matrix(10, nrow = 3, ncol = 3)
#'
#' simulate_mpm(
#'   mat_U = mats$mat_U, mat_F = mats$mat_F,
#'   sample_size = ssMat, split = TRUE
#' )
#' @export simulate_mpm
#'
simulate_mpm <- function(mat_U, mat_F, sample_size, split = TRUE) {
  # Validation
  if (!inherits(mat_U, "matrix")) {
    stop("mat_U needs to be a matrix")
  }

  if (!inherits(mat_F, "matrix")) {
    stop("mat_F needs to be a matrix")
  }

  if (nrow(mat_U) != nrow(mat_F)) {
    stop("the dimensions of mat_U and mat_F are not equal")
  }

  if (nrow(mat_U) != ncol(mat_U)) {
    stop("mat_U is not a square matrix")
  }

  if (nrow(mat_F) != ncol(mat_F)) {
    stop("mat_U is not a square matrix")
  }


  if (!(inherits(sample_size, "matrix") || length(sample_size) == 1)) {
    stop("sample_size needs to be a matrix, or an integer with length 1")
  }

  if (inherits(sample_size, "matrix")) {
    if (nrow(sample_size) != nrow(mat_U)) {
      stop("if sample_size is a matrix,
           it should be the same dimension as mat_U")
    }
  }

  if (!all(mat_U >= 0)) {
    stop("mat_U must include only values >= 0")
  }

  if (!all(mat_F >= 0)) {
    stop("mat_F must include only values >= 0")
  }

  if (!all(sample_size > 0)) {
    stop("sample_size must include only values > 0")
  }

  if (!is.logical(split)) {
    stop("split must be a logical value (TRUE/FALSE).")
  }

  if (!min(abs(c(sample_size %% 1, sample_size %% 1 - 1))) <
    .Machine$double.eps^0.5) {
    stop("sample_size must be integer value(s)")
  }

  if (!min(sample_size) > 0) {
    stop("sample_size must be > 0")
  }

  # Convert the matrix into a vector
  u_matrix_vector <- as.vector(mat_U)
  f_matrix_vector <- as.vector(mat_F)

  if (length(sample_size) == 1) {
    sample_size <- matrix(sample_size, ncol = ncol(mat_U), nrow = nrow(mat_U))
  }

  sample_size_vector <- as.vector(sample_size)

  # Simulate the matrix based on the information provided
  survival_results <- mapply(
    FUN = simulate_survival, prob_survival = u_matrix_vector,
    sample_size = sample_size_vector
  )

  fecundity_results <- mapply(
    FUN = simulate_fecundity, mean_fecundity = f_matrix_vector,
    sample_size = sample_size_vector
  )

  mat_U_out <- matrix(survival_results,
    nrow = sqrt(length(u_matrix_vector)),
    ncol = sqrt(length(u_matrix_vector))
  )
  mat_F_out <- matrix(fecundity_results,
    nrow = sqrt(length(f_matrix_vector)),
    ncol = sqrt(length(u_matrix_vector))
  )

  if (split) {
    return(list(mat_U = mat_U_out, mat_F = mat_F_out))
  } else {
    return(mat_U_out + mat_F_out)
  }
}
