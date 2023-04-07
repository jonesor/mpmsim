# Check if n is a positive integer
testthat::expect_error(
  generate_mpm_set(
    n = 0, lower_lambda = 0.9, upper_lambda = 1.1,
    n_stages = 5, fecundity = c(0, 0, 4, 8, 10), archetype = 4, split = TRUE
  )
)

# Check if lower_lambda is positive and less than upper_lambda
testthat::expect_error(
  generate_mpm_set(
    n = 10, lower_lambda = -1, upper_lambda = 1.1,
    n_stages = 5, fecundity = c(0, 0, 4, 8, 10), archetype = 4, split = TRUE
  )
)

# Check if lower_lambda less than upper_lambda
testthat::expect_error(
  generate_mpm_set(
    n = 10, lower_lambda = 1.11, upper_lambda = 1.1,
    n_stages = 5, fecundity = c(0, 0, 4, 8, 10), archetype = 4, split = TRUE
  )
)


# Check that upper lambda is positive
testthat::expect_error(
  generate_mpm_set(
    n = 10, lower_lambda = 1.2, upper_lambda = -1.1,
    n_stages = 5, fecundity = c(0, 0, 4, 8, 10), archetype = 4, split = TRUE
  )
)

# Check that upper lambda greater than lower lambda
testthat::expect_error(
  generate_mpm_set(
    n = 10, lower_lambda = 1.2, upper_lambda = 1.1,
    n_stages = 5, fecundity = c(0, 0, 4, 8, 10), archetype = 4, split = TRUE
  )
)


# Check output is a list
testthat::expect_type(
  generate_mpm_set(
    n = 10, lower_lambda = 0.9, upper_lambda = 1.1,
    n_stages = 5, fecundity = c(0, 0, 4, 8, 10), archetype = 4, split = TRUE
  ),
  "list"
)

# Check output is a list of matrices
# Checks the first element only
testthat::expect_true(
  is.matrix(generate_mpm_set(
    n = 10, lower_lambda = 0.9, upper_lambda = 1.1,
    n_stages = 5, fecundity = c(0, 0, 4, 8, 10), archetype = 4, split = FALSE, by_type = FALSE
  )[[1]])
)


# Expect an error when fecundity is so high that finding an acceptable lambda is
# impossible

testthat::expect_error(
  generate_mpm_set(
    n = 10, lower_lambda = 0.9, upper_lambda = 1.1,
    n_stages = 5, fecundity = rep(100000, 5), archetype = 4, split = TRUE
  )
)
