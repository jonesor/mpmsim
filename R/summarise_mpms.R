#' Summarise Matrix Population Models
#'
#' Calculates and summarises various metrics from matrix population models
#' (MPMs) including dimension (= age in Leslie matrices), lambda values, maximum
#' fecundity values, maximum growth/survival transition probabilities, and
#' minimum non-zero growth/survival transition probabilities
#'
#' @param x A `compadreDB` object containing matrix population models, typically
#'   in a format compatible with `matA`, `matU`, and `matF` functions.
#' @return This function prints summaries of the following metrics:
#' \itemize{
#'   \item \strong{lambda values:} The lambda values (dominant eigenvalues) of
#'    the A matrices.
#'   \item \strong{max F values:} The maximum values from the F matrices.
#'   \item \strong{max U values:} The maximum values from the U matrices.
#'   \item \strong{minimum non-zero U values:} The minimum non-zero values from
#'   the U matrices.
#' }
#' @importFrom popdemo eigs
#' @importFrom Rcompadre matA matU matF
#' @family utility
#' @examples
#' mats <- rand_lefko_set(
#'   n = 10, n_stages = 5, fecundity = c(0, 0, 4, 8, 10),
#'   archetype = 4, output = "Type1"
#' )
#'
#' summarise_mpms(mats)
#' @export summarise_mpms

summarise_mpms <- function(x) {
  if (!inherits(x, "CompadreDB")) {
    stop("x must be a CompadreDB object (mpmsim output types 1 or 2)")
  }

  A_matrix_list <- matA(x)
  U_matrix_list <- matU(x)
  F_matrix_list <- matF(x)

  # Check for NAs in U matrices
  na_in_U <- sapply(U_matrix_list, function(mat) any(is.na(mat)))
  U_matrix_list <- U_matrix_list[!na_in_U]
  # Check for NAs in F matrices
  na_in_F <- sapply(F_matrix_list, function(mat) any(is.na(mat)))
  F_matrix_list <- F_matrix_list[!na_in_F]

  lambdaVals <- sapply(A_matrix_list, eigs, what = "lambda")
  dimVals <- sapply(A_matrix_list, nrow)


  if (length(F_matrix_list) > 0) {
    max_F_Vals <- unlist(lapply(F_matrix_list, max, na.rm = TRUE))
  } else {
    max_F_Vals <- NA
  }
  if (length(U_matrix_list) > 0) {
    max_U_Vals <- unlist(lapply(U_matrix_list, max, na.rm = TRUE))

    min_non_zero <- function(mat) {
      non_zero_values <- mat[mat != 0]
      if (length(non_zero_values) == 0) {
        return(NA)
      } else {
        return(min(non_zero_values, na.rm = TRUE))
      }
    }
    min_non_zero_U_Vals <- unlist(lapply(U_matrix_list, min_non_zero))
  } else {
    max_U_Vals <- NA
    min_non_zero_U_Vals <- NA
  }

  cat("Summary of matrix dimension:\n")
  print(summary(dimVals))
  cat("Summary of lambda values:\n")
  print(summary(lambdaVals))
  cat("\nSummary of maximum F values:\n")
  print(summary(max_F_Vals))
  cat("\nSummary of maximum U values:\n")
  print(summary(max_U_Vals))
  cat("\nSummary of minimum non-zero U values:\n")
  print(summary(min_non_zero_U_Vals))
}
