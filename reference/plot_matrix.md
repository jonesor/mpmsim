# Plot a matrix as a heatmap

Visualise a matrix, such as a matrix population model (MPM), as a
heatmap.

## Usage

``` r
plot_matrix(mat, zero_na = FALSE, legend = FALSE, na_colour = NA, ...)
```

## Arguments

- mat:

  A matrix, such as the A matrix of a matrix population model

- zero_na:

  Logical indicating whether zero values should be treated as NA

- legend:

  Logical indicating whether to include a legend

- na_colour:

  Colour for NA values

- ...:

  Additional arguments to be passed to ggplot

## Value

A ggplot object

## See also

Other utility:
[`summarise_mpms()`](https://jonesor.github.io/mpmsim/reference/summarise_mpms.md)

## Author

Owen Jones <jones@biology.sdu.dk>

## Examples

``` r
matDim <- 10
A1 <- make_leslie_mpm(
  survival = seq(0.1, 0.7, length.out = matDim),
  fecundity = seq(0.1, 0.7, length.out = matDim),
  n_stages = matDim
)
plot_matrix(A1, zero_na = TRUE, na_colour = "black")

plot_matrix(A1, zero_na = TRUE, na_colour = NA)

```
