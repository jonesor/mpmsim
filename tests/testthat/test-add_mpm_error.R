# expect matU to be a matrix
testthat::expect_error(
  add_mpm_error(
    matU = rep(0.1, 4), matF = matrix(rep(0.1, 4), ncol = 2),
    sample_size = matrix(rep(10, 4), ncol = 2), split = TRUE
  )
)

# expect matF to be a matrix
testthat::expect_error(
  add_mpm_error(
    matU = matrix(rep(0.1, 4), ncol = 2), matF = rep(0.1, 4),
    sample_size = matrix(rep(10, 4), ncol = 2), split = TRUE
  )
)

# expect sample_size to be a matrix, or a single integer > 0
testthat::expect_error(
  add_mpm_error(
    matU = matrix(rep(0.1, 4), ncol = 2), matF = matrix(rep(0.1, 4), ncol = 2),
    sample_size = c(1, 2), split = TRUE
  )
)


# expect matU to be >= 0
testthat::expect_error(
  add_mpm_error(
    matU = matrix(rep(-0.1, 4), ncol = 2), matF = matrix(rep(0.1, 4), ncol = 2),
    sample_size = matrix(rep(10, 4), ncol = 2), split = TRUE
  )
)


# expect matF to be >= 0
testthat::expect_error(
  add_mpm_error(
    matU = matrix(rep(0.1, 4), ncol = 2), matF = matrix(rep(-0.1, 4), ncol = 2),
    sample_size = matrix(rep(10, 4), ncol = 2), split = TRUE
  )
)

# expect sample_size to be > 0
testthat::expect_error(
  add_mpm_error(
    matU = matrix(rep(0.1, 4), ncol = 2), matF = matrix(rep(0.1, 4), ncol = 2),
    sample_size = matrix(rep(-10, 4), ncol = 2), split = TRUE
  )
)

# expect sample_size to be integers
testthat::expect_error(
  add_mpm_error(
    matU = matrix(rep(0.1, 4), ncol = 2), matF = matrix(rep(0.1, 4), ncol = 2),
    sample_size = matrix(rep(10.5, 4), ncol = 2), split = TRUE
  )
)
