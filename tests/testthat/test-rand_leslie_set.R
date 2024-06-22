test_that("n_models validation works", {
  expect_error(rand_leslie_set(n_models = "five", mortality_model = "Gompertz", fertility_model = "step",
                               mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                               fertility_params = data.frame(minVal = c(10, 0.5, 8), maxVal = c(11, 0.9, 10)),
                               fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type1"))
  expect_error(rand_leslie_set(n_models = -5, mortality_model = "Gompertz", fertility_model = "step",
                               mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                               fertility_params = data.frame(minVal = c(10, 0.5, 8), maxVal = c(11, 0.9, 10)),
                               fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type1"))
  expect_warning(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                                mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                                fertility_params = data.frame(minVal = c(10), maxVal = c(11)),
                                fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type1"))
})

test_that("mortality_model validation works", {
  expect_error(rand_leslie_set(n_models = 5, mortality_model = "InvalidModel", fertility_model = "step",
                               mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                               fertility_params = data.frame(minVal = c(10, 0.5, 8), maxVal = c(11, 0.9, 10)),
                               fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type1"))
  expect_warning(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                                mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                                fertility_params = data.frame(minVal = c(10), maxVal = c(11)),
                                fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type1"))
})

test_that("fertility_params validation works", {
  expect_error(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "logistic",
                               mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                               fertility_params = data.frame(minVal = c(10, 0.5), maxVal = c(11, 0.9)),
                               fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type1"))
  expect_error(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                               mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                               fertility_params = data.frame(minVal = c(10, 0.5), maxVal = c(11, 0.9)),
                               fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type1"))
  expect_error(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "vonbertalanffy",
                               mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                               fertility_params = data.frame(minVal = c(10, 0.5, 8), maxVal = c(11, 0.9, 10)),
                               fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type1"))
  expect_warning(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                                mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                                fertility_params = data.frame(minVal = 10, maxVal = 12),
                                fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type1"))
})


test_that("mortality_params validation works", {
  expect_error(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                               mortality_params = data.frame(minVal = c(0, 0.01, .2), maxVal = c(0.14, 0.15, .2)),
                               fertility_params = data.frame(minVal = 10, maxVal = 12),
                               fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type1"))
  expect_error(rand_leslie_set(n_models = 5, mortality_model = "WeibullMakeham", fertility_model = "step",
                               mortality_params = data.frame(minVal = c(0), maxVal = c(0.14)),
                               fertility_params = data.frame(minVal = 10, maxVal = 12),
                               fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type1"))
  expect_warning(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                                mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                                fertility_params = data.frame(minVal = 10, maxVal = 12),
                                fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type1"))
})

test_that("fertility_maturity_params validation works", {
  expect_error(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                               mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                               fertility_params = data.frame(minVal = c(10, 0.5, 8), maxVal = c(11, 0.9, 10)),
                               fertility_maturity_params = c(0), dist_type = "uniform", output = "Type1"))
  expect_warning(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                                mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                                fertility_params = data.frame(minVal = 10, maxVal = 12),
                                fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type1"))
})

test_that("dist_type validation works", {
  expect_error(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                               mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                               fertility_params = data.frame(minVal = 10, maxVal = 12),
                               fertility_maturity_params = c(0, 0), dist_type = "invalid", output = "Type1"))
  expect_warning(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                                mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                                fertility_params = data.frame(minVal = 10, maxVal = 12),
                                fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type1"))
})

test_that("output validation works", {
  expect_error(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                               mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                               fertility_params = data.frame(minVal = 10, maxVal = 12),
                               fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "invalid"))
  expect_warning(rand_leslie_set(n_models = 5, mortality_model = "Gompertz", fertility_model = "step",
                                mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                                fertility_params = data.frame(minVal = 10, maxVal = 12),
                                fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type1"))
})


#Check scaling of fertility
x <- rand_leslie_set(n_models = 1, mortality_model = "Gompertz", fertility_model = "step",
                mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                fertility_params = data.frame(minVal = c(10), maxVal = c(11)),
                fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type1",
                scale_output = TRUE)

test_that("scaling works", {
                 expect_lt(abs(1-popdemo::eigs(matA(x)[[1]], what = "lambda")),0.01)
})


x <- rand_leslie_set(n_models = 1, mortality_model = "Gompertz", fertility_model = "step",
                     mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                     fertility_params = data.frame(minVal = c(10), maxVal = c(11)),
                     fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type2",
                     scale_output = TRUE)

test_that("scaling works", {
  expect_lt(abs(1-popdemo::eigs(matA(x)[[1]], what = "lambda")),0.01)
})

x <- rand_leslie_set(n_models = 1, mortality_model = "Gompertz", fertility_model = "step",
                     mortality_params = data.frame(minVal = c(0, 0.01), maxVal = c(0.14, 0.15)),
                     fertility_params = data.frame(minVal = c(10), maxVal = c(11)),
                     fertility_maturity_params = c(0, 0), dist_type = "uniform", output = "Type3",
                     scale_output = TRUE)

test_that("scaling works", {
  expect_lt(abs(1-popdemo::eigs(x[[1]]$mat_A, what = "lambda")),0.01)
})


