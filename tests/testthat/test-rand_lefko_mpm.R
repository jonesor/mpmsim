test_that("Check function works correctly", {
  expect_silent(
    rand_lefko_mpm(n_stages = 3, fecundity = 20, archetype = 1, split = FALSE)
  )

  expect_silent(
    rand_lefko_mpm(n_stages = 3, fecundity = 20, archetype = 2, split = FALSE)
  )

  expect_silent(
    rand_lefko_mpm(n_stages = 3, fecundity = 20, archetype = 3, split = FALSE)
  )

  expect_silent(
    rand_lefko_mpm(n_stages = 3, fecundity = 20, archetype = 4, split = FALSE)
  )

  expect_silent(
    rand_lefko_mpm(n_stages = 3, fecundity = 20, archetype = 1, split = TRUE)
  )

  expect_silent(
    rand_lefko_mpm(n_stages = 3, fecundity = 20, archetype = 2, split = TRUE)
  )

  expect_silent(
    rand_lefko_mpm(n_stages = 3, fecundity = 20, archetype = 3, split = TRUE)
  )

  expect_silent(
    rand_lefko_mpm(n_stages = 3, fecundity = 20, archetype = 4, split = TRUE)
  )
})

test_that("Check errors produced when n_stages incorrect", {
  # n_stages must be greater than 0
  expect_error(
    rand_lefko_mpm(n_stages = -1, fecundity = 20, archetype = 1, split = FALSE)
  )

  # n_stages must be integer
  expect_error(
    rand_lefko_mpm(n_stages = 3.5, fecundity = 20, archetype = 1, split = FALSE)
  )
})


test_that("Check errors produced when fecundity incorrectly specified", {
  # fecundity must be numeric
  expect_error(
    rand_lefko_mpm(
      n_stages = 4, fecundity = "invalid",
      archetype = 1, split = FALSE
    )
  )

  # fecundity must be of length 1 or n_stages
  expect_error(
    rand_lefko_mpm(
      n_stages = 4, fecundity = c(12, 5),
      archetype = 1, split = FALSE
    )
  )

  fec_mat <- matrix(c(
    0, 1, 70,
    0, 0, 0,
    0, 0, 0
  ), ncol = 3, byrow = TRUE)

  expect_error(
    rand_lefko_mpm(
      n_stages = 2, fecundity = fec_mat,
      archetype = 1, split = FALSE
    )
  )

  # Lower limit to fecundity
  fec_mat_lower <- matrix(c(
    0, 1, 70,
    0, 0, 0,
    0, 0, 0
  ), ncol = 3, byrow = TRUE)

  # Upper limit to fecundity
  fec_mat_upper <- matrix(c(
    0, 5, 100,
    0, 0, 0,
    0, 0, 0
  ), ncol = 3, byrow = TRUE)

  # Place the two matrices in a list
  fec_mats <- list(fec_mat_lower, fec_mat_upper)

  expect_error(
    rand_lefko_mpm(
      n_stages = 2, fecundity = fec_mats,
      archetype = 1, split = FALSE
    )
  )

  fec_mat_neg <- matrix(c(
    0, -1, 70,
    0, 0, 0,
    0, 0, 0
  ), ncol = 3, byrow = TRUE)

  expect_error(
    rand_lefko_mpm(
      n_stages = 3, fecundity = fec_mat_neg,
      archetype = 1, split = FALSE
    )
  )

  fec_mats_reversed <- list(fec_mat_upper, fec_mat_lower)

  expect_error(
    rand_lefko_mpm(
      n_stages = 3, fecundity = fec_mats_reversed,
      archetype = 1, split = FALSE
    )
  )
})

test_that("Check errors produced when split incorrect", {
  # Split must be logical
  expect_error(
    rand_lefko_mpm(
      n_stages = 4, fecundity = 5,
      archetype = 1, split = "invalid"
    )
  )
})

