test_that("Check cumulative_auc fails gracefully with incorrect inputs", {
  expect_error(
    cumulative_auc(x = c(0, 1, 2, 3, 4), y = c(0, 1, 2, 3))
  )

  expect_error(
    cumulative_auc(x = as.character(c(0, 1, 2, 3)), y = c(0, 1, 2, 3))
  )

  expect_error(
    cumulative_auc(x = c(0, 1, 2, 3), y = as.character(c(0, 1, 2, 3)))
  )

  x <- cumulative_auc(c(0, 1, 2, 3), c(0, 1, 2, 3))

  expect_true(
    inherits(x, "numeric")
  )

  expect_identical(
    sum(x), 7
  )
})

test_that("Check calculate_surv_prob fails gracefully with incorrect inputs", {
  expect_error(
    calculate_surv_prob(lx = c(1, 0.8, 0.9, 0.4, 0.2, 0.1))
  )

  expect_error(
    calculate_surv_prob(lx = as.character(c(1, 0.8, 0.7, 0.4, 0.2, 0.1)))
  )

  expect_error(
    calculate_surv_prob(lx = 0.5)
  )
})

test_that("Check calculate_surv_prob fails gracefully with incorrect inputs", {
  expect_true(
    inherits(calculate_surv_prob(lx = c(1, 0.8, 0.7, 0.4, 0.2, 0.1)), "numeric")
  )
})


expect_error(
  model_survival(
    x = as.character(0:100), params = c(b_0 = 0.1, b_1 = 0.2),
    model = "Gompertz"
  )
)

test_that("Check model_survival functions correctly", {
  expect_silent(
    model_mortality(
      params = c(b_0 = 0.1, b_1 = 0.2),
      model = "Gompertz"
    )
  )

  expect_silent(
    model_mortality(
      params = c(b_0 = 0.1, b_1 = 0.2, C = 0.1),
      model = "GompertzMakeham",
      truncate = 0.1
    )
  )

  expect_silent(
    model_mortality(params = c(c = 0.2), model = "Exponential", age = 0:10)
  )

  expect_silent(
    model_mortality(
      params = c(a_0 = 0.1, a_1 = 0.2, C = 0.1, b_0 = 0.1, b_1 = 0.2),
      model = "Siler",
      age = 0:10
    )
  )

  expect_silent(
    model_mortality(
      params = c(b_0 = 1.4, b_1 = 0.18),
      model = "Weibull"
    )
  )

  expect_silent(
    model_mortality(
      params = c(b_0 = 1.1, b_1 = 0.05, c = 0.2),
      model = "WeibullMakeham"
    )
  )

  expect_silent(
    model_mortality(params = c(b_0 = 0.1, b_1 = 0.2), model = "Gompertz")
  )
})

test_that("Check model_survival fails/warns gracefully with incorrect age
          specification", {
  expect_error(
    model_mortality(
      age = 10:1, params = c(b_0 = 0.1, b_1 = 0.2),
      model = "Gompertz"
    )
  )

  expect_warning(
    model_mortality(
      age = seq(0, 10, 0.5), params = c(b_0 = 0.1, b_1 = 0.2),
      model = "Gompertz"
    )
  )
})

test_that("Check model_survival fails gracefully with incorrect truncate
          specification", {
  expect_error(
    model_survival(
      params = c(b_0 = 0.1, b_1 = 0.2), model = "Gompertz",
      truncate = 1.1
    )
  )


  expect_error(
    model_survival(
      params = c(b_0 = 0.1, b_1 = 0.2), model = "Gompertz",
      truncate = "0.05"
    )
  )
})

test_that("Check model_survival fails gracefully with incorrect model
          specification", {
  expect_error(
    model_survival(params = c(b_0 = 0.1, b_1 = 0.2), model = "invalid")
  )

  expect_error(
    model_survival(params = c(b_0 = 0.1), model = "Gompertz")
  )

  expect_error(
    model_survival(
      params = c(c = 0.2, d = 0.1),
      model = "Exponential"
    )
  )

  expect_error(
    model_survival(
      params = c(b_0 = 0.1, b_1 = 0.2), model = "GompertzMakeham"
    )
  )

  expect_error(
    model_survival(
      params = c(a_0 = 0.1, a_1 = 0.2, C = 0.1, b_0 = 0.1),
      model = "Siler"
    )
  )
})


test_that("Check function outputs are correct type", {
  expect_true(
    inherits(model_survival(
      params = c(b_0 = 0.1, b_1 = 0.2),
      model = "Gompertz"
    ), "data.frame")
  )

  expect_true(
    inherits(model_survival(
      params = c(b_0 = 0.1, b_1 = 0.2, C = 0.1), model = "GompertzMakeham",
      truncate = 0.1
    ), "data.frame")
  )

  expect_true(
    inherits(model_survival(
      params = c(c = 0.2),
      model = "Exponential"
    ), "data.frame")
  )

  expect_true(
    inherits(model_survival(
      params = c(a_0 = 0.1, a_1 = 0.2, C = 0.1, b_0 = 0.1, b_1 = 0.2),
      model = "Siler"
    ), "data.frame")
  )
})
