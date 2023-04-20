testthat::expect_error(
  model_fertility(
    age = 0:20, params = c(A = 10), maturity = 2,
    model = "blurg"
  )
)

testthat::expect_error(
  model_fertility(
    age = "text", params = c(A = 10), maturity = 2,
    model = "step"
  )
)

testthat::expect_error(
  model_fertility(
    age = -2:10, params = c(A = 10), maturity = 2,
    model = "step"
  )
)

testthat::expect_error(
  model_fertility(
    age = 0:10, params = c(A = 10, B = 4),
    maturity = 2, model = "step"
  )
)

testthat::expect_error(
  model_fertility(
    age = 0:10, params = c(A = 10), maturity = 2,
    model = "vonbertalanffy"
  )
)

testthat::expect_error(
  model_fertility(
    age = 0:10, params = c(A = 10), maturity = 2,
    model = "logistic"
  )
)

testthat::expect_error(
  model_fertility(
    age = 0:10, params = c(A = 10), maturity = 2,
    model = "normal"
  )
)

testthat::expect_error(
  model_fertility(
    age = 0:10, params = c(A = 10), maturity = 2,
    model = "hadwiger"
  )
)

testthat::expect_type(
  model_fertility(
    age = 0:20, params = c(A = 10, k = 0.5, x_m = 8), maturity =
      0, model = "logistic"
  ),
  "double"
)


testthat::expect_type(
  model_fertility(
    age = 0:20, params = c(A = 3), maturity =
      2, model = "step"
  ),
  "double"
)

testthat::expect_type(
  model_fertility(
    age = 0:20, params = c(A = 10, k = 0.3), maturity = 2,
    model = "vonbertalanffy"
  ),
  "double"
)

testthat::expect_type(
  model_fertility(
    age = 0:20, params = c(A = 10, mu = 4, sd = 2), maturity = 0,
    model = "normal"
  ),
  "double"
)

testthat::expect_type(
  model_fertility(
    age = 0:50, params = c(a = 0.91, b = 3.85, c = 29.78), maturity = 0,
    model = "hadwiger"
  ),
  "double"
)
