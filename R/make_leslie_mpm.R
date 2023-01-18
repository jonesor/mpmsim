#' @title Create a Leslie matrix
#' @description The function creates a Leslie matrix from inputs of number of
#'   stages, fertility (the top row of the matrix), and survival probability
#'   (the value in the sub-diagonal).
#' @param survival a numeric value representing the survival probability of each
#'   stage along the lower off-diagonal of the matrix, with the final value
#'   being in the lower-right corner of the matrix. If only one value is
#'   provided, this is applied to all survival elements.
#' @param fertility a numeric vector of length n_stages representing the
#'   fertility rate of each stage. If only one value is provided, this is
#'   applied to all fertility elements.
#' @param n_stages a numeric value representing the number of stages in the
#'   matrix
#' @return A matrix of size n_stages x n_stages representing the Leslie matrix
#' @export
#' @examples
#' make_leslie_matrix(survival = 0.5, fertility = c(0.1, 0.2, 0.3),
#'                    n_stages = 3)
#' make_leslie_matrix(survival = c(0.5,0.6,0.7), fertility = c(0.1,0.2,0.3),
#'                    n_stages = 3)
#' make_leslie_matrix(survival = seq(0.1,0.7,length.out = 4), fertility = 0.1,
#'                    n_stages = 4)
#' make_leslie_matrix(survival = c(0.8,0.3,0.2,0.1,0.05), fertility = 0.2,
#'                    n_stages = 5)
#'
make_leslie_matrix <- function(survival, fertility, n_stages) {
  # Validate input
  if (!min(abs(c(n_stages %% 1, n_stages %% 1 - 1))) < .Machine$double.eps^0.5 || n_stages <= 1) {
    stop("n_stages must be a positive integer > 1")
  }
  if (!is.numeric(survival) || min(survival) < 0 || max(survival) > 1) {
    stop("survival must be a numeric value between 0 and 1, of length n_stages, or of length 1")
  }

  if(length(survival) != 1 && length(survival) != n_stages){
    stop("survival must be of length n_stages, or of length 1")
  }

  if (!is.numeric(fertility) || (length(fertility) != n_stages && length(fertility) != 1)) {
    stop("fertility must be a numeric vector of length n_stages, or of length 1")
  }
  if (any(fertility < 0)) {
    stop("All values of fertility must be non-negative")
  }

  id_col <- 1:n_stages
  id_row <- c(2:n_stages, n_stages)
  sub_diagonal_elements <- (id_col - 1) * n_stages + id_row
  A_matrix <- matrix(0, nrow = n_stages, ncol = n_stages)
  A_matrix[1, ] <- fertility
  A_matrix[sub_diagonal_elements] <- survival
  return(A_matrix)
}
