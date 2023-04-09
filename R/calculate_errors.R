#' Calculate error (standard error or 95%CI) in elements of a matrix population
#' model.
#'
#' Given two submatrices of a matrix population model (`mat_U` and `mat_F`, the
#' growth/survival matrix and the reproduction matrix respectively) and a sample
#' size, or matrix/matrices of sample sizes, this function calculates the
#' standard error or 95% confidence interval (95%CI) for each element of the
#' matrix. These calculations assume that `mat_U` is the result of binomial
#' processes (i.e., the survival (0/1) of a sample of n individuals), while
#' `mat_F` is the result of Poisson processes (i.e., counts of offspring from n
#' individuals), where n is the sample size.
#'
#' The output is a list containing the original matrices and matrices showing
#' error estimates or confidence intervals.
#'
#'
#' @param mat_U matrix of mean survival probabilities
#' @param mat_F matrix of mean fecundity values
#' @param sample_size either (1) a single matrix of sample sizes for each
#'   element of the MPM, (2) a list of two named matrices ("`mat_F_ss`",
#'   "`mat_U_ss`") containing sample sizes for the survival and fertility
#'   submatrices of the MPM or (3) a single value applied to the whole matrix
#' @param type A character string indicating the type of error to calculate.
#'   Must be one of "`sem`" (standard error), or "`CI95`" (95% confidence
#'   interval).
#' @param calculate_A A logical argument indicating whether the returned error
#'   information should include the A matrix and its error. Defaults to `TRUE`.
#'
#' @return A list containing the original matrices and the error estimates (or
#'   upper and lower confidence intervals) for the U, F and (optionally) A
#'   matrices.
#' @family errors
#' @examples
#' # Set up two submatrices
#' matU <- matrix(c(
#'   0.1, 0,
#'   0.2, 0.4
#' ), byrow = TRUE, nrow = 2)
#' matF <- matrix(c(
#'   0, 4,
#'   0., 0.
#' ), byrow = TRUE, nrow = 2)
#'
#' # errors as 95% CI, with a sample size of 20 for all elements
#' calculate_errors(mat_U = matU, mat_F = matF, sample_size = 20, type = "CI95")
#'
#' # errors as sem, with a sample size of 20 for all elements
#' calculate_errors(mat_U = matU, mat_F = matF, sample_size = 20, type = "sem")
#'
#' # Sample size is a single matrix applied to both F and U matrices
#' ssMat <- matrix(10, nrow = 2, ncol = 2)
#'
#' calculate_errors(
#'   mat_U = matU, mat_F = matF, sample_size = ssMat, type =
#'     "sem"
#' )
#'
#' # Sample size is a list of two matrices, one for F and one for U.
#' ssMats <- list(
#'   "mat_F_ss" = matrix(10, nrow = 2, ncol = 2),
#'   "mat_U_ss" = matrix(10, nrow = 2, ncol = 2)
#' )
#' calculate_errors(
#'   mat_U = matU, mat_F = matF, sample_size = ssMats, type =
#'     "sem"
#' )
#'
#' @author Owen Jones <jones@biology.sdu.dk>
#' @seealso [add_mpm_error()] which simulates matrices with known values and
#'   sample sizes.
#' @export calculate_errors
#'
calculate_errors <- function(mat_U, mat_F, sample_size, type = "sem",
                             calculate_A = TRUE) {
  # Validate inputs
  if (!is.matrix(mat_U)) {
    stop("mat_U must be a matrix.")
  }
  if (!is.matrix(mat_F)) {
    stop("mat_F must be a matrix.")
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

  if (type != "sem" && type != "CI95") {
    stop("type must be one of 'sem', 'sd', or 'CI95'.")
  }

  # Sample size matrices
  # If sample_size is a vector of length 1, apply that to both U and F matrices
  if (length(sample_size) == 1) {
    sample_size_mat_U <- matrix(sample_size,
      ncol = ncol(mat_U),
      nrow = nrow(mat_U)
    )
    sample_size_mat_F <- sample_size_mat_U
  }

  # If sample_size is a single matrix, use the same matrix for both U and F
  # Matrices
  if (inherits(sample_size, "matrix")) {
    sample_size_mat_U <- sample_size
    sample_size_mat_F <- sample_size_mat_U
  }

  # If sample_size is a list of matrices
  if (inherits(sample_size, "list")) {
    sample_size_mat_U <- sample_size[["mat_U_ss"]]
    sample_size_mat_F <- sample_size[["mat_F_ss"]]
  }


  # matU errors - assumes an underlying binomial processs
  if (type == "sem") {
    mat_U_error <- sqrt(mat_U * (1 - mat_U) / sample_size_mat_U)
    mat_F_error <- sqrt(mat_F / sample_size_mat_F)
    mat_A_error <- sqrt(mat_U_error^2 + mat_F_error^2)
  }

  if (type == "CI95") {
    mat_U_error <- sqrt(mat_U * (1 - mat_U) / sample_size_mat_U)
    interval_U <- 1.96 * mat_U_error

    mat_U_upperCI <- mat_U + interval_U
    mat_U_lowerCI <- mat_U - interval_U

    # Constrain values to >0
    mat_U_lowerCI[mat_U_lowerCI < 0] <- 0
    mat_U_upperCI[mat_U_upperCI > 1] <- 1

    mat_F_error <- sqrt(mat_F / sample_size_mat_F)

    interval_F <- 1.96 * mat_F_error
    mat_F_upperCI <- mat_F + interval_F
    mat_F_lowerCI <- mat_F - interval_F


    # Constrain values to >0
    mat_F_lowerCI[mat_F_lowerCI < 0] <- 0

    # Mat A
    mat_A <- mat_U + mat_F
    mat_A_error <- sqrt(mat_U_error^2 + mat_F_error^2)
    interval_A <- 1.96 * mat_A_error
    mat_A_upperCI <- mat_A + interval_A
    mat_A_lowerCI <- mat_A - interval_A

    # Constrain values to >0
    mat_A_lowerCI[mat_A_lowerCI < 0] <- 0
  }

  # Outputs
  if (type == "sem") {
    out <- list(
      "mat_U" = mat_U, ",mat_U_error" = mat_U_error,
      "mat_F" = mat_F, "mat_F_error" = mat_F_error,
      "mat_A" = mat_F, "mat_A_error" = mat_A_error
    )
  }

  if (type == "CI95") {
    out <- list(
      "mat_F" = mat_F,
      "mat_F_lowerCI" = mat_F_lowerCI, "mat_F_upperCI" = mat_F_upperCI,
      "mat_U" = mat_U,
      "mat_U_lowerCI" = mat_U_lowerCI, "mat_U_upperCI" = mat_U_upperCI,
      "mat_A" = mat_A,
      "mat_A_lowerCI" = mat_A_lowerCI, "mat_A_upperCI" = mat_A_upperCI
    )
  }

  return(out)
}
