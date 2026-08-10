# Calculate driven vital rates

This function calculates new values for a vital rate, such as survival
or fecundity that is being influenced by a driver (e.g., weather). It
does this by using a driver variable and a baseline value, along with a
specified slope for the relationship between the driver variable and the
vital rate. The function works on a linearised scale, using logit for
survival and log for fecundity, and takes into account the error
standard deviation.

## Usage

``` r
driven_vital_rate(
  driver,
  baseline_value = NULL,
  slope = NULL,
  baseline_driver = NULL,
  error_sd = 0,
  link = "logit"
)
```

## Arguments

- driver:

  A vector of driver values.

- baseline_value:

  A vector or matrix of baseline values for the vital rate (e.g.,
  survival) that is being influenced ("driven") by another variable
  (e.g. a climatic variable).

- slope:

  A vector or matrix of slopes for the relationship between the driver
  variable and the vital rate being driven.

- baseline_driver:

  The `baseline_driver` parameter is a single value representing the
  baseline driver value. If the driver value is greater than this value
  and the slope is positive, then the resulting vital rate will be
  higher. Conversely, if the driver value is less than this variable and
  the slope is positive, then the resulting vital rate will be less than
  the baseline value.

- error_sd:

  A vector or matrix of error standard deviations for random normal
  error to be added to the driven value of the vital rate being
  modelled. If set to 0 (the default), no error is added.

- link:

  A character string indicating the type of link function to use. Valid
  values are "`logit`" (the default) and "`log`", which are appropriate
  for survival (U submatrix) and fecundity (F submatrix) respectively.

## Value

Depending on the input types, either a single value, a vector or a list
of matrices of driven values for the vital rate(s) being modelled. The
list has a length equal to the length of the `driver` input parameter.

## Details

The relationship between the driver variable and the vital rate is
assumed to be linear:

\$\$V = a \* (d - d_b) + x + E\$\$

Where \$\$V\$\$ is the new vital rate (on the scale of the linear
predictor), \$\$a\$\$ is the slope, \$\$x\$\$ is the baseline vital
rate, \$\$d\$\$ is the driver, \$\$d_b\$\$ is the baseline driver and
\$\$E\$\$ is the error.

The input vital rate(s) (`baseline_value`) can be a single-element
vector representing a single vital rate (e.g., survival probability or
fecundity), a longer vector representing a series of vital rates (e.g.,
several survival probabilities or fecundity values), or a matrix of
values (e.g., a U or F submatrix of a matrix population model). The
`slope`s of the relationship between the vital rate (`baseline_value`)
and the driver can be provided as a single value, which is applied to
all elements of the input vital rates, or as a matrix of values that map
onto the matrix of vital rates. This allows users to simulate cases
where different vital rates in a matrix model are affected in different
ways by the same weather driver. For example, juvenile survival might be
more affected by the driver than adult survival. The `baseline_driver`
value represents the "normal" state of the driver. If the driver is
greater than the `baseline_driver` and the `slope` is positive, then the
outcome vital rate will be higher. If the driver is less than the
`baseline_driver` variable and the `slope` is positive, then the outcome
vital rate will be less than the `baseline_value.` The `error_sd`
represents the error in the linear relationship between the driver and
the vital rate.

## Author

Owen Jones <jones@biology.sdu.dk>

## Examples

``` r
set.seed(42) # set seed for repeatability

# A single vital rate and a single driver
driven_vital_rate(
  driver = 14,
  baseline_value = 0.5,
  slope = .4,
  baseline_driver = 10,
  error_sd = 0,
  link = "logit"
)
#> [1] 0.8320184

# A single vital rate and a time series of drivers
driven_vital_rate(
  driver = runif(10, 5, 15),
  baseline_value = 0.5,
  slope = .4,
  baseline_driver = 10,
  error_sd = 0,
  link = "logit"
)
#> [[1]]
#> [1] 0.8401338
#> 
#> [[2]]
#> [1] 0.8517385
#> 
#> [[3]]
#> [1] 0.2982926
#> 
#> [[4]]
#> [1] 0.7894794
#> 
#> [[5]]
#> [1] 0.6380665
#> 
#> [[6]]
#> [1] 0.5190867
#> 
#> [[7]]
#> [1] 0.7203812
#> 
#> [[8]]
#> [1] 0.1882634
#> 
#> [[9]]
#> [1] 0.6520288
#> 
#> [[10]]
#> [1] 0.6942913
#> 

# A matrix of survival values (U submatrix of a Leslie model)
# with a series of drivers, and matrices of slopes and errors

lt1 <- model_survival(params = c(b_0 = 0.4, b_1 = 0.5), model = "Gompertz")
lt1$fecundity <- model_fecundity(
  age = 0:max(lt1$x), params = c(A = 10),
  maturity = 3, model = "step"
)

mats <- make_leslie_mpm(
  survival = lt1$px, fecundity = lt1$fecundity, n_stages =
    nrow(lt1), split = TRUE
)
mats$mat_U
#>          [,1]      [,2]      [,3]      [,4]
#> [1,] 0.000000 0.0000000 0.0000000 0.0000000
#> [2,] 0.595129 0.0000000 0.0000000 0.0000000
#> [3,] 0.000000 0.4250075 0.0000000 0.0000000
#> [4,] 0.000000 0.0000000 0.2439661 0.0976961
mat_dim <- nrow(mats$mat_U)

driven_vital_rate(
  driver = runif(5, 5, 15),
  baseline_value = mats$mat_U,
  slope = matrix(.4,
    nrow = mat_dim,
    ncol = mat_dim
  ),
  baseline_driver = 10,
  error_sd = matrix(1, nrow = mat_dim, ncol = mat_dim),
  link = "logit"
)
#> [[1]]
#>           [,1]      [,2]    [,3]     [,4]
#> [1,] 0.0000000 0.0000000 0.00000 0.000000
#> [2,] 0.2745887 0.0000000 0.00000 0.000000
#> [3,] 0.0000000 0.6992388 0.00000 0.000000
#> [4,] 0.0000000 0.0000000 0.10768 0.338745
#> 
#> [[2]]
#>           [,1]      [,2]      [,3]      [,4]
#> [1,] 0.0000000 0.0000000 0.0000000 0.0000000
#> [2,] 0.8269394 0.0000000 0.0000000 0.0000000
#> [3,] 0.0000000 0.6480171 0.0000000 0.0000000
#> [4,] 0.0000000 0.0000000 0.2770466 0.1592273
#> 
#> [[3]]
#>          [,1]      [,2]      [,3]       [,4]
#> [1,] 0.000000 0.0000000 0.0000000 0.00000000
#> [2,] 0.754136 0.0000000 0.0000000 0.00000000
#> [3,] 0.000000 0.1134005 0.0000000 0.00000000
#> [4,] 0.000000 0.0000000 0.4565608 0.03482534
#> 
#> [[4]]
#>           [,1]      [,2]      [,3]        [,4]
#> [1,] 0.0000000 0.0000000 0.0000000 0.000000000
#> [2,] 0.3291929 0.0000000 0.0000000 0.000000000
#> [3,] 0.0000000 0.2584927 0.0000000 0.000000000
#> [4,] 0.0000000 0.0000000 0.3598194 0.009905902
#> 
#> [[5]]
#>           [,1]      [,2]       [,3]      [,4]
#> [1,] 0.0000000 0.0000000 0.00000000 0.0000000
#> [2,] 0.7575404 0.0000000 0.00000000 0.0000000
#> [3,] 0.0000000 0.5756863 0.00000000 0.0000000
#> [4,] 0.0000000 0.0000000 0.09984528 0.0814136
#> 
```
