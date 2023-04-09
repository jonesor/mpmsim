# Check if n is a positive integer
testthat::expect_error(
  generate_mpm_set(
    n = 0,
    n_stages = 5, fecundity = c(0, 0, 4, 8, 10), archetype = 4, split = TRUE
  )
)




# Check output is a list
testthat::expect_type(
  generate_mpm_set(
    n = 10,
    n_stages = 5, fecundity = c(0, 0, 4, 8, 10), archetype = 4, split = TRUE
  ),
  "list"
)

# Check output is a list of matrices
# Checks the first element only
testthat::expect_true(
  is.matrix(generate_mpm_set(
    n = 10,
    n_stages = 5, fecundity = c(0, 0, 4, 8, 10), archetype = 4,
    split = FALSE, by_type = FALSE
  )[[1]])
)
