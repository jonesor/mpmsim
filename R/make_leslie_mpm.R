#' Create a Leslie matrix population model
#'
#' The function creates a Leslie matrix from inputs of number of stages,
#' fertility (the top row of the matrix), and survival probability (the value in
#' the sub-diagonal).
#'
#' @param survival a numeric value representing the survival probability of each
#'   stage along the lower off-diagonal of the matrix, with the final value
#'   being in the lower-right corner of the matrix. If only one value is
#'   provided, this is applied to all survival elements.
#' @param fertility a numeric vector of length n_stages representing the
#'   fertility rate of each stage. If only one value is provided, this is
#'   applied to all fertility elements.
#' @param n_stages a numeric value representing the number of stages in the
#'   matrix
#' @param lifetable a life table containing columns `px` (age-specific survival)
#'   and `fert` (age-specific fertility)
#' @param split a logical argument indicating whether the output matrix should
#'   be split into separate A, U and F matrices (where A = U + F).
#' @return A matrix of size n_stages x n_stages representing the Leslie matrix
#' @author Owen Jones <jones@biology.sdu.dk>
#' @family Leslie matrices
#' @seealso
#' * [model_survival()] to model age-specific survival using mortality models.
#' * [model_fertility()] to model age-specific fertility using various
#' functions.
#' @references
#'
#'   Caswell, H. (2001). Matrix Population Models: Construction,
#'   Analysis, and Interpretation. Sinauer.
#'
#'   Leslie, P. H. (1945). On the use of matrices in certain population
#'   mathematics. Biometrika, 33 (3), 183–212.
#'
#'   Leslie, P. H. (1948). Some Further Notes on the Use of Matrices in
#'   Population Mathematics. Biometrika, 35(3-4), 213–245.
#'
#' @export
#' @examples
#' make_leslie_mpm(
#'   survival = 0.5, fertility = c(0.1, 0.2, 0.3),
#'   n_stages = 3, split = FALSE
#' )
#' make_leslie_mpm(
#'   survival = c(0.5, 0.6, 0.7), fertility = c(0.1, 0.2, 0.3),
#'   n_stages = 3
#' )
#' make_leslie_mpm(
#'   survival = seq(0.1, 0.7, length.out = 4), fertility = 0.1,
#'   n_stages = 4
#' )
#' make_leslie_mpm(
#'   survival = c(0.8, 0.3, 0.2, 0.1, 0.05), fertility = 0.2,
#'   n_stages = 5
#' )
#'
make_leslie_mpm <- function(survival = NULL,
                            fertility = NULL,
                            n_stages = NULL,
                            lifetable = NULL,
                            split = FALSE) {
  if (!is.null(lifetable)) {
    # Check that lifetable is a dataframe
    if (!is.data.frame(lifetable)) {
      stop("lifetable must be a dataframe.")
    }
    # Check that data has the necessary columns
    if (!all(c("px", "fert") %in% colnames(lifetable))) {
      stop("data must contain 'px' and 'fert' columns.")
    }

    survival <- lifetable$px
    fertility <- lifetable$fert
    n_stages <- nrow(lifetable)
  }

  # Validate input
  if (!min(abs(c(n_stages %% 1, n_stages %% 1 - 1))) <
    .Machine$double.eps^0.5 || n_stages < 1) {
    stop("n_stages must be a positive integer")
  }

  if (!is.numeric(survival) || min(survival) < 0 || max(survival) > 1) {
    stop("survival must be a numeric value between 0 and 1")
  }

  if (!length(survival) %in% c(1, n_stages)) {
    stop(
      "survival must be of length n_stages (", n_stages,
      "), or of length 1"
    )
  }

  if (!is.numeric(fertility) || (length(fertility) != n_stages &&
    length(fertility) != 1)) {
    stop(
      "fertility must be a numeric vector of length n_stages (",
      n_stages, "), or of length 1"
    )
  }

  if (any(fertility < 0)) {
    stop("All values of fertility must be non-negative.")
  }

  # Check that split is a logical value
  if (!is.logical(split)) {
    stop("split must be a logical value.")
  }

  # Special case, with matrices of dimension 1. This occurs when the mortality
  # model results in all individuals dying within 1 year.
  if (n_stages == 1) {
    mat_F <- matrix(fertility)
    mat_U <- matrix(survival)

    if (split) {
      mat_A_split <- list(mat_A = mat_U + mat_F, mat_U = mat_U, mat_F = mat_F)
      return(mat_A_split)
    } else {
      mat_A <- mat_F + mat_U
      return(mat_A)
    }
  }

  # Normal case (matrices with dimension > 1)
  if (n_stages > 1) {
    id_col <- 1:n_stages
    id_row <- c(2:n_stages, n_stages)
    sub_diagonal_elements <- (id_col - 1) * n_stages + id_row
    zero_matrix <- matrix(0, nrow = n_stages, ncol = n_stages)

    # Make the F matrix (fertility)
    mat_F <- zero_matrix
    mat_F[1, ] <- fertility

    # Make the U matrix (survival and growth)
    mat_U <- zero_matrix
    mat_U[sub_diagonal_elements] <- survival

    if (split) {
      mat_A_split <- list(mat_A = mat_U + mat_F, mat_U = mat_U, mat_F = mat_F)
      return(mat_A_split)
    } else {
      mat_A <- mat_F + mat_U
      return(mat_A)
    }
  }
}
