test_that("function works correctly for all mortality_model types, uniform
          distribution", {
  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
      mortality_params = data.frame(
        minVal = c(0, 0.01),
        maxVal = c(0.14, 0.15)
      ),
      fertility_params = data.frame(minVal = c(4), maxVal = c(4)),
      fertility_maturity_params = c(0, 0), dist_type = "uniform",
      output = "Type5"
    )
  )

  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "GompertzMakeham",
      fertility_model = "step",
      mortality_params = data.frame(
        minVal = c(0.1, 0.2, 0.1),
        maxVal = c(0.14, 0.25, 0.12)
      ),
      fertility_params = data.frame(minVal = c(4), maxVal = c(4)),
      fertility_maturity_params = c(0, 0), dist_type = "uniform",
      output = "Type5"
    )
  )

  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "Exponential", fertility_model = "step",
      mortality_params = data.frame(minVal = c(0.1), maxVal = c(0.2)),
      fertility_params = data.frame(minVal = c(4), maxVal = c(4)),
      fertility_maturity_params = c(0, 0), dist_type = "uniform",
      output = "Type5"
    )
  )

  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "Weibull", fertility_model = "step",
      mortality_params = data.frame(
        minVal = c(1.4, 0.18),
        maxVal = c(1.7, 0.28)
      ),
      fertility_params = data.frame(minVal = c(4), maxVal = c(4)),
      fertility_maturity_params = c(0, 0), dist_type = "uniform",
      output = "Type5"
    )
  )
  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "WeibullMakeham",
      fertility_model = "step",
      mortality_params = data.frame(
        minVal = c(1.1, 0.05, 0.2),
        maxVal = c(1.3, 0.15, 0.3)
      ),
      fertility_params = data.frame(minVal = c(4), maxVal = c(4)),
      fertility_maturity_params = c(0, 0), dist_type = "uniform",
      output = "Type5"
    )
  )

  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "Siler", fertility_model = "step",
      mortality_params = data.frame(
        minVal = c(a_0 = 0.1, a_1 = 0.2, C = 0.1, b_0 = 0.1, b_1 = 0.2),
        maxVal = c(a_0 = 0.2, a_1 = 0.3, C = 0.2, b_0 = 0.2, b_1 = 0.3)
      ),
      fertility_params = data.frame(minVal = c(4), maxVal = c(4)),
      fertility_maturity_params = c(0, 0), dist_type = "uniform",
      output = "Type5"
    )
  )
})

test_that("function works correctly for all mortality_model types,
          normal distribution", {
  set.seed(42)
  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
      mortality_params = data.frame(
        meanVal = c(0.1, 0.1),
        sdVal = c(0.01, 0.05)
      ),
      fertility_params = data.frame(meanVal = c(4), sdVal = c(0.2)),
      fertility_maturity_params = c(0, 0), dist_type = "normal",
      output = "Type5"
    )
  )

  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "GompertzMakeham",
      fertility_model = "step",
      mortality_params = data.frame(
        meanVal = c(0.14, 0.25, 0.12),
        sdVal = c(0.04, 0.05, 0.02)
      ),
      fertility_params = data.frame(meanVal = c(4), sdVal = c(0.2)),
      fertility_maturity_params = c(0, 0), dist_type = "normal",
      output = "Type5"
    )
  )

  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "Exponential", fertility_model = "step",
      mortality_params = data.frame(meanVal = c(0.2), sdVal = c(0.02)),
      fertility_params = data.frame(meanVal = c(4), sdVal = c(.4)),
      fertility_maturity_params = c(0, 0), dist_type = "normal",
      output = "Type5"
    )
  )

  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "Weibull", fertility_model = "step",
      mortality_params = data.frame(
        meanVal = c(1.7, 0.28),
        sdVal = c(.01, 0.01)
      ),
      fertility_params = data.frame(meanVal = c(4), sdVal = c(.4)),
      fertility_maturity_params = c(0, 0), dist_type = "normal",
      output = "Type5"
    )
  )

  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "WeibullMakeham",
      fertility_model = "step",
      mortality_params = data.frame(
        meanVal = c(1.3, 0.15, 0.3),
        sdVal = c(.03, 0.0015, 0.003)
      ),
      fertility_params = data.frame(meanVal = c(4), sdVal = c(.4)),
      fertility_maturity_params = c(0, 0), dist_type = "normal",
      output = "Type5"
    )
  )

  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "Siler", fertility_model = "step",
      mortality_params = data.frame(
        meanVal = c(a_0 = 0.2, a_1 = 0.3, C = 0.2, b_0 = 0.2, b_1 = 0.3),
        sdVal = c(a_0 = 0.02, a_1 = 0.03, C = 0.02, b_0 = 0.02, b_1 = 0.30)
      ),
      fertility_params = data.frame(meanVal = c(4), sdVal = c(.4)),
      fertility_maturity_params = c(0, 0), dist_type = "normal",
      output = "Type5"
    )
  )
})

