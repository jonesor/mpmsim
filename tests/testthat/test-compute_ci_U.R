# Data for use in example
matU <- matrix(c(
  0.1, 0.0,
  0.2, 0.4
), byrow = TRUE, nrow = 2)

set.seed(42)

# Example of use to calculate 95% CI of lambda
x <- compute_ci_U(
  mat_U = matU, sample_size = 10, FUN = Rage::life_expect_mean
)

test_that("output produces numerical results", {
  expect_true(inherits(x, "numeric"))
})

y <- compute_ci_U(
  mat_U = matU, sample_size = 10, FUN = Rage::life_expect_mean, dist.out = TRUE
)

test_that("output produces a list, if dist.out = TRUE", {
  expect_true(inherits(y, "list"))
})

test_that("Error produced if sample size is non-integer, or negative", {
  expect_error(
    compute_ci_U(
      mat_U = matU, sample_size = 10.5, FUN = Rage::life_expect_mean,
      dist.out = TRUE
    )
  )

  expect_error(
    compute_ci_U(
      mat_U = matU, sample_size = -10, FUN =
        Rage::life_expect_mean
    )
  )
})

test_that("Error produced if the function is not provided correctly", {
  expect_error(
    compute_ci_U(
      mat_U = matU, sample_size = 10, FUN =
        1
    )
  )
})

test_that("Error produced if the U matrix is not formatted correctly", {
  expect_error(
    compute_ci_U(
      mat_U = 1, sample_size = 10, FUN =
        Rage::life_expect_mean
    )
  )

  expect_error(
    compute_ci_U(
      mat_U = matrix(0.2, nrow = 3, ncol = 2),
      sample_size = 10, FUN = Rage::life_expect_mean
    )
  )

  expect_error(
    compute_ci_U(
      mat_U = matrix(0.2, nrow = 3, ncol = 2),
      sample_size = 10, FUN = Rage::life_expect_mean
    )
  )
})

test_that("Error produced if the sample size not formatted correctly", {
  expect_error(
    compute_ci_U(
      mat_U = matU, sample_size = 10:11, FUN =
        Rage::life_expect_mean
    )
  )

  expect_error(
    compute_ci_U(
      mat_U = matU,
      sample_size = matrix(10, nrow = 3, ncol = 3),
      FUN = Rage::life_expect_mean
    )
  )
})
