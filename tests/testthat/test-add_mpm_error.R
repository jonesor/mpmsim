testthat::expect_identical(simulate_survival(0.5, 0), 0.5)


testthat::expect_identical(simulate_fecundity(0.5, 0), 0.5)


mats <- make_leslie_mpm(
  survival = c(0.1, 0.2, 0.5),
  fertility = c(0, 1.2, 2.4),
  n_stages = 3,
  split = TRUE
)
ssMat <- matrix(10, nrow = 3, ncol = 3)

# Sample size is a single matrix

testthat::expect_error(
  add_mpm_error_indiv(
    mat_U = as.vector(mats$mat_U),
    mat_F = mats$mat_F,
    sample_size = ssMat,
    split = TRUE
  )
)

testthat::expect_error(
  add_mpm_error_indiv(
    mat_U = mats$mat_U,
    mat_F = as.vector(mats$mat_F),
    sample_size = ssMat,
    split = TRUE
  )
)

testthat::expect_error(
  add_mpm_error_indiv(
    mat_U = mats$mat_U,
    mat_F = matrix(
      2,
      nrow = nrow(mats$mat_U) + 1,
      ncol = nrow(mats$mat_U) + 1
    ),
    sample_size = ssMat,
    split = TRUE
  )
)

testthat::expect_error(
  add_mpm_error_indiv(
    mat_U = mats$mat_U,
    mat_F = matrix(
      5,
      nrow = nrow(mats$mat_U),
      ncol = nrow(mats$mat_U) + 1
    ),
    sample_size = ssMat,
    split = TRUE
  )
)

testthat::expect_error(
  add_mpm_error_indiv(
    mat_U = mats$mat_U,
    mat_F = mats$mat_U,
    sample_size = 1:10,
    split = TRUE
  )
)


testthat::expect_error(
  add_mpm_error_indiv(
    mat_U = mats$mat_U,
    mat_F = mats$mat_U,
    sample_size = matrix(10, nrow = 4, ncol = 4),
    split = TRUE
  )
)

testthat::expect_error(add_mpm_error_indiv(
  mat_U = mats$mat_U,
  mat_F = mats$mat_U,
  sample_size = list(matrix(10, nrow = 3, ncol = 3),
    matrix(10, nrow = 3, ncol = 4),
    split = TRUE
  )
))

testthat::expect_error(add_mpm_error_indiv(
  mat_U = mats$mat_U,
  mat_F = mats$mat_U,
  sample_size = list(matrix(10, nrow = 4, ncol = 4),
    matrix(10, nrow = 4, ncol = 4),
    split = TRUE
  )
))

testthat::expect_error(add_mpm_error_indiv(
  mat_U = mats$mat_U,
  mat_F = mats$mat_U,
  sample_size = list(
    mat_X_ss = matrix(10, nrow = 3, ncol = 3),
    mat_Y_ss = matrix(10, nrow = 3, ncol = 3),
    split = TRUE
  )
))

testthat::expect_error(
  add_mpm_error_indiv(
    mat_U = mats$mat_U,
    mat_F = mats$mat_U,
    sample_size = 10.4,
    split = TRUE
  )
)

testthat::expect_error(
  add_mpm_error_indiv(
    mat_U = mats$mat_U,
    mat_F = mats$mat_U,
    sample_size = -10,
    split = TRUE
  )
)

mat_U2 <- mats$mat_U
mat_U2[1, 1] <- -0.1

testthat::expect_error(add_mpm_error_indiv(
  mat_U = mat_U2,
  mat_F = mats$mat_U,
  sample_size = 10,
  split = TRUE
))


mat_F2 <- mats$mat_F
mat_F2[1, 1] <- -0.1

testthat::expect_error(add_mpm_error_indiv(
  mat_U = mats$mat_U,
  mat_F = mat_F2,
  sample_size = 10,
  split = TRUE
))


testthat::expect_error(
  add_mpm_error_indiv(
    mat_U = mats$mat_U,
    mat_F = mmats$mat_U,
    sample_size = 10,
    split = "Yes"
  )
)

# add_mpm_error


testthat::expect_error(add_mpm_error(
  mat_U = as.vector(mats$mat_U),
  mat_F = mats$mat_F,
  sample_size = ssMat,
  split = TRUE
))

testthat::expect_error(add_mpm_error(
  mat_U = mats$mat_U,
  mat_F = as.vector(mats$mat_F),
  sample_size = ssMat,
  split = TRUE
))

testthat::expect_error(add_mpm_error(
  mat_U = mats$mat_U,
  mat_F = matrix(
    2,
    nrow = nrow(mats$mat_U) + 1,
    ncol = nrow(mats$mat_U) + 1
  ),
  sample_size = ssMat,
  split = TRUE
))

testthat::expect_error(add_mpm_error(
  mat_U = mats$mat_U,
  mat_F = matrix(
    5,
    nrow = nrow(mats$mat_U),
    ncol = nrow(mats$mat_U) + 1
  ),
  sample_size = ssMat,
  split = TRUE
))

