# Check if n is a positive integer
test_that("Error is produced if n is not a positive integer", {
testthat::expect_error(
  rand_lefko_set(
    n = 0,
    n_stages = 5,
    fecundity = c(0, 0, 4, 8, 10),
    archetype = 4,
    output = "Type3"
  )
)
})



# Check output is a list
test_that("Output with Type3 is a list", {
testthat::expect_type(
  rand_lefko_set(
    n = 10,
    n_stages = 5,
    fecundity = c(0, 0, 4, 8, 10),
    archetype = 4,
    output = "Type3"
  ),
  "list"
)
})

# Check output is a list of matrices
# Checks the first element only
test_that("Check output of Type5 is a list of matrices (part 1)", {
testthat::expect_true(
  is.matrix(rand_lefko_set(
    n = 10,
    n_stages = 5,
    fecundity = c(0, 0, 4, 8, 10),
    archetype = 4,
    output = "Type5"
  )[[1]])
)
})


x <- rand_lefko_set(
  n = 10,
  n_stages = 5,
  fecundity = c(0, 0, 4, 8, 10),
  archetype = 4,
  output = "Type5"
)

test_that("Check output of Type5 is a list of matrices (part 2)", {
testthat::expect_true(inherits(x, "list"))
})

library(popbio)
constrain_df <- data.frame(
  fun = "lambda",
  arg = NA,
  lower = 0.9,
  upper =
    1.1
)

x <- rand_lefko_set(
  n = 10,
  n_stages = 5,
  fecundity = c(0, 0, 4, 8, 10),
  archetype = 4,
  constraint = constrain_df,
  output = "Type5"
)

test_that("Check output of Type5 is a list of matrices (part 2), when there is a constraint", {
testthat::expect_true(inherits(x, "list"))
})

constrain_df <- data.frame(
  fun = "lambda",
  arg = NA,
  lower = 0.9,
  upper =
    1.1
)


constrain_df <- data.frame(
  fun = c("lambda", "generation.time", "damping.ratio"),
  arg = c(NA, NA, NA),
  lower = c(0.9, 3.0, 1.0),
  upper = c(1.1, 5.0, 7.0)
)

x <- rand_lefko_set(
  n = 10,
  n_stages = 5,
  fecundity = c(0, 0, 4, 8, 10),
  archetype = 4,
  constraint = constrain_df,
  output = "Type5"
)

test_that("Check output of Type5 is a list of matrices (part 2), when there is a complex constraint", {
testthat::expect_true(inherits(x, "list"))
})


# Check all output types systematically

test_that("Check output Type1 functions correctly", {
# For Type 1 and 2 the output is a compadre object with a warning about species names
testthat::expect_warning(
rand_lefko_set(
  n = 10,
  n_stages = 5,
  fecundity = c(0, 0, 4, 8, 10),
  archetype = 4,
  output = "Type1"
))
})

test_that("Check output Type2 functions correctly", {
  # For Type 1 and 2 the output is a compadre object with a warning about species names
  testthat::expect_warning(
    rand_lefko_set(
      n = 10,
      n_stages = 5,
      fecundity = c(0, 0, 4, 8, 10),
      archetype = 4,
      output = "Type2"
    ))
})

test_that("Check output Type3 functions correctly", {
  testthat::expect_silent(
    rand_lefko_set(
      n = 10,
      n_stages = 5,
      fecundity = c(0, 0, 4, 8, 10),
      archetype = 4,
      output = "Type3"
    ))
})

test_that("Check output Type4 functions correctly", {
  testthat::expect_silent(
    rand_lefko_set(
      n = 10,
      n_stages = 5,
      fecundity = c(0, 0, 4, 8, 10),
      archetype = 4,
      output = "Type4"
    ))
})

test_that("Check output Type5 functions correctly", {
  testthat::expect_silent(
    rand_lefko_set(
      n = 10,
      n_stages = 5,
      fecundity = c(0, 0, 4, 8, 10),
      archetype = 4,
      output = "Type5"
    ))
})
