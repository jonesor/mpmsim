#' Calculate error (standard error or 95%CI) in elements of a matrix population
#' model.
#'
#' Given two submatrices of a matrix population model (`mat_U` and `mat_F`, the
#' growth/survival matrix and the reproduction matrix respectively) and a sample
#' size, or matrix of sample sizes, this function calculates the standard error
#' or 95% confidence interval (95%CI) for each element of the matrix. These
#' calculations assume that `mat_U` is the result of binomial processes (i.e.,
#' the survival (0/1) of individuals), while `mat_F` is the result of Poisson
#' processes (i.e., counts of offspring).
#'
#' The output is a list containing the original matrices and matrices showing
#' error estimates or confidence intervals.
#'
#' @param mat_U matrix of mean survival probabilities
#' @param mat_F matrix of mean fecundity values
#' @param sample_size A positive number indicating the sample size that was used
#'   to calculate the estimates in `mat_U` and `mat_F`.
#' @param type A character string indicating the type of error to calculate.
#'   Must be one of "`sem`" (standard error), or "`CI95`" (95% confidence interval).
#'
#' @return A list containing the error estimates. If type is "`CI95`", the list
#'   contains the upper and lower confidence intervals for both matrices
#'   (`mat_U_upperCI`, `mat_U_lowerCI`, `mat_F_upperCI`, `mat_F_lowerCI`).
#'   Otherwise, the list contains the standard error (`mat_U_error`,
#'   `mat_F_error`) for both matrices.
#'
#' @examples
#'
#' matU <- matrix(c(
#'   0.1, 0,
#'   0.2, 0.4
#' ), byrow = TRUE, nrow = 2)
#' matF <- matrix(c(
#'   0, 4,
#'   0., 0.
#' ), byrow = TRUE, nrow = 2)
#'
#' calculate_errors(mat_U = matU, mat_F = matF, sample_size = 20, type = "CI95")
#' calculate_errors(mat_U = matU, mat_F = matF, sample_size = 20, type = "sem")
#'
#' @author Owen Jones <jones@biology.sdu.dk>
#' @seealso [simulate_mpm()] which simulates matrices with known values and
#'   sample sizes.
#' @export calculate_errors
#'
calculate_errors <- function(mat_U, mat_F, sample_size, type = "sem") {
  # Validate inputs
  if (!is.matrix(mat_U)) {
    stop("mat_U must be a matrix.")
  }
  if (!is.matrix(mat_F)) {
    stop("mat_F must be a matrix.")
  }
  if (!is.numeric(sample_size) || sample_size <= 0) {
    stop("sample_size must be a positive number.")
  }
  if (type != "sem" && type != "CI95") {
    stop("type must be one of 'sem', 'sd', or 'CI95'.")
  }

  # Sample size matrices
  # If sample_size is a vector of length 1
  if (length(sample_size) == 1) {
    sample_size_mat_U <- matrix(sample_size, ncol = ncol(mat_U), nrow = nrow(mat_U))
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
    sample_size_vector_U <- as.vector(sample_size_mat_list[["mat_U_ss"]])
    sample_size_vector_F <- as.vector(sample_size_mat_list[["mat_F_ss"]])
  }


  # matU errors - assumes an underlying binomial processs
  if (type == "sem") {
    mat_U_error <- sqrt(mat_U * (1 - mat_U) / sample_size)
  }

  if (type == "CI95") {
    interval <- 1.95 * (sqrt(mat_U * (1 - mat_U) / sample_size))
    mat_U_upperCI <- mat_U + interval
    mat_U_lowerCI <- mat_U - interval

    # Constrain values to >0
    mat_U_lowerCI[mat_U_lowerCI < 0] <- 0
    mat_U_upperCI[mat_U_upperCI > 1] <- 1
  }

  # matF errors - assumes an underlying poisson processs
  if (type == "sem") {
    mat_F_error <- sqrt(mat_F / sample_size)
  }
  if (type == "CI95") {
    interval <- 1.95 * sqrt(mat_F / sample_size)
    mat_F_upperCI <- mat_F + interval
    mat_F_lowerCI <- mat_F - interval

    # Constrain values to >0
    mat_F_lowerCI[mat_F_lowerCI < 0] <- 0
  }

  # Outputs
  if (type == "sem") {
    out <- list("mat_U" = mat_U, ",mat_U_error" = mat_U_error, "mat_F" = mat_F, "mat_F_error" = mat_F_error)
  }

  if (type == "CI95") {
    out <- list(
      "mat_F" = mat_F,
      "mat_F_lowerCI" = mat_F_lowerCI,"mat_F_upperCI" = mat_F_upperCI,
      "mat_U" = mat_U,
       "mat_U_lowerCI" = mat_U_lowerCI,"mat_U_upperCI" = mat_U_upperCI
    )
  }

  return(out)
}
