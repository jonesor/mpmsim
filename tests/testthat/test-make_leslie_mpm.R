# n_stages should be integer
testthat::expect_error(
  make_leslie_mpm(survival = 0.5, fertility = 10, n_stages = 3.5)
)

# n_stages should be >1
testthat::expect_error(
  make_leslie_mpm(survival = 0.5, fertility = 10, n_stages = 1)
)

# survival must be a numeric value between 0 and 1
testthat::expect_error(
  make_leslie_mpm(survival = 1.1, fertility = 10, n_stages = 3)
)

# survival must be a numeric value between 0 and 1
testthat::expect_error(
  make_leslie_mpm(survival = -0.1, fertility = 10, n_stages = 3)
)

# survival must be  of length n_stages, or of length 1)
testthat::expect_error(
  make_leslie_mpm(survival = c(0.1, 0.5), fertility = 10, n_stages = 3)
)

# fertility must be a numeric vector
testthat::expect_error(
  make_leslie_mpm(survival = 0.5, fertility = "text", n_stages = 3)
)

# fertility must be of length n_stages, or of length 1

testthat::expect_error(
  make_leslie_mpm(survival = 0.5, fertility = c(10, 10), n_stages = 3)
)

# check fertility is positive
testthat::expect_error(
  make_leslie_mpm(survival = 0.5, fertility = -1, n_stages = 3)
)

# Check output is a matrix
testthat::expect_true(
  is.matrix(
    make_leslie_mpm(survival = 0.5, fertility = 6, n_stages = 3)
  )
)
