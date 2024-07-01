# n_stages must be greater than 0
testthat::expect_error(
  suppressWarnings(random_mpm(
    n_stages = -1, fecundity = 20, archetype = 1,
    split = FALSE
  ))
)

# n_stages must be integer
testthat::expect_error(
  suppressWarnings(random_mpm(
    n_stages = 3.5, fecundity = 20, archetype = 1,
    split = FALSE
  ))
)

# fecundity must be numeric
testthat::expect_error(
  suppressWarnings(random_mpm(
    n_stages = 4, fecundity = "text", archetype = 1,
    split = FALSE
  ))
)

# fecundity must be of length 1 or n_stages
testthat::expect_error(
  suppressWarnings(random_mpm(
    n_stages = 4, fecundity = c(12, 5),
    archetype = 1, split = FALSE
  ))
)

# Split must be logical
testthat::expect_error(
  suppressWarnings(random_mpm(
    n_stages = 4, fecundity = 5,
    archetype = 1, split = "text"
  ))
)

# Archetype is an integer between 1 and 4
testthat::expect_error(
  suppressWarnings(random_mpm(
    n_stages = 4, fecundity = 5,
    archetype = 0, split = FALSE
  ))
)

testthat::expect_error(
  suppressWarnings(random_mpm(
    n_stages = 4, fecundity = 5,
    archetype = 5, split = FALSE
  ))
)

testthat::expect_error(
  suppressWarnings(random_mpm(
    n_stages = 4, fecundity = 5,
    archetype = 1.5, split = FALSE
  ))
)

testthat::expect_error(
  suppressWarnings(random_mpm(
    n_stages = 2, fecundity = 5,
    archetype = 3, split = FALSE
  ))
)

testthat::expect_error(
  suppressWarnings(random_mpm(
    n_stages = 2, fecundity = 5,
    archetype = 4, split = FALSE
  ))
)


# Check that output is a matrix
testthat::expect_true(
  is.matrix(suppressWarnings(random_mpm(
    n_stages = 4, fecundity = 5, archetype = 1,
    split = FALSE
  )))
)

x <- suppressWarnings(random_mpm(
  n_stages = 4, fecundity = 20,
  archetype = 1, split = TRUE
))
testthat::expect_true(
  inherits(x, "list")
)

x <- suppressWarnings(random_mpm(
  n_stages = 4, fecundity = 20,
  archetype = 2, split = TRUE
))
testthat::expect_true(
  inherits(x, "list")
)
x <- suppressWarnings(random_mpm(
  n_stages = 4, fecundity = 20,
  archetype = 3, split = TRUE
))
testthat::expect_true(
  inherits(x, "list")
)
x <- suppressWarnings(random_mpm(
  n_stages = 4, fecundity = 20,
  archetype = 4, split = TRUE
))
testthat::expect_true(
  inherits(x, "list")
)

x <- suppressWarnings(random_mpm(
  n_stages = 4, fecundity = 20,
  archetype = 1, split = FALSE
))
testthat::expect_true(
  inherits(x, "matrix")
)

x <- suppressWarnings(random_mpm(
  n_stages = 4, fecundity = 20,
  archetype = 2, split = FALSE
))
testthat::expect_true(
  inherits(x, "matrix")
)
x <- suppressWarnings(random_mpm(
  n_stages = 4, fecundity = 20,
  archetype = 3, split = FALSE
))
testthat::expect_true(
  inherits(x, "matrix")
)
x <- suppressWarnings(random_mpm(
  n_stages = 4, fecundity = 20,
  archetype = 4, split = FALSE
))
testthat::expect_true(
  inherits(x, "matrix")
)

x <- suppressWarnings(random_mpm(
  n_stages = 4, fecundity = c(0, 2, 10, 20),
  archetype = 4, split = FALSE
))
testthat::expect_true(
  inherits(x, "matrix")
)

fec_mat <- matrix(c(
  0, 1, 70,
  0, 0, 0,
  0, 0, 0
), ncol = 3, byrow = TRUE)
testthat::expect_error(
  suppressWarnings(random_mpm(
    n_stages = 2, fecundity = fec_mat,
    archetype = 1, split = FALSE
  ))
)


