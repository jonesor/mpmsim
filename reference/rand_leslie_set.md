# Generate a set of random Leslie Matrix Population Models

Generates a set of Leslie matrix population models (MPMs) based on
defined mortality and reproductive output models, and using model
parameters randomly drawn from specified distributions.

## Usage

``` r
rand_leslie_set(
  n_models = 5,
  mortality_model = "gompertz",
  fecundity_model = "step",
  mortality_params,
  fecundity_params,
  fecundity_maturity_params,
  dist_type = "uniform",
  output = "type1",
  scale_output = FALSE
)
```

## Arguments

- n_models:

  An integer indicating the number of MPMs to generate.

- mortality_model:

  A character string specifying the name of the mortality model to be
  used. Options are `gompertz`, `gompertzmakeham`, `exponential`,
  `siler`, `weibull`, and `weibullmakeham`. See `model_mortality`. These
  names are not case-sensitive.

- fecundity_model:

  A character string specifying the name of the model to be used for
  reproductive output. Options are `logistic`, `step`, `vonBertalanffy`,
  `normal` and `hadwiger.` See
  [`?model_fecundity`](https://jonesor.github.io/mpmsim/reference/model_fecundity.md).

- mortality_params:

  A two-column dataframe with a number of rows equal to the number of
  parameters in the mortality model. The required order of the
  parameters depends on the selected `mortality_model` (see
  [`?model_mortality`](https://jonesor.github.io/mpmsim/reference/model_survival.md)):

  - For `gompertz` and `weibull`: `b_0`, `b_1`

  - For `gompertzmakeham` and `weibullmakeham`: `b_0`, `b_1`, `C`

  - For `exponential`: `C`

  - For `siler`: `a_0`, `a_1`, `C`, `b_0`, `b_1` If `dist_type` is
    `uniform` these rows represent the lower and upper limits of the
    random uniform distribution from which the parameters are drawn. If
    `dist_type` is `normal`, the columns represent the mean and standard
    deviation of a random normal distribution from which the parameter
    values are drawn.

- fecundity_params:

  A two-column dataframe with a number of rows equal to the number of
  parameters in the fecundity model. The required order of the
  parameters depends on the selected `fecundity_model` (see
  [`?model_fecundity`](https://jonesor.github.io/mpmsim/reference/model_fecundity.md)):

  - For `logistic`: `A`, `k`, `x_m`

  - For `step`: `A`

  - For `vonBertalanffy`: `A`, `k`

  - For `normal`: `A`, `mu`, `sd`

  - For `hadwiger`: `a`, `b`, `C` If `dist_type` is `uniform` these rows
    represent the lower and upper limits of the random uniform
    distribution from which the parameters are drawn. If `dist_type` is
    `normal`, the columns represent the mean and standard deviation of a
    random normal distribution from which the parameter values are
    drawn.

- fecundity_maturity_params:

  A vector with two elements defining the distribution from which age at
  maturity is drawn for the models. The models will coerce reproductive
  output to be zero before this point. If `dist_type` is `uniform` these
  values represent the lower and upper limits of the random uniform
  distribution from which the parameters are drawn. If `dist_type` is
  `normal`, the values represent the mean and standard deviation of a
  random normal distribution from which the parameter values are drawn.

- dist_type:

  A character string specifying the type of distribution to draw
  parameters from. Default is `uniform`. Supported types are `uniform`
  and `normal`.

- output:

  Character string indicating the type of output.

  - `Type1` or `cdb_split`: A `compadreDB` Object containing MPMs split
    into the submatrices (i.e. A, U, F and C).

  - `Type2` or `cdb_A`: A `compadreDB` Object containing MPMs that are
    not split into submatrices (i.e. only the A matrix is included).

  - `Type3` or `list_split1`: A list of MPMs arranged so that each
    element of the list contains a model and associated submatrices
    (i.e. the nth element contains the nth A matrix alongside the nth U
    and F matrices).

  - `Type4` or `list_split2`: A list of MPMs arranged so that the list
    contains 3 lists for the A matrix and the U and F submatrices
    respectively.

  - `Type5` or `list_A`: A `list` of MPMs, including only the A matrix.

  - `Type6` or `lifetable`: A `list` of life tables.

    Default is `Type1`.

- scale_output:

  A logical argument. If `TRUE` the resulting MPMs or life tables are
  scaled by adjusting reproductive output so that the population growth
  rate (lambda) is 1. Default is `FALSE`.

## Value

Returns a `CompadreDB` object or `list` containing MPMs or life tables
generated using the specified model with parameters drawn from random
uniform or normal distributions. The format of the output MPMs depends
on the arguments `output`. Outputs may optionally be scaled using the
argument `scale_output` to ensure a population growth rate (lambda) of
1.

If the output is a `CompadreDB` object, the parameters of the models
used to produce the MPM are included in the metadata.

## See also

Other Leslie matrices:
[`make_leslie_mpm()`](https://jonesor.github.io/mpmsim/reference/make_leslie_mpm.md),
[`reorganise_matrices()`](https://jonesor.github.io/mpmsim/reference/reorganise_matrices.md)

## Author

Owen Jones <jones@biology.sdu.dk>

## Examples

``` r
mortParams <- data.frame(
  minVal = c(0, 0.01, 0.1),
  maxVal = c(0.14, 0.15, 0.1)
)

fecundityParams <- data.frame(
  minVal = c(10, 0.5, 8),
  maxVal = c(11, 0.9, 10)
)

maturityParam <- c(0, 0)

rand_leslie_set(
  n_models = 5,
  mortality_model = "gompertzmakeham",
  fecundity_model = "normal",
  mortality_params = mortParams,
  fecundity_params = fecundityParams,
  fecundity_maturity_params = maturityParam,
  dist_type = "uniform",
  output = "Type1"
)
#> A COM(P)ADRE database ('CompadreDB') object with ?? SPECIES and 5 MATRICES.
#> 
#> # A tibble: 5 × 10
#>   mat        mortality_model    b_0    b_1     C fecundity_model     A    mu
#>   <list>     <chr>            <dbl>  <dbl> <dbl> <chr>           <dbl> <dbl>
#> 1 <CompdrMt> gompertzmakeham 0.0250 0.0753   0.1 normal           10.2 0.666
#> 2 <CompdrMt> gompertzmakeham 0.101  0.106    0.1 normal           10.2 0.595
#> 3 <CompdrMt> gompertzmakeham 0.0275 0.0956   0.1 normal           10.0 0.766
#> 4 <CompdrMt> gompertzmakeham 0.120  0.0303   0.1 normal           10.6 0.812
#> 5 <CompdrMt> gompertzmakeham 0.0341 0.0305   0.1 normal           10.8 0.777
#> # ℹ 2 more variables: sd <dbl>, fecundity_scaling <dbl>
```
