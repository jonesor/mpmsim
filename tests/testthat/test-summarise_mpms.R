# Create test matrices
set.seed(123)
mats <- suppressWarnings(rand_lefko_set(
  n = 10, n_stages = 5, fecundity = c(0, 0, 4, 8, 10),
  archetype = 4, output = "Type1"
))

# Define the test cases
test_that("summarise_mpms function works correctly", {
  # Test that the function returns correct lambda values
  expect_output(
    {
      summarise_mpms(mats)
    },
    "Summary of lambda values:"
  )

  # Test that the function returns correct max F values
  expect_output(
    {
      summarise_mpms(mats)
    },
    "Summary of maximum F values:"
  )

  # Test that the function returns correct max U values
  expect_output(
    {
      summarise_mpms(mats)
    },
    "Summary of maximum U values:"
  )

  # Test that the function returns correct min non-zero U values
  expect_output(
    {
      summarise_mpms(mats)
    },
    "Summary of minimum non-zero U values:"
  )
})

mats <- rand_lefko_set(
  n = 10, n_stages = 5, fecundity = c(0, 0, 4, 8, 10),
  archetype = 4, output = "Type3"
)

test_that("error produced if input is not CompadreDB", {
  # Test that the function returns correct lambda values
  expect_error({
    summarise_mpms(mats)
  })
})

# Make some NA MPMs
set.seed(123)
mats <- rand_lefko_set(
  n = 10, n_stages = 5, fecundity = c(0, 0, 4, 8, 10),
  archetype = 4, output = "Type5"
)

mats_A_only <- suppressWarnings(cdb_build_cdb(mat_a = mats))
expect_output(
  {
    summarise_mpms(mats_A_only)
  },
  "Summary of lambda values:"
)
