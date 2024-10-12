test_that("Function works correctly", {
  # Compute fertility using the step model
  expect_silent(
    model_fecundity(
      age = 0:20, params = c(A = 10), maturity = 2,
      model = "step"
    )
  )

  # Compute fertility using the logistic model
  expect_silent(
    model_fecundity(
      age = 0:20, params = c(A = 10, k = 0.5, x_m = 8), maturity =
        0, model = "logistic"
    )
  )

  # Compute fertility using the von Bertalanffy model
  expect_silent(
    model_fecundity(
      age = 0:20, params = c(A = 10, k = .3), maturity = 2, model =
        "vonbertalanffy"
    )
  )

  # Compute fertility using the normal model
  expect_silent(
    model_fecundity(
      age = 0:20, params = c(A = 10, mu = 4, sd = 2), maturity = 0,
      model = "normal"
    )
  )

  # Compute fertility using the Hadwiger model
  expect_silent(
    model_fecundity(
      age = 0:50, params = c(a = 0.91, b = 3.85, C = 29.78),
      maturity = 0, model = "hadwiger"
    )
  )
})

test_that("Error produced when model incorrectly specified", {
  expect_error(
    model_fecundity(
      age = 0:20, params = c(A = 10), maturity = 2,
      model = "invalid"
    )
  )
})

test_that("Error produced when age incorrectly specified", {
  expect_error(
    model_fecundity(
      age = "invalid", params = c(A = 10), maturity = 2,
      model = "step"
    )
  )

  expect_error(
    model_fecundity(
      age = -2:10, params = c(A = 10), maturity = 2,
      model = "step"
    )
  )

  expect_warning(
    model_fecundity(
      age = seq(0, 10, 0.5), params = c(A = 10), maturity = 2,
      model = "step"
    )
  )
})

test_that("Error produced when number of parameters is incorrect", {
  expect_error(
    model_fecundity(
      age = 0:10, params = c(A = 10, B = 4),
      maturity = 2, model = "step"
    )
  )

  expect_error(
    model_fecundity(
      age = 0:10, params = c(A = 10), maturity = 2,
      model = "vonbertalanffy"
    )
  )

  expect_error(
    model_fecundity(
      age = 0:10, params = c(A = 10), maturity = 2,
      model = "logistic"
    )
  )

  expect_error(
    model_fecundity(
      age = 0:10, params = c(A = 10), maturity = 2,
      model = "normal"
    )
  )

  expect_error(
    model_fecundity(
      age = 0:10, params = c(A = 10), maturity = 2,
      model = "hadwiger"
    )
  )
})


test_that("Output type is correct (double)", {
  expect_type(
    model_fecundity(
      age = 0:20, params = c(A = 10, k = 0.5, x_m = 8), maturity =
        0, model = "logistic"
    ),
    "double"
  )


  expect_type(
    model_fecundity(
      age = 0:20, params = c(A = 3), maturity =
        2, model = "step"
    ),
    "double"
  )

  expect_type(
    model_fecundity(
      age = 0:20, params = c(A = 10, k = 0.3), maturity = 2,
      model = "vonbertalanffy"
    ),
    "double"
  )

  expect_type(
    model_fecundity(
      age = 0:20, params = c(A = 10, mu = 4, sd = 2), maturity = 0,
      model = "normal"
    ),
    "double"
  )

  expect_type(
    model_fecundity(
      age = 0:50, params = c(a = 0.91, b = 3.85, c = 29.78), maturity = 0,
      model = "hadwiger"
    ),
    "double"
  )
})
