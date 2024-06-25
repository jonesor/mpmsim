test_that("Function fails gracefully with incorrect inputs", {
  # A must be a matrix
  expect_error(
    plot_matrix(mat = 1:10)
  )

  # zeroNA must be a logical value
  expect_error(
    plot_matrix(
      mat = matrix(seq(0, 1, length.out = 4), nrow = 2),
      zero_na = "invalid"
    )
  )

  # Legend must be a logical value
  expect_error(
    plot_matrix(
      mat = matrix(seq(0, 1, length.out = 4), nrow = 2),
      legend = "invalid"
    )
  )

  # na_colour must be a valid colour or NA
  expect_error(
    plot_matrix(
      mat = matrix(seq(0, 1, length.out = 4), nrow = 2),
      zero_na = TRUE, na_colour = "invalid"
    )
  )

  expect_error(
    plot_matrix(
      mat = matrix(seq(0, 1, length.out = 4), nrow = 2),
      zero_na = TRUE, na_colour = NULL
    )
  )
})

test_that("Function produces a ggplot correctly", {
  expect_silent(plot_matrix(
    mat = matrix(seq(0, 1, length.out = 4), nrow = 2),
    zero_na = TRUE, legend = TRUE
  ))

  p <- plot_matrix(
    mat = matrix(seq(0, 1, length.out = 4), nrow = 2),
    zero_na = TRUE
  )

  expect_true(
    inherits(p, "ggplot")
  )

  p2 <- plot_matrix(
    mat = matrix(seq(0, 1, length.out = 4), nrow = 2),
    zero_na = TRUE, legend = TRUE
  )

  expect_true(
    inherits(p2, "ggplot")
  )
})
