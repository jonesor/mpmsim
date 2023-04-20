testthat::expect_error(
  logit("text")
)
testthat::expect_error(
  logit(1.5)
)
testthat::expect_error(
  logit(-0.5)
)

testthat::expect_error(
  inverse_logit("text")
)

driven_vital_rate(
  driver = 14,
  baseline_value = 0.5,
  slope = 0.4,
  baseline_driver = 10,
  error_sd = 0,
  link = "logit"
)

testthat::expect_error(
  driven_vital_rate(
    driver = "text",
    baseline_value = 0.5,
    slope = 0.4,
    baseline_driver = 10,
    error_sd = 0,
    link = "logit"
  )
)

testthat::expect_error(
  driven_vital_rate(
    driver = c(14, NA, 16),
    baseline_value = 0.5,
    slope = 0.4,
    baseline_driver = 10,
    error_sd = 0,
    link = "logit"
  )
)

testthat::expect_error(
  driven_vital_rate(
    driver = c(14, 16),
    baseline_value = 0.5,
    slope = 0.4,
    baseline_driver = c(10, 11),
    error_sd = 0,
    link = "logit"
  )
)

testthat::expect_error(
  driven_vital_rate(
    driver = 14,
    baseline_value = matrix(c(0.4, NA, 0.6, 0.7), ncol = 2, nrow = 2),
    slope = 0.4,
    baseline_driver = 12,
    error_sd = 0,
    link = "logit"
  )
)

testthat::expect_error(
  driven_vital_rate(
    driver = 14,
    baseline_value = matrix(c(-0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
    slope = 0.4,
    baseline_driver = 12,
    error_sd = 0,
    link = "logit"
  )
)

testthat::expect_error(
  driven_vital_rate(
    driver = 14,
    baseline_value = matrix(c(1.1, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
    slope = 0.4,
    baseline_driver = 12,
    error_sd = 0,
    link = "logit"
  )
)


testthat::expect_error(
  driven_vital_rate(
    driver = 14,
    baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
    slope = c(0.4, 0.5),
    baseline_driver = 12,
    error_sd = 0,
    link = "logit"
  )
)

testthat::expect_error(
  driven_vital_rate(
    driver = 14,
    baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
    slope = matrix(c(0.4, NA, 0.6, 0.7), ncol = 2, nrow = 2),
    baseline_driver = 12,
    error_sd = 0,
    link = "logit"
  )
)

testthat::expect_error(
  driven_vital_rate(
    driver = 14,
    baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
    slope = matrix(c(0.4, 0.3, 0.6, 0.7), ncol = 2, nrow = 2),
    baseline_driver = 12,
    error_sd = c(0.1, 0.2),
    link = "logit"
  )
)

testthat::expect_error(
  driven_vital_rate(
    driver = 14,
    baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
    slope = matrix(c(0.4, 0.3, 0.6, 0.7), ncol = 2, nrow = 2),
    baseline_driver = 12,
    error_sd = matrix(c(0.1, NA, 0.3, 0.4), ncol = 2, nrow = 2),
    link = "logit"
  )
)

testthat::expect_error(
  driven_vital_rate(
    driver = 14,
    baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
    slope = matrix(c(0.4, 0.3, 0.6, 0.7), ncol = 2, nrow = 2),
    baseline_driver = 12,
    error_sd = matrix(c(-0.1, 0.2, 0.3, 0.4), ncol = 2, nrow = 2),
    link = "logit"
  )
)


testthat::expect_error(
  driven_vital_rate(
    driver = 14,
    baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
    slope = matrix(c(0.4, 0.3, 0.6, 0.7), ncol = 2, nrow = 2),
    baseline_driver = 12,
    error_sd = matrix(c(0.1, 0.2, 0.3, 0.4), ncol = 2, nrow = 2),
    link = "blurg"
  )
)


testthat::expect_error(
  driven_vital_rate(
    driver = 14,
    baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
    slope = matrix(c(0.4, 0.3, 0.6, 0.7), ncol = 2, nrow = 2),
    baseline_driver = 12,
    error_sd = matrix(c(0.1, 0.2, 0.3, 0.4), ncol = 2, nrow = 2),
    link = c("logit", "logit")
  )
)

testthat::expect_true(
  inherits(driven_vital_rate(
    driver = 14,
    baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
    slope = matrix(c(0.4, 0.3, 0.6, 0.7), ncol = 2, nrow = 2),
    baseline_driver = 12,
    error_sd = matrix(c(0.1, 0.2, 0.3, 0.4), ncol = 2, nrow = 2),
    link = "logit"
  ), "matrix")
)

testthat::expect_true(
  inherits(driven_vital_rate(
    driver = 14:15,
    baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
    slope = matrix(c(0.4, 0.3, 0.6, 0.7), ncol = 2, nrow = 2),
    baseline_driver = 12,
    error_sd = matrix(c(0.1, 0.2, 0.3, 0.4), ncol = 2, nrow = 2),
    link = "logit"
  ), "list")
)

testthat::expect_true(
  inherits(driven_vital_rate(
    driver = 14,
    baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
    slope = matrix(c(0.4, 0.3, 0.6, 0.7), ncol = 2, nrow = 2),
    baseline_driver = 12,
    error_sd = matrix(c(0.1, 0.2, 0.3, 0.4), ncol = 2, nrow = 2),
    link = "log"
  ), "matrix")
)