test_that("function works correctly for all fertility_model types,
          uniform distribution", {
  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
      mortality_params = data.frame(
        minVal = c(0, 0.01),
        maxVal = c(0.14, 0.15)
      ),
      fertility_params = data.frame(minVal = c(4), maxVal = c(6)),
      fertility_maturity_params = c(0, 0), dist_type = "uniform",
      output = "Type5"
    )
  )

  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "Gompertz", fertility_model = "logistic",
      mortality_params = data.frame(
        minVal = c(0, 0.01),
        maxVal = c(0.14, 0.15)
      ),
      fertility_params = data.frame(
        minVal = c(10, 0.5, 8),
        maxVal = c(12, 1.5, 10)
      ),
      fertility_maturity_params = c(0, 0), dist_type = "uniform",
      output = "Type5"
    )
  )

  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "Gompertz",
      fertility_model = "vonbertalanffy",
      mortality_params = data.frame(
        minVal = c(0, 0.01),
        maxVal = c(0.14, 0.15)
      ),
      fertility_params = data.frame(
        minVal = c(10, 0.3),
        maxVal = c(12, 0.8)
      ),
      fertility_maturity_params = c(0, 0), dist_type = "uniform",
      output = "Type5"
    )
  )

  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "Gompertz", fertility_model = "normal",
      mortality_params = data.frame(
        minVal = c(0, 0.01),
        maxVal = c(0.14, 0.15)
      ),
      fertility_params = data.frame(
        minVal = c(10, 4, 2),
        maxVal = c(12, 8, 3)
      ),
      fertility_maturity_params = c(0, 0), dist_type = "uniform",
      output = "Type5"
    )
  )

  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "Gompertz", fertility_model = "hadwiger",
      mortality_params = data.frame(
        minVal = c(0, 0.01),
        maxVal = c(0.14, 0.15)
      ),
      fertility_params = data.frame(
        minVal = c(a = 0.91, b = 3.85, C = 29.78),
        maxVal = c(a = 0.95, b = 3.95, C = 39.78)
      ),
      fertility_maturity_params = c(0, 0), dist_type = "uniform",
      output = "Type5"
    )
  )
})

