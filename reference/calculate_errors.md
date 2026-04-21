# Calculate error (standard error or 95%CI) in elements of a matrix population model.

Given two submatrices of a matrix population model (`mat_U` and `mat_F`,
the growth/survival matrix and the fecundity matrix respectively) and a
sample size, or matrix/matrices of sample sizes, this function
calculates the standard error or 95% confidence interval (95%CI) for
each element of the matrix. These calculations assume that `mat_U` is
the result of binomial processes (i.e., the survival (0/1) of a sample
of n individuals), while `mat_F` is the result of Poisson processes
(i.e., counts of offspring from n individuals), where n is the sample
size.

## Usage

``` r
calculate_errors(mat_U, mat_F, sample_size, type = "sem", calculate_A = TRUE)
```

## Arguments

- mat_U:

  matrix of mean survival probabilities

- mat_F:

  matrix of mean fecundity values

- sample_size:

  either (1) a single matrix of sample sizes for each element of the
  MPM, (2) a list of two named matrices ("`mat_F_ss`", "`mat_U_ss`")
  containing sample sizes for the survival and fecundity submatrices of
  the MPM or (3) a single value applied to the whole matrix

- type:

  A character string indicating the type of error to calculate. Must be
  one of "`sem`" (standard error), or "`CI95`" (95% confidence
  interval).

- calculate_A:

  A logical argument indicating whether the returned error information
  should include the A matrix and its error. Defaults to `TRUE`.

## Value

A list containing the original matrices and the error estimates (or
upper and lower confidence intervals) for the U, F and (optionally) A
matrices.

## Details

The output is a list containing the original matrices and matrices
showing error estimates or confidence intervals.

## See also

[`add_mpm_error()`](https://jonesor.github.io/mpmsim/reference/add_mpm_error.md)
which simulates matrices with known values and sample sizes.

Other errors:
[`add_mpm_error()`](https://jonesor.github.io/mpmsim/reference/add_mpm_error.md),
[`compute_ci()`](https://jonesor.github.io/mpmsim/reference/compute_ci.md),
[`compute_ci_U()`](https://jonesor.github.io/mpmsim/reference/compute_ci_U.md)

## Author

Owen Jones <jones@biology.sdu.dk>

## Examples

``` r
# Set up two submatrices
matU <- matrix(c(
  0.1, 0,
  0.2, 0.4
), byrow = TRUE, nrow = 2)
matF <- matrix(c(
  0, 4,
  0., 0.
), byrow = TRUE, nrow = 2)

# errors as 95% CI, with a sample size of 20 for all elements
calculate_errors(mat_U = matU, mat_F = matF, sample_size = 20, type = "CI95")
#> $mat_F
#>      [,1] [,2]
#> [1,]    0    4
#> [2,]    0    0
#> 
#> $mat_F_lowerCI
#>      [,1]     [,2]
#> [1,]    0 3.123461
#> [2,]    0 0.000000
#> 
#> $mat_F_upperCI
#>      [,1]     [,2]
#> [1,]    0 4.876539
#> [2,]    0 0.000000
#> 
#> $mat_U
#>      [,1] [,2]
#> [1,]  0.1  0.0
#> [2,]  0.2  0.4
#> 
#> $mat_U_lowerCI
#>            [,1]      [,2]
#> [1,] 0.00000000 0.0000000
#> [2,] 0.02469227 0.1852928
#> 
#> $mat_U_upperCI
#>           [,1]      [,2]
#> [1,] 0.2314808 0.0000000
#> [2,] 0.3753077 0.6147072
#> 
#> $mat_A
#>      [,1] [,2]
#> [1,]  0.1  4.0
#> [2,]  0.2  0.4
#> 
#> $mat_A_lowerCI
#>            [,1]      [,2]
#> [1,] 0.00000000 3.1234614
#> [2,] 0.02469227 0.1852928
#> 
#> $mat_A_upperCI
#>           [,1]      [,2]
#> [1,] 0.2314808 4.8765386
#> [2,] 0.3753077 0.6147072
#> 

# errors as sem, with a sample size of 20 for all elements
calculate_errors(mat_U = matU, mat_F = matF, sample_size = 20, type = "sem")
#> $mat_U
#>      [,1] [,2]
#> [1,]  0.1  0.0
#> [2,]  0.2  0.4
#> 
#> $mat_U_error
#>            [,1]      [,2]
#> [1,] 0.06708204 0.0000000
#> [2,] 0.08944272 0.1095445
#> 
#> $mat_F
#>      [,1] [,2]
#> [1,]    0    4
#> [2,]    0    0
#> 
#> $mat_F_error
#>      [,1]      [,2]
#> [1,]    0 0.4472136
#> [2,]    0 0.0000000
#> 
#> $mat_A
#>      [,1] [,2]
#> [1,]  0.1  4.0
#> [2,]  0.2  0.4
#> 
#> $mat_A_error
#>            [,1]      [,2]
#> [1,] 0.06708204 0.4472136
#> [2,] 0.08944272 0.1095445
#> 

# Sample size is a single matrix applied to both F and U matrices
ssMat <- matrix(10, nrow = 2, ncol = 2)

calculate_errors(
  mat_U = matU, mat_F = matF, sample_size = ssMat, type =
    "sem"
)
#> $mat_U
#>      [,1] [,2]
#> [1,]  0.1  0.0
#> [2,]  0.2  0.4
#> 
#> $mat_U_error
#>            [,1]      [,2]
#> [1,] 0.09486833 0.0000000
#> [2,] 0.12649111 0.1549193
#> 
#> $mat_F
#>      [,1] [,2]
#> [1,]    0    4
#> [2,]    0    0
#> 
#> $mat_F_error
#>      [,1]      [,2]
#> [1,]    0 0.6324555
#> [2,]    0 0.0000000
#> 
#> $mat_A
#>      [,1] [,2]
#> [1,]  0.1  4.0
#> [2,]  0.2  0.4
#> 
#> $mat_A_error
#>            [,1]      [,2]
#> [1,] 0.09486833 0.6324555
#> [2,] 0.12649111 0.1549193
#> 

# Sample size is a list of two matrices, one for F and one for U.
ssMats <- list(
  "mat_F_ss" = matrix(10, nrow = 2, ncol = 2),
  "mat_U_ss" = matrix(10, nrow = 2, ncol = 2)
)
calculate_errors(
  mat_U = matU, mat_F = matF, sample_size = ssMats, type =
    "sem"
)
#> $mat_U
#>      [,1] [,2]
#> [1,]  0.1  0.0
#> [2,]  0.2  0.4
#> 
#> $mat_U_error
#>            [,1]      [,2]
#> [1,] 0.09486833 0.0000000
#> [2,] 0.12649111 0.1549193
#> 
#> $mat_F
#>      [,1] [,2]
#> [1,]    0    4
#> [2,]    0    0
#> 
#> $mat_F_error
#>      [,1]      [,2]
#> [1,]    0 0.6324555
#> [2,]    0 0.0000000
#> 
#> $mat_A
#>      [,1] [,2]
#> [1,]  0.1  4.0
#> [2,]  0.2  0.4
#> 
#> $mat_A_error
#>            [,1]      [,2]
#> [1,] 0.09486833 0.6324555
#> [2,] 0.12649111 0.1549193
#> 
```
