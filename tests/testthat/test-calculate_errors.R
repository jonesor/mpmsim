test_that("Function works correctly", {
  expect_silent(
    calculate_errors(
      mat_U = matrix(c(0.3, 0.2, 0.2, 0.1), nrow = 2, ncol = 2),
      mat_F = matrix(c(0.0, 2.2, 0.0, 0.0), nrow = 2, ncol = 2),
      sample_size = 5
    )
  )
})


test_that("Errors are produced when U matrix not specified correctly", {
  # Check for error when U matrix is not a matrix!
  expect_error(calculate_errors(mat_U = 1))

  # Check for error when U matrix is missing
  expect_error(calculate_errors(mat_F = 1))

  # mat_U must be a matrix
  expect_error(
    calculate_errors(
      mat_U = seq(1, 4, length.out = 4),
      mat_F = matrix(c(0.0, 2.2, 0.0, 0.0), nrow = 2, ncol = 2),
      sample_size = matrix(10, nrow = 2, ncol = 2)
    )
  )
})

test_that("Errors are produced when F matrix not specified correctly", {
  # mat_F must be a matrix
  expect_error(
    calculate_errors(
      mat_U = matrix(c(0.3, 0.2, 0.2, 0.1), nrow = 2, ncol = 2),
      mat_F = seq(1, 4, length.out = 4),
      sample_size = matrix(10, nrow = 2, ncol = 2)
    )
  )
})


test_that("Errors are produced when sample size not specified correctly", {
  # sample_size must be a matrix, or integer with length 1
  expect_error(
    calculate_errors(
      mat_U = matrix(c(0.3, 0.2, 0.2, 0.1), nrow = 2, ncol = 2),
      mat_F = matrix(c(0.0, 2.2, 0.0, 0.0), nrow = 2, ncol = 2),
      sample_size = 1:3
    )
  )

  # if sample_size is a matrix, it must be the same as mat_U
  expect_error(
    calculate_errors(
      mat_U = matrix(c(0.3, 0.2, 0.2, 0.1), nrow = 2, ncol = 2),
      mat_F = matrix(c(0.0, 2.2, 0.0, 0.0), nrow = 2, ncol = 2),
      sample_size = matrix(10, nrow = 3, ncol = 3)
    )
  )

  # if sample_size is a list of two matrices matrix, they must be the same size
  expect_error(
    calculate_errors(
      mat_U = matrix(c(0.3, 0.2, 0.2, 0.1), nrow = 2, ncol = 2),
      mat_F = matrix(c(0.0, 2.2, 0.0, 0.0), nrow = 2, ncol = 2),
      sample_size = list(
        mat_U_ss = matrix(10, nrow = 3, ncol = 3),
        mat_F_ss = matrix(10, nrow = 2, ncol = 2)
      )
    )
  )

  # if sample_size is a list of two matrices matrix, it must be the same as
  # mat_U
  expect_error(
    calculate_errors(
      mat_U = matrix(c(0.3, 0.2, 0.2, 0.1), nrow = 2, ncol = 2),
      mat_F = matrix(c(0.0, 2.2, 0.0, 0.0), nrow = 2, ncol = 2),
      sample_size = list(
        mat_U_ss = matrix(10, nrow = 3, ncol = 3),
        mat_F_ss = matrix(10, nrow = 3, ncol = 3)
      )
    )
  )

  # if sample_size is a list of two matrices matrix, they must be named mat_U_ss
  # and mat_F_ss
  expect_error(
    calculate_errors(
      mat_U = matrix(c(0.3, 0.2, 0.2, 0.1), nrow = 2, ncol = 2),
      mat_F = matrix(c(0.0, 2.2, 0.0, 0.0), nrow = 2, ncol = 2),
      sample_size = list(
        mat_X = matrix(10, nrow = 2, ncol = 2),
        mat_Y = matrix(10, nrow = 2, ncol = 2)
      )
    )
  )

  # if sample_size must be integer
  expect_error(
    calculate_errors(
      mat_U = matrix(c(0.3, 0.2, 0.2, 0.1), nrow = 2, ncol = 2),
      mat_F = matrix(c(0.0, 2.2, 0.0, 0.0), nrow = 2, ncol = 2),
      sample_size = 10.5
    )
  )


  # if sample_size must not be <0
  expect_error(
    calculate_errors(
      mat_U = matrix(c(0.3, 0.2, 0.2, 0.1), nrow = 2, ncol = 2),
      mat_F = matrix(c(0.0, 2.2, 0.0, 0.0), nrow = 2, ncol = 2),
      sample_size = -10
    )
  )

  # if sample_size must not be <0
  expect_error(
    calculate_errors(
      mat_U = matrix(c(0.3, 0.2, 0.2, 0.1), nrow = 2, ncol = 2),
      mat_F = matrix(c(0.0, 2.2, 0.0, 0.0), nrow = 2, ncol = 2),
      sample_size = 10, type = "xxx"
    )
  )
})

test_that("Check that results are identical with equivalent specifications of
          sample size", {
  expect_identical(
    calculate_errors(
      mat_U = matrix(c(0.3, 0.2, 0.2, 0.1), nrow = 2, ncol = 2),
      mat_F = matrix(c(0.0, 2.2, 0.0, 0.0), nrow = 2, ncol = 2),
      sample_size = matrix(10, nrow = 2, ncol = 2)
    ),
    calculate_errors(
      mat_U = matrix(c(0.3, 0.2, 0.2, 0.1), nrow = 2, ncol = 2),
      mat_F = matrix(c(0.0, 2.2, 0.0, 0.0), nrow = 2, ncol = 2),
      sample_size = 10
    )
  )

  expect_identical(
    calculate_errors(
      mat_U = matrix(c(0.3, 0.2, 0.2, 0.1), nrow = 2, ncol = 2),
      mat_F = matrix(c(0.0, 2.2, 0.0, 0.0), nrow = 2, ncol = 2),
      sample_size = matrix(10, nrow = 2, ncol = 2), type = "CI95"
    ),
    calculate_errors(
      mat_U = matrix(c(0.3, 0.2, 0.2, 0.1), nrow = 2, ncol = 2),
      mat_F = matrix(c(0.0, 2.2, 0.0, 0.0), nrow = 2, ncol = 2),
      sample_size = 10, type = "CI95"
    )
  )

  expect_identical(
    calculate_errors(
      mat_U = matrix(c(0.3, 0.2, 0.2, 0.1), nrow = 2, ncol = 2),
      mat_F = matrix(c(0.0, 2.2, 0.0, 0.0), nrow = 2, ncol = 2),
      sample_size = list(
        mat_U_ss = matrix(10, nrow = 2, ncol = 2),
        mat_F_ss = matrix(10, nrow = 2, ncol = 2)
      )
    ),
    calculate_errors(
      mat_U = matrix(c(0.3, 0.2, 0.2, 0.1), nrow = 2, ncol = 2),
      mat_F = matrix(c(0.0, 2.2, 0.0, 0.0), nrow = 2, ncol = 2),
      sample_size = 10
    )
  )
})
