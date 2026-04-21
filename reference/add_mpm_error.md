# Add sampling error to matrix population models (MPMs) based on expected values of transition rates and sample sizes

Produces a list of matrix population models based on expected values in
the transition matrix and sample size. The expected values are provided
in lists of two submatrices: `mat_U` for the growth/development and
survival transitions and `mat_F` for the reproductive transitions. The
output `mat_U` values are simulated based on expected probabilities,
assuming a binomial process with a sample size defined by `sample_size`.
The output `mat_F` values are simulated using a Poisson process with a
sample size defined by `sample_size`.Thus users can expect that large
sample sizes will result in simulated matrices that match closely with
the expectations, while simulated matrices with small sample sizes will
be more variable.

## Usage

``` r
add_mpm_error(mat_U, mat_F, sample_size, split = TRUE, by_type = TRUE)
```

## Arguments

- mat_U:

  A list of U submatrices, or a single U submatrix.

- mat_F:

  A list of F submatrices, or a single F submatrix.

- sample_size:

  either (1) a single matrix of sample sizes for each element of every
  MPM, (2) a list of two named matrices ("`mat_F_ss`", "`mat_U_ss`")
  containing sample sizes for the survival and reproductive output
  submatrices of every MPM or (3) a single value applied to the every
  element of every matrix.

- split:

  logical, whether to split the output into survival and reproductive
  output matrices or not. Defaults to `TRUE`.

- by_type:

  A logical indicating whether the matrices should be returned in a list
  by type (A, U, F, C). If split is `FALSE`, then `by_type` must also be
  `FALSE`. Defaults to `TRUE`.

## Value

list of matrices of survival and reproductive output if `split = TRUE`,
otherwise a single matrix of the sum of survival and reproductive
output.

## Details

if any `sample_size` input is 0, it is assumed that the estimate for the
element(s) concerned is known without error.

## See also

