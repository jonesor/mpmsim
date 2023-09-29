testthat::expect_error(
  cumulative_auc(x = c(0, 1, 2, 3, 4), y = c(0, 1, 2, 3))
)

testthat::expect_error(
  cumulative_auc(x = as.character(c(0, 1, 2, 3)), y = c(0, 1, 2, 3))
)

testthat::expect_error(
  cumulative_auc(x = c(0, 1, 2, 3), y = as.character(c(0, 1, 2, 3)))
)

x <- cumulative_auc(c(0, 1, 2, 3), c(0, 1, 2, 3))
testthat::expect_true(
  inherits(x, "numeric")
)

testthat::expect_identical(
  sum(x), 7
)

testthat::expect_error(
  calculate_surv_prob(lx = c(1, 0.8, 0.9, 0.4, 0.2, 0.1))
)

testthat::expect_error(
  calculate_surv_prob(lx = as.character(c(1, 0.8, 0.7, 0.4, 0.2, 0.1)))
)

testthat::expect_error(
  calculate_surv_prob(lx = 0.5)
)

testthat::expect_true(
  inherits(calculate_surv_prob(lx = c(1, 0.8, 0.7, 0.4, 0.2, 0.1)), "numeric")
)


testthat::expect_error(
  model_survival(
    x = as.character(0:100), params = c(b_0 = 0.1, b_1 = 0.2),
    model = "Gompertz"
  )
)


testthat::expect_error(
  model_survival(
    x = 10:0, params = c(b_0 = 0.1, b_1 = 0.2),
    model = "Gompertz"
  )
)

testthat::expect_error(
  model_survival(params = c(b_0 = 0.1, b_1 = 0.2), model = "blurg")
)

testthat::expect_error(
  model_survival(
    params = c(b_0 = 0.1, b_1 = 0.2), model = "Gompertz",
    truncate = 1.1
  )
)

testthat::expect_error(
  model_survival(
    params = c(b_0 = 0.1, b_1 = 0.2), model = "Gompertz",
    truncate = "0.05"
  )
)

testthat::expect_error(
  model_survival(params = c(b_0 = 0.1), model = "Gompertz")
)

testthat::expect_error(
  model_survival(
    x = 0:10, params = c(c = 0.2, d = 0.1),
    model = "Exponential"
  )
)

testthat::expect_error(
  model_survival(
    params = c(b_0 = 0.1, b_1 = 0.2), model = "GompertzMakeham"
  )
)

testthat::expect_error(
  model_survival(
    params = c(a_0 = 0.1, a_1 = 0.2, C = 0.1, b_0 = 0.1),
    model = "Siler"
  )
)


testthat::expect_true(
  inherits(model_survival(
    params = c(b_0 = 0.1, b_1 = 0.2),
    model = "Gompertz"
  ), "data.frame")
)

testthat::expect_true(
  inherits(model_survival(
    params = c(b_0 = 0.1, b_1 = 0.2, C = 0.1), model = "GompertzMakeham",
    truncate = 0.1
  ), "data.frame")
)

testthat::expect_true(
  inherits(model_survival(
    params = c(c = 0.2),
    model = "Exponential"
  ), "data.frame")
)

testthat::expect_true(
  inherits(model_survival(
    params = c(a_0 = 0.1, a_1 = 0.2, C = 0.1, b_0 = 0.1, b_1 = 0.2),
    model = "Siler"
  ), "data.frame")
)
