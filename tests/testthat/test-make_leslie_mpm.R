test_that("Check that function runs normally", {
  expect_silent(
    make_leslie_mpm(survival = 0.5, fertility = 6, n_stages = 3)
  )

  lt1 <- model_mortality(
    params = c(b_0 = 0.1, b_1 = 0.2, C = 0.1),
    model = "GompertzMakeham",
    truncate = 0.1
  ) |>
    mutate(fert = model_fertility(
      age = x, params = c(A = 10), maturity = 2,
      model = "step"
    ))

  expect_silent(
    make_leslie_mpm(lifetable = lt1)
  )

  # function works even if n_stages = 1
  expect_silent(
    make_leslie_mpm(survival = 0.5, fertility = 10, n_stages = 1)
  )

  expect_silent(
    make_leslie_mpm(survival = 0.5, fertility = 10, n_stages = 25)
  )
})


test_that("Error is produced if n_stages is incorrectly specified", {
  # n_stages should be integer
  expect_error(
    make_leslie_mpm(survival = 0.5, fertility = 10, n_stages = 3.5)
  )
})

test_that("Error is produced if survival is incorrectly specified", {
  # survival must be a numeric value between 0 and 1
  expect_error(
    make_leslie_mpm(survival = 1.1, fertility = 10, n_stages = 3)
  )

  # survival must be a numeric value between 0 and 1
  expect_error(
    make_leslie_mpm(survival = -0.1, fertility = 10, n_stages = 3)
  )

  # survival must be  of length n_stages, or of length 1)
  expect_error(
    make_leslie_mpm(survival = c(0.1, 0.5), fertility = 10, n_stages = 3)
  )
})

test_that("Error is produced if fertility is incorrectly specified", {
  # fertility must be a numeric vector
  expect_error(
    make_leslie_mpm(survival = 0.5, fertility = "text", n_stages = 3)
  )

  # fertility must be of length n_stages, or of length 1

  expect_error(
    make_leslie_mpm(survival = 0.5, fertility = c(10, 10), n_stages = 3)
  )

  # check fertility is positive
  expect_error(
    make_leslie_mpm(survival = 0.5, fertility = -1, n_stages = 3)
  )
})

test_that("Check that output is a matrix", {
  # Check output is a matrix
  expect_true(
    is.matrix(
      make_leslie_mpm(survival = 0.5, fertility = 6, n_stages = 3)
    )
  )
})