Other errors:
[`calculate_errors()`](https://jonesor.github.io/mpmsim/reference/calculate_errors.md),
[`compute_ci()`](https://jonesor.github.io/mpmsim/reference/compute_ci.md),
[`compute_ci_U()`](https://jonesor.github.io/mpmsim/reference/compute_ci_U.md)

Other errors:
[`calculate_errors()`](https://jonesor.github.io/mpmsim/reference/calculate_errors.md),
[`compute_ci()`](https://jonesor.github.io/mpmsim/reference/compute_ci.md),
[`compute_ci_U()`](https://jonesor.github.io/mpmsim/reference/compute_ci_U.md)

## Author

Owen Jones <jones@biology.sdu.dk>

## Examples

``` r
set.seed(42) # set seed for repeatability

# First generate a set of MPMs
mpm_set <- rand_lefko_set(n = 5, n_stages = 5, fecundity = c(
  0, 0, 4, 8, 10
), archetype = 4, output = "Type4")

# Now apply sampling error to this set
add_mpm_error(
  mat_U = mpm_set$U_list, mat_F = mpm_set$F_list, sample_size =
    50
)
#> $A_list
#> $A_list[[1]]
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,] 0.04 0.00 4.16 7.36 9.92
#> [2,] 0.40 0.38 0.00 0.00 0.00
#> [3,] 0.00 0.00 0.20 0.00 0.00
#> [4,] 0.00 0.00 0.44 0.42 0.00
#> [5,] 0.00 0.00 0.00 0.32 0.94
#> 
#> $A_list[[2]]
#>      [,1] [,2] [,3] [,4]  [,5]
#> [1,] 0.02 0.00 3.88 8.14 11.38
#> [2,] 0.32 0.38 0.00 0.00  0.00
#> [3,] 0.00 0.02 0.64 0.00  0.00
#> [4,] 0.00 0.00 0.04 0.38  0.00
#> [5,] 0.00 0.00 0.00 0.32  0.76
#> 
#> $A_list[[3]]
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,]  0.5 0.00 4.34 8.06 9.58
#> [2,]  0.0 0.56 0.00 0.00 0.00
#> [3,]  0.0 0.20 0.38 0.00 0.00
#> [4,]  0.0 0.00 0.38 0.20 0.00
#> [5,]  0.0 0.00 0.00 0.68 1.00
#> 
#> $A_list[[4]]
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,] 0.26 0.00 3.66 8.24 9.34
#> [2,] 0.00 0.00 0.00 0.00 0.00
#> [3,] 0.00 0.38 0.06 0.00 0.00
#> [4,] 0.00 0.00 0.36 0.14 0.00
#> [5,] 0.00 0.00 0.00 0.58 0.88
#> 
#> $A_list[[5]]
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,] 0.20 0.00 4.24 7.44 9.80
#> [2,] 0.26 0.46 0.00 0.00 0.00
#> [3,] 0.00 0.08 0.70 0.00 0.00
#> [4,] 0.00 0.00 0.04 0.10 0.00
#> [5,] 0.00 0.00 0.00 0.58 0.78
#> 
#> 
#> $U_list
#> $U_list[[1]]
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,] 0.04 0.00 0.00 0.00 0.00
#> [2,] 0.40 0.38 0.00 0.00 0.00
#> [3,] 0.00 0.00 0.20 0.00 0.00
#> [4,] 0.00 0.00 0.44 0.42 0.00
#> [5,] 0.00 0.00 0.00 0.32 0.94
#> 
#> $U_list[[2]]
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,] 0.02 0.00 0.00 0.00 0.00
#> [2,] 0.32 0.38 0.00 0.00 0.00
#> [3,] 0.00 0.02 0.64 0.00 0.00
#> [4,] 0.00 0.00 0.04 0.38 0.00
#> [5,] 0.00 0.00 0.00 0.32 0.76
#> 
#> $U_list[[3]]
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,]  0.5 0.00 0.00 0.00    0
#> [2,]  0.0 0.56 0.00 0.00    0
#> [3,]  0.0 0.20 0.38 0.00    0
#> [4,]  0.0 0.00 0.38 0.20    0
#> [5,]  0.0 0.00 0.00 0.68    1
#> 
#> $U_list[[4]]
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,] 0.26 0.00 0.00 0.00 0.00
#> [2,] 0.00 0.00 0.00 0.00 0.00
#> [3,] 0.00 0.38 0.06 0.00 0.00
#> [4,] 0.00 0.00 0.36 0.14 0.00
#> [5,] 0.00 0.00 0.00 0.58 0.88
#> 
#> $U_list[[5]]
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,] 0.20 0.00 0.00 0.00 0.00
#> [2,] 0.26 0.46 0.00 0.00 0.00
#> [3,] 0.00 0.08 0.70 0.00 0.00
#> [4,] 0.00 0.00 0.04 0.10 0.00
#> [5,] 0.00 0.00 0.00 0.58 0.78
#> 
#> 
#> $F_list
#> $F_list[[1]]
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,]    0    0 4.16 7.36 9.92
#> [2,]    0    0 0.00 0.00 0.00
#> [3,]    0    0 0.00 0.00 0.00
#> [4,]    0    0 0.00 0.00 0.00
#> [5,]    0    0 0.00 0.00 0.00
#> 
#> $F_list[[2]]
#>      [,1] [,2] [,3] [,4]  [,5]
#> [1,]    0    0 3.88 8.14 11.38
#> [2,]    0    0 0.00 0.00  0.00
#> [3,]    0    0 0.00 0.00  0.00
#> [4,]    0    0 0.00 0.00  0.00
#> [5,]    0    0 0.00 0.00  0.00
#> 
#> $F_list[[3]]
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,]    0    0 4.34 8.06 9.58
#> [2,]    0    0 0.00 0.00 0.00
#> [3,]    0    0 0.00 0.00 0.00
#> [4,]    0    0 0.00 0.00 0.00
#> [5,]    0    0 0.00 0.00 0.00
#> 
#> $F_list[[4]]
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,]    0    0 3.66 8.24 9.34
#> [2,]    0    0 0.00 0.00 0.00
#> [3,]    0    0 0.00 0.00 0.00
#> [4,]    0    0 0.00 0.00 0.00
#> [5,]    0    0 0.00 0.00 0.00
#> 
#> $F_list[[5]]
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,]    0    0 4.24 7.44  9.8
#> [2,]    0    0 0.00 0.00  0.0
#> [3,]    0    0 0.00 0.00  0.0
#> [4,]    0    0 0.00 0.00  0.0
#> [5,]    0    0 0.00 0.00  0.0
#> 
#> 

# Also works with a single matrix.
mats <- make_leslie_mpm(
  survival = c(0.1, 0.2, 0.5),
  fecundity = c(0, 1.2, 2.4),
  n_stages = 3, split = TRUE
)

# Sample size is a single value
add_mpm_error(mat_U = mats$mat_U, mat_F = mats$mat_F, sample_size = 20)
#> $mat_A
#>      [,1] [,2] [,3]
#> [1,]  0.0  1.0 2.50
#> [2,]  0.1  0.0 0.00
#> [3,]  0.0  0.2 0.45
#> 
#> $mat_U
#>      [,1] [,2] [,3]
#> [1,]  0.0  0.0 0.00
#> [2,]  0.1  0.0 0.00
#> [3,]  0.0  0.2 0.45
#> 
#> $mat_F
#>      [,1] [,2] [,3]
#> [1,]    0    1  2.5
#> [2,]    0    0  0.0
#> [3,]    0    0  0.0
#> 

# Sample size is a list of two matrices
# here with a sample size of 20 for fecundity and 10 for growth/survival.
mpm_set <- rand_lefko_set(
  n = 5, n_stages = 3, fecundity = c(0, 2, 4),
  archetype = 4, output = "Type4"
)

ssMats <- list(
  "mat_F_ss" = matrix(20, nrow = 3, ncol = 3),
  "mat_U_ss" = matrix(10, nrow = 3, ncol = 3)
)

# Add sampling error to the matrix models
output <- add_mpm_error(
  mat_U = mpm_set$U_list, mat_F = mpm_set$F_list,
  sample_size = ssMats
)

# Examine the outputs
names(output)
#> [1] "A_list" "U_list" "F_list"
output
#> $A_list
#> $A_list[[1]]
#>      [,1] [,2] [,3]
#> [1,]  0.3  1.5  4.1
#> [2,]  0.1  0.3  0.0
#> [3,]  0.0  0.5  1.0
#> 
#> $A_list[[2]]
#>      [,1] [,2] [,3]
#> [1,]  0.5  2.2 4.25
#> [2,]  0.2  0.5 0.00
#> [3,]  0.0  0.3 0.70
#> 
#> $A_list[[3]]
#>      [,1] [,2] [,3]
#> [1,]  0.0  1.9 4.15
#> [2,]  0.9  0.7 0.00
#> [3,]  0.0  0.0 1.00
#> 
#> $A_list[[4]]
#>      [,1] [,2] [,3]
#> [1,]  0.5 1.45  3.7
#> [2,]  0.2 0.40  0.0
#> [3,]  0.0 0.40  1.0
#> 
#> $A_list[[5]]
#>      [,1] [,2] [,3]
#> [1,]  0.7  1.9  3.8
#> [2,]  0.1  0.6  0.0
#> [3,]  0.0  0.4  1.0
#> 
#> 
#> $U_list
#> $U_list[[1]]
#>      [,1] [,2] [,3]
#> [1,]  0.3  0.0    0
#> [2,]  0.1  0.3    0
#> [3,]  0.0  0.5    1
#> 
#> $U_list[[2]]
#>      [,1] [,2] [,3]
#> [1,]  0.5  0.0  0.0
#> [2,]  0.2  0.5  0.0
#> [3,]  0.0  0.3  0.7
#> 
#> $U_list[[3]]
#>      [,1] [,2] [,3]
#> [1,]  0.0  0.0    0
#> [2,]  0.9  0.7    0
#> [3,]  0.0  0.0    1
#> 
#> $U_list[[4]]
#>      [,1] [,2] [,3]
#> [1,]  0.5  0.0    0
#> [2,]  0.2  0.4    0
#> [3,]  0.0  0.4    1
#> 
#> $U_list[[5]]
#>      [,1] [,2] [,3]
#> [1,]  0.7  0.0    0
#> [2,]  0.1  0.6    0
#> [3,]  0.0  0.4    1
#> 
#> 
#> $F_list
#> $F_list[[1]]
#>      [,1] [,2] [,3]
#> [1,]    0  1.5  4.1
#> [2,]    0  0.0  0.0
#> [3,]    0  0.0  0.0
#> 
#> $F_list[[2]]
#>      [,1] [,2] [,3]
#> [1,]    0  2.2 4.25
#> [2,]    0  0.0 0.00
#> [3,]    0  0.0 0.00
#> 
#> $F_list[[3]]
#>      [,1] [,2] [,3]
#> [1,]    0  1.9 4.15
#> [2,]    0  0.0 0.00
#> [3,]    0  0.0 0.00
#> 
#> $F_list[[4]]
#>      [,1] [,2] [,3]
#> [1,]    0 1.45  3.7
#> [2,]    0 0.00  0.0
#> [3,]    0 0.00  0.0
#> 
#> $F_list[[5]]
#>      [,1] [,2] [,3]
#> [1,]    0  1.9  3.8
#> [2,]    0  0.0  0.0
#> [3,]    0  0.0  0.0
#> 
#> 
```
