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

testthat::expect_true(inherits(x, "numeric"))

y <- compute_ci_U(
  mat_U = matU,  sample_size = 10, FUN = Rage::life_expect_mean, dist.out = TRUE
)

testthat::expect_true(inherits(y, "list"))

testthat::expect_error(
  compute_ci_U(
    mat_U = matU,  sample_size = 10.5, FUN = Rage::life_expect_mean,
    dist.out = TRUE

  )
)

testthat::expect_error(
  compute_ci_U(
    mat_U = matU, sample_size = -10, FUN =
      Rage::life_expect_mean
  )
)

testthat::expect_error(
  compute_ci_U(
    mat_U = matU, sample_size = 10, FUN =
      1
  )
)

testthat::expect_error(
  compute_ci_U(
    mat_U = 1, sample_size = 10, FUN =
      Rage::life_expect_mean
  )
)


testthat::expect_error(
  compute_ci_U(
    mat_U = matrix(0.2, nrow = 3, ncol = 2),
    sample_size = 10, FUN = Rage::life_expect_mean
  )
)

testthat::expect_error(
  compute_ci_U(
    mat_U = matrix(0.2, nrow = 3, ncol = 2),
   sample_size = 10, FUN = Rage::life_expect_mean
  )
)

testthat::expect_error(
  compute_ci_U(
    mat_U = matU, sample_size = 10:11, FUN =
      Rage::life_expect_mean
  )
)
testthat::expect_error(
  compute_ci_U(
    mat_U = matrix(0.2, nrow = 3, ncol = 2),
    sample_size = 10, FUN = Rage::life_expect_mean
  )
)


testthat::expect_error(
  compute_ci_U(
    mat_U = matU,
    sample_size = matrix(10, nrow = 3, ncol = 3),
    FUN = Rage::life_expect_mean
  )
)


