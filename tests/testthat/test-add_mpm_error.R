mats <- make_leslie_mpm(
  survival = c(0.1, 0.2, 0.5),
  fecundity = c(0, 1.2, 2.4),
  n_stages = 3,
  split = TRUE
)
ssMat <- matrix(10, nrow = 3, ncol = 3)

test_that("Checkadd_mpm_error functions correctly", {
  expect_silent(
    add_mpm_error(
      mat_U = mats$mat_U,
      mat_F = mats$mat_F,
      sample_size = ssMat,
      split = TRUE
    )
  )
  expect_silent(
    add_mpm_error(
      mat_U = mats$mat_U,
      mat_F = mats$mat_F,
      sample_size = ssMat,
      split = FALSE,
      by_type = FALSE
    )
  )
})



mats <- make_leslie_mpm(
  survival = c(0.1, 0.2, 0.5),
  fecundity = c(0, 1.2, 2.4),
  n_stages = 3,
  split = TRUE
)
ssMat <- matrix(10, nrow = 3, ncol = 3)

test_that("Check that error is produced when mat_U is provided incorrectly", {
  expect_error(
    add_mpm_error(
      mat_U = as.vector(mats$mat_U),
      mat_F = mats$mat_F,
      sample_size = ssMat,
      split = TRUE
    )
  )


  expect_error(
    add_mpm_error(
      mat_U = mats$mat_U,
      mat_F = as.vector(mats$mat_F),
      sample_size = ssMat,
      split = TRUE
    )
  )
})


test_that("Check that error is produced when add_mpm_error_indiv has incorrect
          matrix input", {
  expect_error(
    add_mpm_error_indiv(
      mat_U = as.vector(mats$mat_U),
      mat_F = mats$mat_F,
      sample_size = ssMat,
      split = TRUE
    )
  )

  expect_error(
    add_mpm_error_indiv(
      mat_U = mats$mat_U,
      mat_F = as.vector(mats$mat_F),
      sample_size = ssMat,
      split = TRUE
    )
  )

  expect_error(
    add_mpm_error_indiv(
      mat_U = mats$mat_U[1:2, 1:3],
      mat_F = mats$mat_F,
      sample_size = ssMat,
      split = TRUE
    )
  )
})

test_that("Check that error is produced when matrix dimensions are
          inconsistent", {
  expect_error(
    add_mpm_error(
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
})


test_that("Check that error is produced when mat_F is not square", {
  expect_error(
    add_mpm_error(
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
})


test_that("Check that error is produced when sample_size is provided
          incorrectly", {
  expect_error(
    add_mpm_error(
      mat_U = mats$mat_U,
      mat_F = mats$mat_U,
      sample_size = 1:10,
      split = TRUE
    )
  )
})


test_that("Check that error is produced when sample_size matrix has wrong
          dimensions", {
  expect_error(
    add_mpm_error(
      mat_U = mats$mat_U,
      mat_F = mats$mat_U,
      sample_size = matrix(10, nrow = 4, ncol = 4),
      split = TRUE
    )
  )

  expect_error(
    add_mpm_error(
      mat_U = mats$mat_U,
      mat_F = mats$mat_U,
      sample_size = list(matrix(10, nrow = 3, ncol = 3),
        matrix(10, nrow = 3, ncol = 4),
        split = TRUE
      )
    )
  )

  expect_error(
    add_mpm_error(
      mat_U = mats$mat_U,
      mat_F = mats$mat_U,
      sample_size = list(matrix(10, nrow = 4, ncol = 4),
        matrix(10, nrow = 4, ncol = 4),
        split = TRUE
      )
    )
  )
})


test_that("Check that error is produced when sample_size matrices have wrong
          names", {
  expect_error(
    add_mpm_error(
      mat_U = mats$mat_U,
      mat_F = mats$mat_U,
      sample_size = list(
        mat_X_ss = matrix(10, nrow = 3, ncol = 3),
        mat_Y_ss = matrix(10, nrow = 3, ncol = 3),
        split = TRUE
      )
    )
  )
})


test_that("Check that error is produced when sample_size is not an integer", {
  expect_error(
    add_mpm_error(
      mat_U = mats$mat_U,
      mat_F = mats$mat_U,
      sample_size = 10.4,
      split = TRUE
    )
  )
})


test_that("Check that error is produced when sample_size is negative", {
  expect_error(
    add_mpm_error(
      mat_U = mats$mat_U,
      mat_F = mats$mat_U,
      sample_size = -10,
      split = TRUE
    )
  )
})


mat_U2 <- mats$mat_U
mat_U2[1, 1] <- -0.1

test_that("Check that error is produced when mat_U has negative elements", {
  expect_error(
    add_mpm_error(
      mat_U = mat_U2,
      mat_F = mats$mat_U,
      sample_size = 10,
      split = TRUE
    )
  )
})



mat_F2 <- mats$mat_F
mat_F2[1, 1] <- -0.1

test_that("Check that error is produced when mat_F has negative elements", {
  expect_error(
    add_mpm_error(
      mat_U = mats$mat_U,
      mat_F = mat_F2,
      sample_size = 10,
      split = TRUE
    )
  )
})


test_that("Check that error is produced when split is not a logical
          argument", {
  expect_error(
    add_mpm_error(
      mat_U = mats$mat_U,
      mat_F = mats$mat_U,
      sample_size = 10,
      split = "Yes"
    )
  )
})


test_that("Check that error is produced when split and by_type are
          not aligned", {
  expect_error(
    add_mpm_error(
      mat_U = mats$mat_U,
      mat_F = mats$mat_U,
      sample_size = 10,
      split = FALSE,
      by_type = TRUE
    )
  )
})


test_that("Check that the two functions produce the same results correctly", {
  expect_identical(
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

  expect_identical(
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


  expect_identical(
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


  expect_identical(
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
})


test_that("Check that add_mpm_error produces a list", {
  expect_type(
    add_mpm_error(
      mat_U = mats$mat_U,
      mat_F = mats$mat_U,
      sample_size = 0,
      by_type = TRUE
    ),
    "list"
  )


  expect_type(
    add_mpm_error(
      mat_U = mats$mat_U,
      mat_F = mats$mat_U,
      sample_size = 0,
      by_type = FALSE
    ),
    "list"
  )
})


mpm_set <- rand_lefko_set(
  n = 5,
  n_stages = 5,
  fecundity = c(
    0, 0, 4, 8,
    10
  ),
  archetype = 4,
  output = "Type4"
)


test_that("Check that add_mpm_error produces a list", {
  expect_type(
    add_mpm_error(
      mat_U = mpm_set$U_list,
      mat_F = mpm_set$F_list,
      sample_size = 0,
      by_type = FALSE
    ),
    "list"
  )


  expect_type(
    add_mpm_error(
      mat_U = mpm_set$U_list,
      mat_F = mpm_set$F_list,
      sample_size = 0,
      by_type = TRUE
    ),
    "list"
  )
})
