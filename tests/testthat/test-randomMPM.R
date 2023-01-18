#nStage must be greater than 0
testthat::expect_error(
  randomMPM(nStage = -1, Fec = 20, archetype = 1, split = FALSE)
  )

#nStage must be integer
testthat::expect_error(
  randomMPM(nStage = 3.5, Fec = 20, archetype = 1, split = FALSE)
)

#Fec must be numeric
testthat::expect_error(
  randomMPM(nStage = 4, Fec = "text", archetype = 1, split = FALSE)
)

#Fec must be of length 1 or nStage
testthat::expect_error(
  randomMPM(nStage = 4, Fec = c(12,5), archetype = 1, split = FALSE)
)

#Split must be logical
testthat::expect_error(
  randomMPM(nStage = 4, Fec = 5, archetype = 1, split = "text")
)

# Archetype is an integer between 1 and 4
testthat::expect_error(
  randomMPM(nStage = 4, Fec = 5, archetype = 0, split = FALSE)
)

testthat::expect_error(
  randomMPM(nStage = 4, Fec = 5, archetype = 5, split = FALSE)
)

testthat::expect_error(
  randomMPM(nStage = 4, Fec = 5, archetype = 1.5, split = FALSE)
)

# Check that output is a matrix
testthat::expect_true(
  is.matrix(randomMPM(nStage = 4, Fec = 5, archetype = 1, split = FALSE))
  )