test_that("function works correctly for all fertility_model types,
          normal distribution", {
  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
      mortality_params = data.frame(
        meanVal = c(0.14, 0.15),
        sdVal = c(0.014, 0.015)
      ),
      fertility_params = data.frame(meanVal = c(6), sdVal = c(1)),
      fertility_maturity_params = c(0, 0), dist_type = "normal",
      output = "Type5"
    )
  )

  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "Gompertz", fertility_model = "logistic",
      mortality_params = data.frame(
        meanVal = c(0.14, 0.15),
        sdVal = c(0.014, 0.015)
      ),
      fertility_params = data.frame(
        meanVal = c(12, 1.5, 10),
        sdVal = c(1.2, .15, .10)
      ),
      fertility_maturity_params = c(0, 0), dist_type = "normal",
      output = "Type5"
    )
  )

  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "Gompertz",
      fertility_model = "vonbertalanffy",
      mortality_params = data.frame(
        meanVal = c(0.14, 0.15),
        sdVal = c(0.014, 0.015)
      ),
      fertility_params = data.frame(meanVal = c(12, 0.8), sdVal = c(.12, .08)),
      fertility_maturity_params = c(0, 0), dist_type = "normal",
      output = "Type5"
    )
  )

  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "Gompertz", fertility_model = "normal",
      mortality_params = data.frame(
        meanVal = c(0.14, 0.15),
        sdVal = c(0.014, 0.015)
      ),
      fertility_params = data.frame(
        meanVal = c(12, 8, 3),
        sdVal = c(.12, .8, .3)
      ),
      fertility_maturity_params = c(0, 0), dist_type = "normal",
      output = "Type5"
    )
  )

  expect_silent(
    rand_leslie_set(
      n_models = 5, mortality_model = "Gompertz", fertility_model = "hadwiger",
      mortality_params = data.frame(
        meanVal = c(0.14, 0.15),
        sdVal = c(0.014, 0.015)
      ),
      fertility_params = data.frame(
        meanVal = c(a = 0.95, b = 3.95, C = 39.78),
        sdVal = c(a = 0.095, b = .5, C = 3.78)
      ),
      fertility_maturity_params = c(0, 0), dist_type = "normal",
      output = "Type5"
    )
  )
})



test_that("fertility_model validation works", {
  expect_error(rand_leslie_set(
    n_models = 5, mortality_model = "Gompertz", fertility_model = "invalid",
    mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
    fertility_params = data.frame(minVal = c(4), maxVal = c(4)),
    fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type5"
  ))
})

test_that("n_models validation works", {
  expect_error(rand_leslie_set(
    n_models = "five", mortality_model = "Gompertz", fertility_model = "step",
    mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
    fertility_params = data.frame(
      minVal = c(10, 0.5, 8),
      maxVal = c(11, 0.9, 10)
    ),
    fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type5"
  ))
  expect_error(rand_leslie_set(
    n_models = -5, mortality_model = "Gompertz", fertility_model = "step",
    mortality_params = data.frame(
      minVal = c(0, 0.01),
      maxVal = c(0.14, 0.15)
    ),
    fertility_params = data.frame(
      minVal = c(10, 0.5, 8),
      maxVal = c(11, 0.9, 10)
    ),
    fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type5"
  ))
})

test_that("mortality_model validation works", {
  expect_error(rand_leslie_set(
    n_models = 5, mortality_model = "InvalidModel", fertility_model = "step",
    mortality_params = data.frame(
      minVal = c(0, 0.01),
      maxVal = c(0.14, 0.15)
    ),
    fertility_params = data.frame(
      minVal = c(10, 0.5, 8),
      maxVal = c(11, 0.9, 10)
    ),
    fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type5"
  ))
})

test_that("fertility_params validation works", {
  expect_error(rand_leslie_set(
    n_models = 5, mortality_model = "Gompertz", fertility_model = "logistic",
    mortality_params = data.frame(
      minVal = c(0, 0.01),
      maxVal = c(0.14, 0.15)
    ),
    fertility_params = data.frame(
      minVal = c(10, 0.5),
      maxVal = c(11, 0.9)
    ),
    fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type5"
  ))
  expect_error(rand_leslie_set(
    n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
    mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
    fertility_params = data.frame(minVal = c(10, 0.5), maxVal = c(11, 0.9)),
    fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type5"
  ))
  expect_error(rand_leslie_set(
    n_models = 5, mortality_model = "Gompertz",
    fertility_model = "vonbertalanffy",
    mortality_params = data.frame(
      minVal = c(0, 0.01),
      maxVal = c(0.14, 0.15)
    ),
    fertility_params = data.frame(
      minVal = c(10, 0.5, 8),
      maxVal = c(11, 0.9, 10)
    ),
    fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type5"
  ))
})


