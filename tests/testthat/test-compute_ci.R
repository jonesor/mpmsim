# Data for use in example
matU <- matrix(c(
  0.1, 0.0,
  0.2, 0.4
), byrow = TRUE, nrow = 2)

matF <- matrix(c(
  0.0, 5.0,
  0.0, 0.0
), byrow = TRUE, nrow = 2)

set.seed(42)

# Example of use to calculate 95% CI of lambda
test_that("Function works correctly", {
  expect_silent(compute_ci(
    mat_U = matU, mat_F = matF, sample_size = 10, FUN =
      popbio::lambda
  ))
})

test_that("Check outputs are of correct type", {
  # Produce some result for checking
  x <- compute_ci(
    mat_U = matU, mat_F = matF, sample_size = 10, FUN =
      popbio::lambda
  )

  expect_true(inherits(x, "numeric"))

  y <- compute_ci(
    mat_U = matU, mat_F = matF, sample_size = 10, FUN =
      popbio::lambda, dist.out = TRUE
  )

  expect_true(inherits(y, "list"))
})

test_that("Check errors are produced when sample_size incorrectly specified", {
  expect_error(
    compute_ci(
      mat_U = matU, mat_F = matF, sample_size = 10.5, FUN =
        popbio::lambda
    )
  )
  expect_error(
    compute_ci(
      mat_U = matU, mat_F = matF, sample_size = 10:11, FUN =
        popbio::lambda
    )
  )
  expect_error(
    compute_ci(
      mat_U = matU, mat_F = matF, sample_size = -10, FUN =
        popbio::lambda
    )
  )
  expect_error(
    compute_ci(
      mat_U = matU, mat_F = matF, sample_size =
        list(
          matrix(10, nrow = 2, ncol = 2),
          matrix(10, nrow = 3, ncol = 3)
        ), FUN =
        popbio::lambda
    )
  )

  expect_error(
    compute_ci(
      mat_U = matU, mat_F = matF, sample_size =
        list(
          mat_X_ss = matrix(10, nrow = 2, ncol = 2),
          mat_Y_ss = matrix(10, nrow = 2, ncol = 2)
        ), FUN =
        popbio::lambda
    )
  )
  expect_error(
    compute_ci(
      mat_U = matU, mat_F = matF, sample_size =
        list(
          matrix(10, nrow = 3, ncol = 3),
          matrix(10, nrow = 3, ncol = 3)
        ), FUN =
        popbio::lambda
    )
  )
})

test_that("Check errors are produced when function is incorrectly specified", {
  expect_error(
    compute_ci(
      mat_U = matU, mat_F = matF, sample_size = 10, FUN =
        1
    )
  )
})

test_that("Check errors are produced when matrices are incorrectly specified", {
  expect_error(
    compute_ci(
      mat_U = 1, mat_F = matF, sample_size = 10, FUN =
        popbio::lambda
    )
  )

  expect_error(
    compute_ci(
      mat_U = matU, mat_F = 1, sample_size = 10, FUN =
        popbio::lambda
    )
  )

  expect_error(
    compute_ci(
      mat_U = matU, mat_F = matrix(2, nrow = 3, ncol = 3), sample_size = 10,
      FUN = popbio::lambda
    )
  )

  expect_error(
    compute_ci(
      mat_U = matrix(0.2, nrow = 3, ncol = 2),
      mat_F = matrix(2, nrow = 3, ncol = 2),
      sample_size = 10, FUN = popbio::lambda
    )
  )

  expect_error(
    compute_ci(
      mat_U = matrix(0.2, nrow = 3, ncol = 2),
      mat_F = matF, sample_size = 10, FUN = popbio::lambda
    )
  )



  expect_error(
    compute_ci(
      mat_U = matrix(0.2, nrow = 3, ncol = 2), mat_F = matF,
      sample_size = 10, FUN = popbio::lambda
    )
  )


  expect_error(
    compute_ci(
      mat_U = matU, mat_F = matF,
      sample_size = matrix(10, nrow = 3, ncol = 3),
      FUN = popbio::lambda
    )
  )
})
