# A must be a matrix
testthat::expect_error(
  plot_matrix(mat = 1:10)
)

# zeroNA must be a logical value
testthat::expect_error(
  plot_matrix(
    mat = matrix(seq(0, 1, length.out = 4), nrow = 2),
    zero_na = "yes"
  )
)

# Legend must be a logical value
testthat::expect_error(
  plot_matrix(mat = matrix(seq(0, 1, length.out = 4), nrow = 2), legend = "yes")
)

# na_colour must be a valid colour or NA
testthat::expect_error(
  plot_matrix(
    mat = matrix(seq(0, 1, length.out = 4), nrow = 2),
    zero_na = TRUE, na_colour = "greyyyyy80"
  )
)

testthat::expect_error(
  plot_matrix(
    mat = matrix(seq(0, 1, length.out = 4), nrow = 2),
    zero_na = TRUE, na_colour = NULL
  )
)

p <- plot_matrix(
  mat = matrix(seq(0, 1, length.out = 4), nrow = 2),
  zero_na = TRUE
)

testthat::expect_true(
  inherits(p, "ggplot")
)

p2 <- plot_matrix(
  mat = matrix(seq(0, 1, length.out = 4), nrow = 2),
  zero_na = TRUE, legend = TRUE
)

testthat::expect_true(
  inherits(p2, "ggplot")
)