# Lower limit to fecundity
fec_mat_lower <- matrix(c(
  0, 1, 70,
  0, 0, 0,
  0, 0, 0
), ncol = 3, byrow = TRUE)

# Upper limit to fecundity
fec_mat_upper <- matrix(c(
  0, 5, 100,
  0, 0, 0,
  0, 0, 0
), ncol = 3, byrow = TRUE)

# Place the two matrices in a list
fec_mats <- list(fec_mat_lower, fec_mat_upper)

testthat::expect_error(
  suppressWarnings(random_mpm(
    n_stages = 2, fecundity = fec_mats,
    archetype = 1, split = FALSE
  ))
)


fec_mat <- matrix(c(
  0, -1, 70,
  0, 0, 0,
  0, 0, 0
), ncol = 3, byrow = TRUE)
testthat::expect_error(
  suppressWarnings(random_mpm(
    n_stages = 3, fecundity = fec_mat,
    archetype = 1, split = FALSE
  ))
)

# Lower limit to fecundity
fec_mat_lower <- matrix(c(
  0, 5, 70,
  0, 0, 0,
  0, 0, 0
), ncol = 3, byrow = TRUE)

# Upper limit to fecundity
fec_mat_upper <- matrix(c(
  0, 1, 100,
  0, 0, 0,
  0, 0, 0
), ncol = 3, byrow = TRUE)

# Place the two matrices in a list
fec_mats <- list(fec_mat_lower, fec_mat_upper)

testthat::expect_error(
  suppressWarnings(random_mpm(
    n_stages = 3, fecundity = fec_mats,
    archetype = 1, split = FALSE
  ))
)

# Check bounds of fecundity matrices

# Lower limit to fecundity
fec_mat_lower <- matrix(c(
  0, 5, 70,
  0, 0, 0,
  0, 0, 0
), ncol = 3, byrow = TRUE)

# Upper limit to fecundity
fec_mat_upper <- matrix(c(
  0, 1, 100,
  0, 0, 0,
  0, 0, 0
), ncol = 3, byrow = TRUE)

# Place the two matrices in a list
fec_mats <- list(fec_mat_lower, fec_mat_upper)

testthat::expect_error(
  suppressWarnings(random_mpm(
    n_stages = 3, fecundity = fec_mats,
    archetype = 1, split = FALSE
  ))
)


# Lower limit to fecundity
fec_mat_lower <- matrix(c(
  0, 5, 70,
  0, 0, 0,
  0, 0, 0
), ncol = 3, byrow = TRUE)

# Upper limit to fecundity
fec_mat_upper <- matrix(c(
  0, 1, 100,
  0, 0, 0,
  0, 0, 0
), ncol = 3, byrow = TRUE)

# Place the two matrices in a list
fec_mats <- list(fec_mat_lower, fec_mat_upper, fec_mat_upper)

testthat::expect_error(
  suppressWarnings(random_mpm(
    n_stages = 3, fecundity = fec_mats,
    archetype = 1, split = FALSE
  ))
)

# Lower limit to fecundity
fec_mat_lower <- matrix(c(
  0, 5, 70,
  0, 0, 0,
  0, 0, 0
), ncol = 3, byrow = TRUE)

# Upper limit to fecundity
fec_mat_upper <- matrix(c(
  0, 10, 100,
  0, 0, 0,
  0, 0, 0
), ncol = 3, byrow = TRUE)

# Place the two matrices in a list
fec_mats <- list(fec_mat_lower, fec_mat_upper)
temp <- suppressWarnings(random_mpm(
  n_stages = 3, fecundity = fec_mats,
  archetype = 1, split = FALSE
))
testthat::expect_true(inherits(temp, "matrix"))


fec_mat <- matrix(c(
  0, 5, 70,
  0, 0, 0,
  0, 0, 0
), ncol = 3, byrow = TRUE)
temp <- suppressWarnings(random_mpm(
  n_stages = 3, fecundity = fec_mat,
  archetype = 1, split = FALSE
))
testthat::expect_true(inherits(temp, "matrix"))
