#' Simulate survival probability
#'
#' @param prob_survival true survival probability
#' @param sample_size sample size
#' @return mean survival probability based on the simulated data
#' @author Owen Jones <jones@biology.sdu.dk>
#' @details if `sample_size` is 0, the output is simply `prob_survival`. i.e.
#'   it is assumed that the estimate is known without error.
#' @examples
#' simulate_survival(0.8, 100)
#' simulate_survival(0.5, 1000)
#' @noRd
simulate_survival <- function(prob_survival, sample_size) {
  if (sample_size == 0) {
    return(prob_survival)
  }
  if (sample_size > 0) {
    return(mean(rbinom(sample_size, 1, prob_survival)))
  }
}

#' Simulate reproduction (fecundity)
#'
#' @param mean_fecundity mean value for reproductive output
#' @param sample_size sample size
#' @return mean fecundity based on the simulated data
#' @details if `sample_size` is 0, the output is simply `mean_fecundity`. i.e.
#'   it is assumed that the estimate is known without error.
#' @author Owen Jones <jones@biology.sdu.dk>
#' @examples
#' simulate_fecundity(2, 100)
#' simulate_fecundity(5, 1000)
#' @noRd
simulate_fecundity <- function(mean_fecundity, sample_size) {
  if (sample_size == 0) {
    return(mean_fecundity)
  }
  if (sample_size > 0) {
    return(mean(rpois(sample_size, mean_fecundity)))
  }
}

#' Simulate a matrix population model (MPM) with sampling error based on
#' expected values of transition rates and sample sizes
#'
#' Simulates a matrix population model based on expected values in the
#' transition matrix. The expected values are provided in two matrices `mat_U`
#' for the growth/development and survival transitions and `mat_F` for the
#' fecundity transitions. The `mat_U` values are simulated based on expected
#' probabilities, assuming a binomial process with a sample size defined by
#' `sample_size`. The `mat_F` values are simulated using a Poisson process with
#' a sample size defined by `sample_size`.Thus users can expect that large
#' sample sizes will result in simulated matrices that match closely with the
#' expectations, while simulated matrices with small sample sizes will be more
#' variable.
#'
#' @param mat_U matrix of mean survival/growth probabilities
#' @param mat_F matrix of mean fecundity values
#' @param sample_size either (1) a single matrix of sample sizes for each
#'   element of the MPM, (2) a list of two named matrices ("`mat_F_ss`",
#'   "`mat_U_ss`") containing sample sizes for the survival and fertility
#'   submatrices of the MPM or (3) a single value applied to the whole matrix
#' @param split logical, whether to split the output into survival and fecundity
#'   matrices or not
#' @return list of matrices of survival and fecundity if `split = TRUE`,
#'   otherwise a single matrix of the sum of survival and fecundity
#' @details if any `sample_size` input is 0, it is assumed that the estimate for
#'   the element(s) concerned is known without error.
#' @author Owen Jones <jones@biology.sdu.dk>
#' @family errors
#' @examples
#' mats <- make_leslie_mpm(
#'   survival = c(0.1, 0.2, 0.5),
#'   fertility = c(0, 1.2, 2.4),
#'   n_stages = 3, split = TRUE
#' )
#' ssMat <- matrix(10, nrow = 3, ncol = 3)
#'
#' # Sample size is a single matrix
#' simulate_mpm(
#'   mat_U = mats$mat_U, mat_F = mats$mat_F,
#'   sample_size = ssMat, split = TRUE
#' )
#'
#' # Sample size is a single value
#' simulate_mpm(
#'   mat_U = mats$mat_U, mat_F = mats$mat_F,
#'   sample_size = 50, split = TRUE
#' )
#'
#' # Sample size is a list of two matrices
#' ssMats <- list(
#'   "mat_F_ss" = matrix(10, nrow = 3, ncol = 3),
#'   "mat_U_ss" = matrix(10, nrow = 3, ncol = 3)
#' )
#'
#' simulate_mpm(
#'   mat_U = mats$mat_U, mat_F = mats$mat_F,
#'   sample_size = ssMats, split = TRUE
#' )
#'
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

  # Sample size validation
  if (!(inherits(sample_size, "list") || inherits(sample_size, "matrix") ||
    length(sample_size) == 1)) {
    stop("sample_size needs to be a matrix, a list of two matrices,
         or an integer with length 1")
  }

  # When sample_size is a single matrix.
  if (inherits(sample_size, "matrix")) {
    if (nrow(sample_size) != nrow(mat_U)) {
      stop("if sample_size is a matrix,
           it should be the same dimension as mat_U")
    }
  }

  # When sample_size is a list of two matrices.
  if (inherits(sample_size, "list")) {
    if (!identical(
      lapply(sample_size, dim)[[1]],
      lapply(sample_size, dim)[[2]]
    )) {
      stop("if sample_size is a list of matrices,
           they should both be the same dimensions.")
    }
    if (!identical(lapply(sample_size, dim)[[1]], dim(mat_U))) {
      stop("if sample_size is a list of matrices,
           they should be the same dimension as mat_U")
    }
    if (!sum(names(sample_size) %in% c("mat_F_ss", "mat_U_ss")) == 2) {
      stop("if sample_size is a list of matrices,
           the names of the list entries need to be named
           'mat_F_ss' and 'mat_U_ss'")
    }
  }

  unlisted_sample_size <- unlist(sample_size)

  if (!min(abs(c(unlisted_sample_size %% 1, unlisted_sample_size %% 1 - 1))) <
    .Machine$double.eps^0.5) {
    stop("sample_size must be integer value(s)")
  }

  if (min(unlisted_sample_size) < 0) {
    stop("sample_size must be >= 0.")
  }

  if (!all(mat_U >= 0)) {
    stop("mat_U must include only values >= 0")
  }

  if (!all(mat_F >= 0)) {
    stop("mat_F must include only values >= 0")
  }

  if (!is.logical(split)) {
    stop("split must be a logical value (TRUE/FALSE).")
  }

  # Convert the matrix into a vector
  u_matrix_vector <- as.vector(mat_U)
  f_matrix_vector <- as.vector(mat_F)

  # If sample_size is a vector of length 1
  if (length(sample_size) == 1) {
    sample_size_mat_U <- matrix(sample_size,
      ncol = ncol(mat_U),
      nrow = nrow(mat_U)
    )
    sample_size_vector_U <- as.vector(sample_size_mat_U)
    sample_size_vector_F <- sample_size_vector_U
  }

  # If sample_size is a single matrix
  if (inherits(sample_size, "matrix")) {
    sample_size_vector_U <- as.vector(sample_size)
    sample_size_vector_F <- sample_size_vector_U
  }

  # If sample_size is a list of matrices
  if (inherits(sample_size, "list")) {
    sample_size_vector_U <- as.vector(sample_size[["mat_U_ss"]])
    sample_size_vector_F <- as.vector(sample_size[["mat_F_ss"]])
  }

  # Simulate the matrix based on the information provided
  survival_results <- mapply(
    FUN = simulate_survival, prob_survival = u_matrix_vector,
    sample_size = sample_size_vector_U
  )

  fecundity_results <- mapply(
    FUN = simulate_fecundity, mean_fecundity = f_matrix_vector,
    sample_size = sample_size_vector_F
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
