# Check if n is a positive integer
testthat::expect_error(
  generate_mpm_set(
    n = 0,
    n_stages = 5,
    fecundity = c(0, 0, 4, 8, 10),
    archetype = 4,
    split = TRUE,
    as_compadre = FALSE
  )
)




# Check output is a list
testthat::expect_type(
  generate_mpm_set(
    n = 10,
    n_stages = 5,
    fecundity = c(0, 0, 4, 8, 10),
    archetype = 4,
    split = TRUE,
    as_compadre = FALSE
  ),
  "list"
)

# Check output is a list of matrices
# Checks the first element only
testthat::expect_true(is.matrix(
  generate_mpm_set(
    n = 10,
    n_stages = 5,
    fecundity = c(0, 0, 4, 8, 10),
    archetype = 4,
    split = FALSE,
    by_type = FALSE,
    as_compadre = FALSE
  )[[1]]
))



x <- generate_mpm_set(
  n = 10,
  n_stages = 5,
  fecundity = c(0, 0, 4, 8, 10),
  archetype = 4,
  split = FALSE,
  by_type = FALSE,
  as_compadre = FALSE
)

testthat::expect_true(inherits(x, "list"))


library(popbio)
constrain_df <- data.frame(
  fun = "lambda",
  arg = NA,
  lower = 0.9,
  upper =
    1.1
)
x <- generate_mpm_set(
  n = 10,
  n_stages = 5,
  fecundity = c(0, 0, 4, 8, 10),
  archetype = 4,
  constraint = constrain_df,
  as_compadre = FALSE
)
testthat::expect_true(inherits(x, "list"))


constrain_df <- data.frame(
  fun = "lambda",
  arg = NA,
  lower = 0.9,
  upper =
    1.1
)

x <- generate_mpm_set(
  n = 10,
  n_stages = 5,
  fecundity = c(0, 0, 4, 8, 10),
  archetype = 4,
  constraint = constrain_df,
  split = FALSE,
  by_type = FALSE,
  as_compadre = FALSE
)
testthat::expect_true(inherits(x, "list"))


testthat::expect_error(
  generate_mpm_set(
    n = 10,
    n_stages = 5,
    fecundity = c(0, 0, 4, 8, 10),
    archetype = 4,
    split = FALSE,
    by_type = TRUE,
    as_compadre = FALSE
  )
)

constrain_df <- data.frame(
  fun = c("lambda", "generation.time", "damping.ratio"),
  arg = c(NA, NA, NA),
  lower = c(0.9, 3.0, 1.0),
  upper = c(1.1, 5.0, 7.0)
)
x <- generate_mpm_set(
  n = 10,
  n_stages = 5,
  fecundity = c(0, 0, 4, 8, 10),
  archetype = 4,
  constraint = constrain_df,
  as_compadre = FALSE
)
testthat::expect_true(inherits(x, "list"))