testthat::expect_error(add_mpm_error(
  mat_U = mats$mat_U,
  mat_F = mats$mat_U,
  sample_size = 1:10,
  split = TRUE
))


testthat::expect_error(
  add_mpm_error(
    mat_U = mats$mat_U,
    mat_F = mats$mat_U,
    sample_size = matrix(10, nrow = 4, ncol = 4),
    split = TRUE
  )
)

testthat::expect_error(add_mpm_error(
  mat_U = mats$mat_U,
  mat_F = mats$mat_U,
  sample_size = list(matrix(10, nrow = 3, ncol = 3),
    matrix(10, nrow = 3, ncol = 4),
    split = TRUE
  )
))

testthat::expect_error(add_mpm_error(
  mat_U = mats$mat_U,
  mat_F = mats$mat_U,
  sample_size = list(matrix(10, nrow = 4, ncol = 4),
    matrix(10, nrow = 4, ncol = 4),
    split = TRUE
  )
))

testthat::expect_error(add_mpm_error(
  mat_U = mats$mat_U,
  mat_F = mats$mat_U,
  sample_size = list(
    mat_X_ss = matrix(10, nrow = 3, ncol = 3),
    mat_Y_ss = matrix(10, nrow = 3, ncol = 3),
    split = TRUE
  )
))

testthat::expect_error(add_mpm_error(
  mat_U = mats$mat_U,
  mat_F = mats$mat_U,
  sample_size = 10.4,
  split = TRUE
))

testthat::expect_error(add_mpm_error(
  mat_U = mats$mat_U,
  mat_F = mats$mat_U,
  sample_size = -10,
  split = TRUE
))

mat_U2 <- mats$mat_U
mat_U2[1, 1] <- -0.1

testthat::expect_error(add_mpm_error(
  mat_U = mat_U2,
  mat_F = mats$mat_U,
  sample_size = 10,
  split = TRUE
))


mat_F2 <- mats$mat_F
mat_F2[1, 1] <- -0.1

testthat::expect_error(add_mpm_error(
  mat_U = mats$mat_U,
  mat_F = mat_F2,
  sample_size = 10,
  split = TRUE
))


testthat::expect_error(add_mpm_error(
  mat_U = mats$mat_U,
  mat_F = mats$mat_U,
  sample_size = 10,
  split = "Yes"
))



testthat::expect_error(
  add_mpm_error(
    mat_U = mats$mat_U,
    mat_F = mats$mat_U,
    sample_size = 10,
    split = FALSE,
    by_type = TRUE
  )
)


testthat::expect_identical(
  add_mpm_error(
    mat_U = mats$mat_U,
    mat_F = mats$mat_U,
    sample_size = 0
  ),
  add_mpm_error_indiv(
    mat_U = mats$mat_U,
    mat_F = mats$mat_U,
    sample_size = 0
  )
)

testthat::expect_identical(
  add_mpm_error(
    mat_U = mats$mat_U,
    mat_F = mats$mat_U,
    sample_size = 0,
    split = TRUE
  ),
  add_mpm_error_indiv(
    mat_U = mats$mat_U,
    mat_F = mats$mat_U,
    sample_size = 0,
    split = TRUE
  )
)

testthat::expect_identical(
  add_mpm_error(
    mat_U = mats$mat_U,
    mat_F = mats$mat_U,
    sample_size = 0,
    split = FALSE,
    by_type = FALSE
  ),
  add_mpm_error_indiv(
    mat_U = mats$mat_U,
    mat_F = mats$mat_U,
    sample_size = 0,
    split = FALSE
  )
)



testthat::expect_identical(
  add_mpm_error(
    mat_U = mats$mat_U,
    mat_F = mats$mat_U,
    sample_size = 0,
    split = TRUE,
    by_type = TRUE
  ),
  add_mpm_error_indiv(
    mat_U = mats$mat_U,
    mat_F = mats$mat_U,
    sample_size = 0,
    split = TRUE
  )
)

testthat::expect_type(
  add_mpm_error(
    mat_U = mats$mat_U,
    mat_F = mats$mat_U,
    sample_size = 0,
    by_type = TRUE
  ),
  "list"
)
testthat::expect_type(
  add_mpm_error(
    mat_U = mats$mat_U,
    mat_F = mats$mat_U,
    sample_size = 0,
    by_type = FALSE
  ),
  "list"
)

mpm_set <- generate_mpm_set(
  n = 5,
  n_stages = 5,
  fecundity = c(
    0, 0, 4, 8,
    10
  ),
  archetype = 4,
  split = TRUE,
  by_type = TRUE,
  as_compadre = FALSE
)


testthat::expect_type(
  add_mpm_error(
    mat_U = mpm_set$U_list,
    mat_F = mpm_set$F_list,
    sample_size = 0,
    by_type = FALSE
  ),
  "list"
)

testthat::expect_type(
  add_mpm_error(
    mat_U = mpm_set$U_list,
    mat_F = mpm_set$F_list,
    sample_size = 0,
    by_type = TRUE
  ),
  "list"
)
