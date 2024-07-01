#' Reorganise Matrix Population Models
#'
#' This function reorganises a list of matrix population models, which are split
#' into \code{mat_A}, \code{mat_U}, \code{mat_F}, and optionally \code{mat_C}
#' sub-matrices. It prepares the matrices for easy conversion into a
#' \code{compadreDB} object.
#'
#' @param matrix_list A list of lists, where each sub-list contains the matrices
#'   \code{mat_A}, \code{mat_U}, \code{mat_F}, and optionally \code{mat_C}.
#'
#' @return A list containing four elements: \code{mat_A}, \code{mat_U},
#'   \code{mat_F}, and \code{mat_C}. Each element is a list of matrices
#'   corresponding to the respective matrix type from the input. If \code{mat_C}
#'   does not exist in a sub-list, it is replaced with an \code{NA} matrix of
#'   the same dimensions as \code{mat_U}.
#'
#' @details This function processes a list of matrix population models,
#' extracting and grouping the sub-matrices (\code{mat_A}, \code{mat_U},
#' \code{mat_F}, and optionally \code{mat_C}) into separate lists. If a
#' \code{mat_C} matrix is not present in a model, an \code{NA} matrix of the
#' same size as \code{mat_U} is used as a placeholder.
#'
#' @author Owen Jones <jones@biology.sdu.dk>
#'
#' @examples
#' # Example usage
#' matrix_list <- list(
#'   list(
#'     mat_A = matrix(1, 2, 2),
#'     mat_U = matrix(2, 2, 2),
#'     mat_F = matrix(3, 2, 2),
#'     mat_C = matrix(4, 2, 2)
#'   ),
#'   list(
#'     mat_A = matrix(5, 2, 2),
#'     mat_U = matrix(6, 2, 2),
#'     mat_F = matrix(7, 2, 2)
#'   )
#' )
#' reorganised_matrices <- reorganise_matrices(matrix_list)
#' reorganised_matrices$mat_A
#' @family Leslie matrices
#' @export reorganise_matrices

reorganise_matrices <- function(matrix_list) {
  # Input validation
  if (!is.list(matrix_list) || length(matrix_list) == 0) {
    stop("matrix_list must be a non-empty list")
  }

  for (i in seq_along(matrix_list)) {
    sub_list <- matrix_list[[i]]

    if (!is.list(sub_list)) {
      stop("Each element of matrix_list must be a list")
    }

    required_matrices <- c("mat_A", "mat_U", "mat_F")

    for (mat in required_matrices) {
      if (!mat %in% names(sub_list) || !is.matrix(sub_list[[mat]])) {
        stop(paste("Each sub-list must contain a matrix named", mat))
      }
    }

    if ("mat_C" %in% names(sub_list) && !is.matrix(sub_list$mat_C)) {
      stop("mat_C, if present, must be a matrix")
    }
  }


  # Helper function to get a matrix or an NA matrix if it does not exist
  get_or_na_matrix <- function(x, name, ref_matrix) {
    if (!is.null(x[[name]])) {
      return(x[[name]])
    } else {
      return(matrix(NA, nrow = nrow(ref_matrix), ncol = ncol(ref_matrix)))
    }
  }

  # Use lapply to extract each type of matrix
  mat_A_list <- lapply(matrix_list, function(x) x$mat_A)
  mat_U_list <- lapply(matrix_list, function(x) x$mat_U)
  mat_F_list <- lapply(matrix_list, function(x) x$mat_F)

  # The C matrix may not exist
  mat_C_list <- lapply(matrix_list, function(x) {
    get_or_na_matrix(x, "mat_C", x$mat_U)
  })

  # Combine the lists into a single list
  grouped_matrices <- list(
    mat_A = mat_A_list, mat_U = mat_U_list,
    mat_F = mat_F_list, mat_C = mat_C_list
  )

  return(grouped_matrices)
}
