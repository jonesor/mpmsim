#n_stages must be greater than 0
testthat::expect_error(
  randomMPM(n_stages = -1, Fec = 20, archetype = 1, split = FALSE)
  )

#n_stages must be integer
testthat::expect_error(
  randomMPM(n_stages = 3.5, Fec = 20, archetype = 1, split = FALSE)
)

#Fec must be numeric
testthat::expect_error(
  randomMPM(n_stages = 4, Fec = "text", archetype = 1, split = FALSE)
)

#Fec must be of length 1 or n_stages
testthat::expect_error(
  randomMPM(n_stages = 4, Fec = c(12,5), archetype = 1, split = FALSE)
)

#Split must be logical
testthat::expect_error(
  randomMPM(n_stages = 4, Fec = 5, archetype = 1, split = "text")
)

# Archetype is an integer between 1 and 4
testthat::expect_error(
  randomMPM(n_stages = 4, Fec = 5, archetype = 0, split = FALSE)
)

testthat::expect_error(
  randomMPM(n_stages = 4, Fec = 5, archetype = 5, split = FALSE)
)

testthat::expect_error(
  randomMPM(n_stages = 4, Fec = 5, archetype = 1.5, split = FALSE)
)

# Check that output is a matrix
testthat::expect_true(
  is.matrix(randomMPM(n_stages = 4, Fec = 5, archetype = 1, split = FALSE))
  )