test_that("Check errors produced when archetype incorrect", {
  # Archetype is an integer between 1 and 4
  expect_error(
    rand_lefko_mpm(n_stages = 4, fecundity = 5, archetype = 0, split = FALSE)
  )

  expect_error(
    rand_lefko_mpm(n_stages = 4, fecundity = 5, archetype = 5, split = FALSE)
  )

  expect_error(
    rand_lefko_mpm(n_stages = 4, fecundity = 5, archetype = 1.5, split = FALSE)
  )

  expect_error(
    rand_lefko_mpm(n_stages = 2, fecundity = 5, archetype = 3, split = FALSE)
  )

  expect_error(
    rand_lefko_mpm(n_stages = 2, fecundity = 5, archetype = 4, split = FALSE)
  )
})

test_that("Check output is OK", {
  # Check that output is a matrix
  expect_true(
    is.matrix(rand_lefko_mpm(
      n_stages = 4, fecundity = 5, archetype = 1,
      split = FALSE
    ))
  )

  x <- rand_lefko_mpm(
    n_stages = 4, fecundity = 20,
    archetype = 1, split = TRUE
  )
  expect_true(
    inherits(x, "list")
  )

  x <- rand_lefko_mpm(
    n_stages = 4, fecundity = 20,
    archetype = 2, split = TRUE
  )
  expect_true(
    inherits(x, "list")
  )
  x <- rand_lefko_mpm(
    n_stages = 4, fecundity = 20,
    archetype = 3, split = TRUE
  )
  expect_true(
    inherits(x, "list")
  )
  x <- rand_lefko_mpm(
    n_stages = 4, fecundity = 20,
    archetype = 4, split = TRUE
  )
  expect_true(
    inherits(x, "list")
  )

  x <- rand_lefko_mpm(
    n_stages = 4, fecundity = 20,
    archetype = 1, split = FALSE
  )
  expect_true(
    inherits(x, "matrix")
  )

  x <- rand_lefko_mpm(
    n_stages = 4, fecundity = 20,
    archetype = 2, split = FALSE
  )
  expect_true(
    inherits(x, "matrix")
  )
  x <- rand_lefko_mpm(
    n_stages = 4, fecundity = 20,
    archetype = 3, split = FALSE
  )
  expect_true(
    inherits(x, "matrix")
  )
  x <- rand_lefko_mpm(
    n_stages = 4, fecundity = 20,
    archetype = 4, split = FALSE
  )
  expect_true(
    inherits(x, "matrix")
  )

  x <- rand_lefko_mpm(
    n_stages = 4, fecundity = c(0, 2, 10, 20),
    archetype = 4, split = FALSE
  )
  expect_true(
    inherits(x, "matrix")
  )

  # Lower limit to fecundity
  fec_mat_lower <- matrix(c(
    0, 5, 70,
    0, 0, 0,
    0, 0, 0
  ), ncol = 3, byrow = TRUE)

  # Upper limit to fecundity
  fec_mat_upper <- matrix(c(
    0, 10, 100,
    0, 0, 0,
    0, 0, 0
  ), ncol = 3, byrow = TRUE)

  # Place the two matrices in a list
  fec_mats <- list(fec_mat_lower, fec_mat_upper)
  temp <- rand_lefko_mpm(
    n_stages = 3, fecundity = fec_mats, archetype = 1,
    split = FALSE
  )
  expect_true(inherits(temp, "matrix"))


  fec_mat <- matrix(c(
    0, 5, 70,
    0, 0, 0,
    0, 0, 0
  ), ncol = 3, byrow = TRUE)
  temp <- rand_lefko_mpm(
    n_stages = 3, fecundity = fec_mat, archetype = 1,
    split = FALSE
  )
  expect_true(inherits(temp, "matrix"))
})

test_that("Check function fails gracefully with incorrect fecundity", {
  # Lower limit to fecundity
  fec_mat_lower <- matrix(c(
    0, 5, 70,
    0, 0, 0,
    0, 0, 0
  ), ncol = 3, byrow = TRUE)

  # Upper limit to fecundity
  fec_mat_upper <- matrix(c(
    0, 1, 100,
    0, 0, 0,
    0, 0, 0
  ), ncol = 3, byrow = TRUE)

  # Place the two matrices in a list
  fec_mats <- list(fec_mat_lower, fec_mat_upper, fec_mat_upper)

  expect_error(
    rand_lefko_mpm(
      n_stages = 3, fecundity = fec_mats, archetype = 1,
      split = FALSE
    )
  )
})
