# Define the tests
test_that("reorganise_matrices works with valid input", {
  matrix_list <- list(
    list(
      mat_A = matrix(1, 2, 2),
      mat_U = matrix(2, 2, 2),
      mat_F = matrix(3, 2, 2),
      mat_C = matrix(4, 2, 2)
    ),
    list(
      mat_A = matrix(5, 2, 2),
      mat_U = matrix(6, 2, 2),
      mat_F = matrix(7, 2, 2)
    )
  )

  result <- reorganise_matrices(matrix_list)

  expect_equal(length(result), 4)
  expect_true(all(sapply(result$mat_A, is.matrix)))
  expect_true(all(sapply(result$mat_U, is.matrix)))
  expect_true(all(sapply(result$mat_F, is.matrix)))
  expect_true(all(sapply(result$mat_C, is.matrix)))

  expect_equal(dim(result$mat_C[[2]]), c(2, 2))
  expect_true(all(is.na(result$mat_C[[2]])))
})

test_that("reorganise_matrices stops with invalid input", {
  expect_error(
    reorganise_matrices(NULL),
    "matrix_list must be a non-empty list"
  )
  expect_error(
    reorganise_matrices(list()),
    "matrix_list must be a non-empty list"
  )

  invalid_matrix_list_1 <- list(
    list(
      mat_A = matrix(1, 2, 2),
      mat_U = matrix(2, 2, 2)
    )
  )
  expect_error(
    reorganise_matrices(invalid_matrix_list_1),
    "Each sub-list must contain a matrix named mat_F"
  )

  invalid_matrix_list_2 <- list(
    list(
      mat_A = matrix(1, 2, 2),
      mat_U = matrix(2, 2, 2),
      mat_F = "not a matrix"
    )
  )
  expect_error(
    reorganise_matrices(invalid_matrix_list_2),
    "Each sub-list must contain a matrix named mat_F"
  )

  invalid_matrix_list_3 <- list(
    list(
      mat_A = matrix(1, 2, 2),
      mat_U = matrix(2, 2, 2),
      mat_F = matrix(3, 2, 2),
      mat_C = "not a matrix"
    )
  )
  expect_error(
    reorganise_matrices(invalid_matrix_list_3),
    "mat_C, if present, must be a matrix"
  )
})
