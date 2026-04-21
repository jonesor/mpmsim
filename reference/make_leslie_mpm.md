# Create a Leslie matrix population model

The function creates a Leslie matrix from inputs of number of stages,
fecundity (the top row of the matrix), and survival probability (the
value in the sub-diagonal).

## Usage

``` r
make_leslie_mpm(
  survival = NULL,
  fecundity = NULL,
  n_stages = NULL,
  lifetable = NULL,
  split = FALSE
)
```

## Arguments

- survival:

  a numeric value representing the survival probability of each stage
  along the lower off-diagonal of the matrix, with the final value being
  in the lower-right corner of the matrix. If only one value is
  provided, this is applied to all survival elements.

- fecundity:

  a numeric vector of length n_stages representing the reproductive
  output of each stage. If only one value is provided, this is applied
  to all fecundity elements.

- n_stages:

  a numeric value representing the number of stages in the matrix

- lifetable:

  a life table containing columns `px` (age-specific survival) and
  `fecundity` (age-specific fecundity).

- split:

  a logical argument indicating whether the output matrix should be
  split into separate A, U and F matrices (where A = U + F).

## Value

A matrix of size n_stages x n_stages representing the Leslie matrix

## Details

Note that the simulations assume a post-breeding census, thus avoiding
the often overlooked issue of unaccounted survival to reproduction
highlighted by Kendall et al. (2019). Furthermore, the simulations
assume no covariance among matrix elements (e.g. between reproduction
and survival), and therefore do not allow the users to capture trade
offs directly. This capability is roadmapped for a future package
release.

## References

Caswell, H. (2001). Matrix Population Models: Construction, Analysis,
and Interpretation. Sinauer.

Leslie, P. H. (1945). On the use of matrices in certain population
mathematics. Biometrika, 33 (3), 183–212.

Leslie, P. H. (1948). Some Further Notes on the Use of Matrices in
Population Mathematics. Biometrika, 35(3-4), 213–245.

Kendall, B. E., Fujiwara, M., Diaz-Lopez, J., Schneider, S., Voigt, J.,
& Wiesner, S. (2019). Persistent problems in the construction of matrix
population models. Ecological Modelling, 406, 33–43.

## See also

- [`model_survival()`](https://jonesor.github.io/mpmsim/reference/model_survival.md)
  to model age-specific survival using mortality models.

- [`model_fecundity()`](https://jonesor.github.io/mpmsim/reference/model_fecundity.md)
  to model age-specific reproductive output using various functions.

Other Leslie matrices:
[`rand_leslie_set()`](https://jonesor.github.io/mpmsim/reference/rand_leslie_set.md),
[`reorganise_matrices()`](https://jonesor.github.io/mpmsim/reference/reorganise_matrices.md)

## Author

Owen Jones <jones@biology.sdu.dk>

## Examples

``` r
make_leslie_mpm(
  survival = 0.5, fecundity = c(0.1, 0.2, 0.3),
  n_stages = 3, split = FALSE
)
#>      [,1] [,2] [,3]
#> [1,]  0.1  0.2  0.3
#> [2,]  0.5  0.0  0.0
#> [3,]  0.0  0.5  0.5
make_leslie_mpm(
  survival = c(0.5, 0.6, 0.7), fecundity = c(0.1, 0.2, 0.3),
  n_stages = 3
)
#>      [,1] [,2] [,3]
#> [1,]  0.1  0.2  0.3
#> [2,]  0.5  0.0  0.0
#> [3,]  0.0  0.6  0.7
make_leslie_mpm(
  survival = seq(0.1, 0.7, length.out = 4), fecundity = 0.1,
  n_stages = 4
)
#>      [,1] [,2] [,3] [,4]
#> [1,]  0.1  0.1  0.1  0.1
#> [2,]  0.1  0.0  0.0  0.0
#> [3,]  0.0  0.3  0.0  0.0
#> [4,]  0.0  0.0  0.5  0.7
make_leslie_mpm(
  survival = c(0.8, 0.3, 0.2, 0.1, 0.05), fecundity = 0.2,
  n_stages = 5
)
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,]  0.2  0.2  0.2  0.2 0.20
#> [2,]  0.8  0.0  0.0  0.0 0.00
#> [3,]  0.0  0.3  0.0  0.0 0.00
#> [4,]  0.0  0.0  0.2  0.0 0.00
#> [5,]  0.0  0.0  0.0  0.1 0.05
```
