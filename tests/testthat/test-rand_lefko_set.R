test_that("Check function works correctly across all output types", {
  # For Type 1 and 2 the output is a compadre object with a warning about
  # species names
  expect_silent(
    rand_lefko_set(
      n_models = 10,
      n_stages = 5,
      fecundity = c(0, 0, 4, 8, 10),
      archetype = 4,
      output = "Type1"
    )
  )

  # For Type 1 and 2 the output is a compadre object with a warning about
  # species names
  expect_silent(
    rand_lefko_set(
      n_models = 10,
      n_stages = 5,
      fecundity = c(0, 0, 4, 8, 10),
      archetype = 4,
      output = "Type2"
    )
  )


  expect_silent(
    rand_lefko_set(
      n_models = 10,
      n_stages = 5,
      fecundity = c(0, 0, 4, 8, 10),
      archetype = 4,
      output = "Type3"
    )
  )


  expect_silent(
    rand_lefko_set(
      n_models = 10,
      n_stages = 5,
      fecundity = c(0, 0, 4, 8, 10),
      archetype = 4,
      output = "Type4"
    )
  )


  expect_silent(
    rand_lefko_set(
      n_models = 10,
      n_stages = 5,
      fecundity = c(0, 0, 4, 8, 10),
      archetype = 4,
      output = "Type5"
    )
  )
})


test_that("Error is produced if n is not a positive integer", {
  expect_error(
    rand_lefko_set(
      n = 0,
      n_stages = 5,
      fecundity = c(0, 0, 4, 8, 10),
      archetype = 4,
      output = "Type3"
    )
  )
})



test_that("Output with Type3 is a list", {
  expect_type(
    rand_lefko_set(
      n_models = 10,
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
  expect_true(
    is.matrix(rand_lefko_set(
      n_models = 10,
      n_stages = 5,
      fecundity = c(0, 0, 4, 8, 10),
      archetype = 4,
      output = "Type5"
    )[[1]])
  )

  x <- rand_lefko_set(
    n_models = 10,
    n_stages = 5,
    fecundity = c(0, 0, 4, 8, 10),
    archetype = 4,
    output = "Type5"
  )
  expect_true(inherits(x, "list"))
})



test_that("Check output of Type5 is a list of matrices when there is a
          constraint", {
  library(popbio)
  constrain_df <- data.frame(
    fun = "lambda",
    arg = NA,
    lower = 0.9,
    upper =
      1.1
  )

  x <- rand_lefko_set(
    n_models = 10,
    n_stages = 5,
    fecundity = c(0, 0, 4, 8, 10),
    archetype = 4,
    constraint = constrain_df,
    output = "Type5"
  )

  expect_true(inherits(x, "list"))


  constrain_df <- data.frame(
    fun = c("lambda", "generation.time", "damping.ratio"),
    arg = c(NA, NA, NA),
    lower = c(0.9, 3.0, 1.0),
    upper = c(1.1, 5.0, 7.0)
  )

  x <- rand_lefko_set(
    n_models = 10,
    n_stages = 5,
    fecundity = c(0, 0, 4, 8, 10),
    archetype = 4,
    constraint = constrain_df,
    output = "Type5"
  )

  expect_true(inherits(x, "list"))
})