test_that("mortality_params validation works", {
  expect_error(rand_leslie_set(
    n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
    mortality_params = data.frame(
      minVal = c(0, 0.01, .2),
      maxVal = c(0.14, 0.15, .2)
    ),
    fertility_params = data.frame(minVal = 10, maxVal = 12),
    fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type5"
  ))
  expect_error(rand_leslie_set(
    n_models = 5, mortality_model = "WeibullMakeham", fertility_model = "step",
    mortality_params = data.frame(minVal = c(0), maxVal = c(0.14)),
    fertility_params = data.frame(minVal = 10, maxVal = 12),
    fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type5"
  ))
})

test_that("fertility_maturity_params validation works", {
  expect_error(rand_leslie_set(
    n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
    mortality_params = data.frame(
      minVal = c(0, 0.01),
      maxVal = c(0.14, 0.15)
    ),
    fertility_params = data.frame(
      minVal = c(10, 0.5, 8),
      maxVal = c(11, 0.9, 10)
    ),
    fertility_maturity_params = c(0), dist_type = "uniform", output = "Type5"
  ))
})

test_that("dist_type validation works", {
  expect_error(rand_leslie_set(
    n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
    mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
    fertility_params = data.frame(minVal = 10, maxVal = 12),
    fertility_maturity_params = c(0, 0), dist_type = "invalid", output = "Type5"
  ))
})

test_that("output validation works", {
  expect_error(rand_leslie_set(
    n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
    mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
    fertility_params = data.frame(minVal = 10, maxVal = 12),
    fertility_maturity_params = c(0, 0), dist_type = "uniform",
    output = "invalid"
  ))
})


# Check scaling of fertility
x_1 <- suppressWarnings(rand_leslie_set(
  n_models = 1, mortality_model = "Gompertz", fertility_model = "step",
  mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
  fertility_params = data.frame(minVal = c(10), maxVal = c(11)),
  fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type1",
  scale_output = TRUE
))

x_2 <- suppressWarnings(rand_leslie_set(
  n_models = 1, mortality_model = "Gompertz", fertility_model = "step",
  mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
  fertility_params = data.frame(minVal = c(10), maxVal = c(11)),
  fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type2",
  scale_output = TRUE
))

x_3 <- rand_leslie_set(
  n_models = 1, mortality_model = "Gompertz", fertility_model = "step",
  mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
  fertility_params = data.frame(minVal = c(10), maxVal = c(11)),
  fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type3",
  scale_output = TRUE
)

x_4 <- rand_leslie_set(
  n_models = 1, mortality_model = "Gompertz", fertility_model = "step",
  mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
  fertility_params = data.frame(minVal = c(10), maxVal = c(11)),
  fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type4",
  scale_output = TRUE
)

x_5 <- rand_leslie_set(
  n_models = 1, mortality_model = "Gompertz", fertility_model = "step",
  mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
  fertility_params = data.frame(minVal = c(10), maxVal = c(11)),
  fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type5",
  scale_output = TRUE
)


test_that("scaling works for all outputs", {
  expect_lt(abs(1 - popdemo::eigs(matA(x_1)[[1]], what = "lambda")), 0.01)

  expect_lt(abs(1 - popdemo::eigs(matA(x_2)[[1]], what = "lambda")), 0.01)

  expect_lt(abs(1 - popdemo::eigs(x_3[[1]]$mat_A, what = "lambda")), 0.01)

  expect_lt(abs(1 - popdemo::eigs(x_4$A_list[[1]], what = "lambda")), 0.01)

  expect_lt(abs(1 - popdemo::eigs(x_5[[1]], what = "lambda")), 0.01)
})


test_that("fertility_maturity_params being incorrect produces error", {
  expect_error(rand_leslie_set(
    n_models = 5, mortality_model = "Gompertz", fertility_model = "normal",
    mortality_params = data.frame(
      minVal = c(0, 0.01),
      maxVal = c(0.14, 0.15)
    ),
    fertility_params = data.frame(
      minVal = c(10, 0.5, 8),
      maxVal = c(11, 0.9, 10)
    ),
    fertility_maturity_params = 0, dist_type = "uniform", output = "Type1"
  ))
})
