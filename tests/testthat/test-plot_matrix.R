# A must be a matrix
testthat::expect_error(
  plot_matrix(A = c(1:10))
)

# zeroNA must be a logical value
testthat::expect_error(
  plot_matrix(A = matrix(seq(0, 1, length.out = 4), nrow = 2), zeroNA = "yes")
)

# Legend must be a logical value
testthat::expect_error(
  plot_matrix(A = matrix(seq(0, 1, length.out = 4), nrow = 2), legend = "yes")
)

# na_colour must be a valid colour or NA
testthat::expect_error(
  plot_matrix(A = matrix(seq(0, 1, length.out = 4), nrow = 2), zeroNA = TRUE, na_colour = "greyyyyy80")
)
