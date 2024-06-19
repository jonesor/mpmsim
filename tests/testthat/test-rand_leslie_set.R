test_that("n_models validation works", {
  expect_error(rand_leslie_set(n_models = "five", mortality_model = "Gompertz", fertility_model = "step",
                               mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                               fertility_params = data.frame(minVal = c(10, 0.5, 8), maxVal = c(11, 0.9, 10)),
                               fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "mpm"))
  expect_error(rand_leslie_set(n_models = -5, mortality_model = "Gompertz", fertility_model = "step",
                               mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                               fertility_params = data.frame(minVal = c(10, 0.5, 8), maxVal = c(11, 0.9, 10)),
                               fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "mpm"))
  expect_warning(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                                mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                                fertility_params = data.frame(minVal = c(10), maxVal = c(11)),
                                fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "mpm"))
})

test_that("mortality_model validation works", {
  expect_error(rand_leslie_set(n_models = 5, mortality_model = "InvalidModel", fertility_model = "step",
                               mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                               fertility_params = data.frame(minVal = c(10, 0.5, 8), maxVal = c(11, 0.9, 10)),
                               fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "mpm"))
  expect_warning(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                                mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                                fertility_params = data.frame(minVal = c(10), maxVal = c(11)),
                                fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "mpm"))
})

test_that("fertility_params validation works", {
  expect_error(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "logistic",
                               mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                               fertility_params = data.frame(minVal = c(10, 0.5), maxVal = c(11, 0.9)),
                               fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "mpm"))
  expect_error(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                               mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                               fertility_params = data.frame(minVal = c(10, 0.5), maxVal = c(11, 0.9)),
                               fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "mpm"))
  expect_error(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "vonbertalanffy",
                               mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                               fertility_params = data.frame(minVal = c(10, 0.5, 8), maxVal = c(11, 0.9, 10)),
                               fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "mpm"))
  expect_warning(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                                mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                                fertility_params = data.frame(minVal = 10, maxVal = 12),
                                fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "mpm"))
})


test_that("mortality_params validation works", {
  expect_error(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                               mortality_params = data.frame(minVal = c(0, 0.01, .2), maxVal = c(0.14, 0.15, .2)),
                               fertility_params = data.frame(minVal = 10, maxVal = 12),
                               fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "mpm"))
  expect_error(rand_leslie_set(n_models = 5, mortality_model = "WeibullMakeham", fertility_model = "step",
                               mortality_params = data.frame(minVal = c(0), maxVal = c(0.14)),
                               fertility_params = data.frame(minVal = 10, maxVal = 12),
                               fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "mpm"))
  expect_warning(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                                mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                                fertility_params = data.frame(minVal = 10, maxVal = 12),
                                fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "mpm"))
})

test_that("fertility_maturity_params validation works", {
  expect_error(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                               mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                               fertility_params = data.frame(minVal = c(10, 0.5, 8), maxVal = c(11, 0.9, 10)),
                               fertility_maturity_params = c(0), dist_type = "uniform", output = "mpm"))
  expect_warning(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                                mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                                fertility_params = data.frame(minVal = 10, maxVal = 12),
                                fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "mpm"))
})

test_that("dist_type validation works", {
  expect_error(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                               mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                               fertility_params = data.frame(minVal = 10, maxVal = 12),
                               fertility_maturity_params = c(0, 0), dist_type = "invalid", output = "mpm"))
  expect_warning(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                                mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                                fertility_params = data.frame(minVal = 10, maxVal = 12),
                                fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "mpm"))
})

test_that("output validation works", {
  expect_error(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                               mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                               fertility_params = data.frame(minVal = 10, maxVal = 12),
                               fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "invalid"))
  expect_warning(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                                mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                                fertility_params = data.frame(minVal = 10, maxVal = 12),
                                fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "mpm"))
})

