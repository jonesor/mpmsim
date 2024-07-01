test_that("Function works", {
  expect_silent(driven_vital_rate(
    driver = 14,
    baseline_value = 0.5,
    slope = 0.4,
    baseline_driver = 10,
    error_sd = 0,
    link = "logit"
  ))
})

test_that("Check that utilities (logit & inverse_logit) fail gracefully", {
  expect_error(
    logit("text")
  )
  expect_error(
    logit(1.5)
  )
  expect_error(
    logit(-0.5)
  )

  expect_error(
    inverse_logit("text")
  )
})


test_that("Check that function fails gracefully with incorrect driver", {
  expect_error(
    driven_vital_rate(
      driver = "invalid",
      baseline_value = 0.5,
      slope = 0.4,
      baseline_driver = 10,
      error_sd = 0,
      link = "logit"
    )
  )

  expect_error(
    driven_vital_rate(
      driver = c(14, NA, 16),
      baseline_value = 0.5,
      slope = 0.4,
      baseline_driver = 10,
      error_sd = 0,
      link = "logit"
    )
  )
})

test_that("Function fails gracefully with incorrect baseline_driver", {
  expect_error(
    driven_vital_rate(
      driver = c(14, 16),
      baseline_value = 0.5,
      slope = 0.4,
      baseline_driver = c(10, 11),
      error_sd = 0,
      link = "logit"
    )
  )

  expect_error(
    driven_vital_rate(
      driver = 14,
      baseline_value = matrix(c(0.4, NA, 0.6, 0.7), ncol = 2, nrow = 2),
      slope = 0.4,
      baseline_driver = 12,
      error_sd = 0,
      link = "logit"
    )
  )
})

test_that("Function fails gracefully with incorrect baseline_value", {
  expect_error(
    driven_vital_rate(
      driver = 14,
      baseline_value = matrix(c(-0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
      slope = 0.4,
      baseline_driver = 12,
      error_sd = 0,
      link = "logit"
    )
  )

  expect_error(
    driven_vital_rate(
      driver = 14,
      baseline_value = matrix(c(1.1, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
      slope = 0.4,
      baseline_driver = 12,
      error_sd = 0,
      link = "logit"
    )
  )
})

test_that("Check that function fails gracefully with incorrect slope", {
  expect_error(
    driven_vital_rate(
      driver = 14,
      baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
      slope = c(0.4, 0.5),
      baseline_driver = 12,
      error_sd = 0,
      link = "logit"
    )
  )

  expect_error(
    driven_vital_rate(
      driver = 14,
      baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
      slope = matrix(c(0.4, NA, 0.6, 0.7), ncol = 2, nrow = 2),
      baseline_driver = 12,
      error_sd = 0,
      link = "logit"
    )
  )
})

test_that("Check that function fails gracefully with incorrect error_sd", {
  expect_error(
    driven_vital_rate(
      driver = 14,
      baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
      slope = matrix(c(0.4, 0.3, 0.6, 0.7), ncol = 2, nrow = 2),
      baseline_driver = 12,
      error_sd = c(0.1, 0.2),
      link = "logit"
    )
  )

  expect_error(
    driven_vital_rate(
      driver = 14,
      baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
      slope = matrix(c(0.4, 0.3, 0.6, 0.7), ncol = 2, nrow = 2),
      baseline_driver = 12,
      error_sd = matrix(c(0.1, NA, 0.3, 0.4), ncol = 2, nrow = 2),
      link = "logit"
    )
  )

  expect_error(
    driven_vital_rate(
      driver = 14,
      baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
      slope = matrix(c(0.4, 0.3, 0.6, 0.7), ncol = 2, nrow = 2),
      baseline_driver = 12,
      error_sd = matrix(c(-0.1, 0.2, 0.3, 0.4), ncol = 2, nrow = 2),
      link = "logit"
    )
  )
})

test_that("Check that function fails gracefully with incorrect link", {
  expect_error(
    driven_vital_rate(
      driver = 14,
      baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
      slope = matrix(c(0.4, 0.3, 0.6, 0.7), ncol = 2, nrow = 2),
      baseline_driver = 12,
      error_sd = matrix(c(0.1, 0.2, 0.3, 0.4), ncol = 2, nrow = 2),
      link = "invalid"
    )
  )
})

test_that("Check that function outputs are correct type", {
  expect_true(
    inherits(driven_vital_rate(
      driver = 14,
      baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
      slope = matrix(c(0.4, 0.3, 0.6, 0.7), ncol = 2, nrow = 2),
      baseline_driver = 12,
      error_sd = matrix(c(0.1, 0.2, 0.3, 0.4), ncol = 2, nrow = 2),
      link = "logit"
    ), "matrix")
  )

  expect_true(
    inherits(driven_vital_rate(
      driver = 14:15,
      baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
      slope = matrix(c(0.4, 0.3, 0.6, 0.7), ncol = 2, nrow = 2),
      baseline_driver = 12,
      error_sd = matrix(c(0.1, 0.2, 0.3, 0.4), ncol = 2, nrow = 2),
      link = "logit"
    ), "list")
  )

  expect_true(
    inherits(driven_vital_rate(
      driver = 14,
      baseline_value = matrix(c(0.4, 0.5, 0.6, 0.7), ncol = 2, nrow = 2),
      slope = matrix(c(0.4, 0.3, 0.6, 0.7), ncol = 2, nrow = 2),
      baseline_driver = 12,
      error_sd = matrix(c(0.1, 0.2, 0.3, 0.4), ncol = 2, nrow = 2),
      link = "log"
    ), "matrix")
  )
})
