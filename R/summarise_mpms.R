summarise_mpms <- function(x) {
  A_matrix_list <- matA(x)
  U_matrix_list <- matU(x)
  F_matrix_list <- matF(x)

  lambdaVals <- unlist(lapply(A_matrix_list, popdemo::eigs, what = "lambda"))
  max_F_Vals <- unlist(lapply(F_matrix_list, max, na.rm = TRUE))
  max_U_Vals <- unlist(lapply(U_matrix_list, max, na.rm = TRUE))

  min_non_zero <- function(mat) {
    non_zero_values <- mat[mat != 0]
    if (length(non_zero_values) == 0) {
      return(NA) # or another value you prefer, such as -Inf
    } else {
      return(min(non_zero_values, na.rm = TRUE))
    }
  }
  min_non_zero_U_Vals <- unlist(lapply(U_matrix_list, min_non_zero))

  }
