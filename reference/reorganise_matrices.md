# Reorganise Matrix Population Models

This function reorganises a list of matrix population models, which are
split into `mat_A`, `mat_U`, `mat_F`, and optionally `mat_C`
sub-matrices. It prepares the matrices for easy conversion into a
`compadreDB` object.

## Usage

``` r
reorganise_matrices(matrix_list)
```

## Arguments

- matrix_list:

  A list of lists, where each sub-list contains the matrices `mat_A`,
  `mat_U`, `mat_F`, and optionally `mat_C`.

## Value

A list containing four elements: `mat_A`, `mat_U`, `mat_F`, and `mat_C`.
Each element is a list of matrices corresponding to the respective
matrix type from the input. If `mat_C` does not exist in a sub-list, it
is replaced with an `NA` matrix of the same dimensions as `mat_U`.

## Details

This function processes a list of matrix population models, extracting
and grouping the sub-matrices (`mat_A`, `mat_U`, `mat_F`, and optionally
`mat_C`) into separate lists. If a `mat_C` matrix is not present in a
model, an `NA` matrix of the same size as `mat_U` is used as a
placeholder.

## See also

Other Leslie matrices:
[`make_leslie_mpm()`](https://jonesor.github.io/mpmsim/reference/make_leslie_mpm.md),
[`rand_leslie_set()`](https://jonesor.github.io/mpmsim/reference/rand_leslie_set.md)

## Author

Owen Jones <jones@biology.sdu.dk>

## Examples

``` r
# Example usage
matrix_list <- list(
  list(
    mat_A = matrix(1, 2, 2),
    mat_U = matrix(2, 2, 2),
    mat_F = matrix(3, 2, 2),
    mat_C = matrix(4, 2, 2)
  ),
  list(
    mat_A = matrix(5, 2, 2),
    mat_U = matrix(6, 2, 2),
    mat_F = matrix(7, 2, 2)
  )
)
reorganised_matrices <- reorganise_matrices(matrix_list)
reorganised_matrices$mat_A
#> [[1]]
#>      [,1] [,2]
#> [1,]    1    1
#> [2,]    1    1
#> 
#> [[2]]
#>      [,1] [,2]
#> [1,]    5    5
#> [2,]    5    5
#> 
```
