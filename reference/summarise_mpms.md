# Summarise Matrix Population Models

Calculates and summarises various metrics from matrix population models
(MPMs) including dimension (= age in Leslie matrices), lambda values,
maximum fecundity values, maximum growth/survival transition
probabilities, and minimum non-zero growth/survival transition
probabilities

## Usage

``` r
summarise_mpms(x)
```

## Arguments

- x:

  A `compadreDB` object containing matrix population models, typically
  in a format compatible with `matA`, `matU`, and `matF` functions.

## Value

This function prints summaries of the following metrics:

- **lambda values:** The lambda values (dominant eigenvalues) of the A
  matrices.

- **max F values:** The maximum values from the F matrices.

- **max U values:** The maximum values from the U matrices.

- **minimum non-zero U values:** The minimum non-zero values from the U
  matrices.

## See also

Other utility:
[`plot_matrix()`](https://jonesor.github.io/mpmsim/reference/plot_matrix.md)

## Examples

``` r
mats <- rand_lefko_set(
  n = 10, n_stages = 5, fecundity = c(0, 0, 4, 8, 10),
  archetype = 4, output = "Type1"
)

summarise_mpms(mats)
#> Summary of matrix dimension:
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>       5       5       5       5       5       5 
#> Summary of lambda values:
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>  0.7308  1.0153  1.2574  1.1995  1.4075  1.4787 
#> 
#> Summary of maximum F values:
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>      10      10      10      10      10      10 
#> 
#> Summary of maximum U values:
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>  0.7040  0.9346  0.9833  0.9330  0.9860  0.9882 
#> 
#> Summary of minimum non-zero U values:
#>     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
#> 0.007748 0.014295 0.040216 0.049619 0.068094 0.134043 
```
