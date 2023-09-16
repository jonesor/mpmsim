
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mpmsim <img src="man/figures/logo_mpmsim.png" align="right" height="100" style="float:right; height:100px;">

<!-- badges: start -->
<!--- BE CAREFUL WITH THE FORMATTING --->

| Project                                                                                                                                                                                                | Main                                                                                                                                                                   | Devel                                                                                                                                                                                    |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)                                                                                | [![R-CMD-check](https://github.com/jonesor/mpmsim/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jonesor/mpmsim/actions/workflows/R-CMD-check.yaml) | [![R-CMD-check-devel](https://github.com/jonesor/mpmsim/actions/workflows/R-CMD-check-devel.yaml/badge.svg)](https://github.com/jonesor/mpmsim/actions/workflows/R-CMD-check-devel.yaml) |
| [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) | [![Codecov test coverage](https://codecov.io/gh/jonesor/mpmsim/branch/main/graph/badge.svg)](https://app.codecov.io/gh/jonesor/mpmsim?branch=main)                     |                                                                                                                                                                                          |
| ![](http://cranlogs.r-pkg.org/badges/grand-total/mpmsim)                                                                                                                                               |                                                                                                                                                                        |                                                                                                                                                                                          |
| ![](http://cranlogs.r-pkg.org/badges/mpmsim)                                                                                                                                                           |                                                                                                                                                                        |                                                                                                                                                                                          |
| [![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/mpmsim)](https://cran.r-project.org/package=mpmsim)                                                                                         |                                                                                                                                                                        |                                                                                                                                                                                          |

<!-- badges: end -->

`mpmsim` contains tools for generating random or semi-random matrix
population models (MPMs) given a particular life history archetype. It
also facilitates the generation of Leslie matrices, and the simulation
of MPMs based on expected transition rates and sample sizes. This can be
useful for exploring uncertainty in inferences when sample sizes are
small (or unknown).

## Installation

You can install the latest stable version of `mpmsim` from CRAN like
this:

``` r
install.packages("mpmsim")
```

### Development version(s)

The package is being developed (here) on GitHub. You can install the
latest development version of `mpmsim` like this:

``` r
# install package 'remotes' if necessary
# will already be installed if 'devtools' is installed
install.packages("remotes")

# argument 'build_opts = NULL' only needed if you want to build vignettes
remotes::install_github("jonesor/mpmsim", build_opts = NULL)
```

During development there may be other versions, with additional
functionality, available on different GitHub “branches”. To install from
one of these branches, use the following syntax:

``` r
# install from the 'dev' branch
remotes::install_github("jonesor/mpmsim", ref = "dev")
```

## Usage

First, load the package.

``` r
library(mpmsim)
```

### Generate a Leslie matrix

The `make_leslie_mpm` function can be used to generate a Leslie matrix,
where the stages represent discrete age classes. In a Leslie matrix,
survival is represented in the lower sub-diagonal and the
lower-right-hand corner element, while fertility is shown in the top
row. Both survival and fertility have a length equal to the number of
stages in the model. Users can specify both survival and fertility as
either a single value or a vector of values, with a length equal to the
dimensions of the matrix model. If these arguments are single values,
the value is repeated along the survival/fertility sequence.

``` r
make_leslie_mpm(
  survival = seq(0.1, 0.45, length.out = 4),
  fertility = c(0, 0, 2.4, 5), n_stages = 4, split = FALSE
)
#>      [,1]      [,2]      [,3] [,4]
#> [1,]  0.0 0.0000000 2.4000000 5.00
#> [2,]  0.1 0.0000000 0.0000000 0.00
#> [3,]  0.0 0.2166667 0.0000000 0.00
#> [4,]  0.0 0.0000000 0.3333333 0.45
```

### Using a functional form for mortality

Users can generate Leslie matrices with particular functional forms of
mortality by first making a data frame of a simplified life table that
includes age and survival probability within each age interval.

``` r
(surv_prob <- model_survival(params = c(0.2, 0.4), model = "Gompertz"))
#>   x        hx         lx        qx        px
#> 1 0 0.2000000 1.00000000 0.2205623 0.7794377
#> 2 1 0.2983649 0.77943774 0.3104641 0.6895359
#> 3 2 0.4451082 0.53745028 0.4256784 0.5743216
#> 4 3 0.6640234 0.30866930 0.5627783 0.4372217
#> 5 4 0.9906065 0.13495691 0.7089351 0.2910649
#> 6 5 1.4778112 0.03928123 0.8413767 0.1586233
```

Age-specific survival probability is given by the `px` column in the
output from `model_survival`. Users can also use a functional form for
fertility (see `model_fertility`) and here a simple step function is
assumed.

``` r
survival <- surv_prob$px
fertility <- model_fertility(
  age = 0:(length(survival) - 1),
  params = c(A = 5), maturity = 2, model = "step"
)
```

Subsequently, these survival and fertility values can be applied to the
Leslie matrix as follows.

``` r
make_leslie_mpm(
  survival = survival, fertility = fertility,
  n_stages = length(survival), split = FALSE
)
#>           [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.0000000 0.0000000 5.0000000 5.0000000 5.0000000 5.0000000
#> [2,] 0.7794377 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.0000000 0.6895359 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.0000000 0.0000000 0.5743216 0.0000000 0.0000000 0.0000000
#> [5,] 0.0000000 0.0000000 0.0000000 0.4372217 0.0000000 0.0000000
#> [6,] 0.0000000 0.0000000 0.0000000 0.0000000 0.2910649 0.1586233
```

### Sets of Leslie matrices

Users can generate large numbers of plausible Leslie matrices by
repeating the `make_leslie_mpm` command in a loop. For example, the
following code produces a list of five Leslie matrices that have
increasing survival with age.

``` r
sample_size <- 5
juvSurv <- runif(n = sample_size, min = 0.0, max = 0.1)
adultSurv <- runif(n = sample_size, min = 0.4, max = 0.8)
adultFert <- rpois(sample_size, 6)

outputMPMs <- NULL
for (i in 1:sample_size) {
  outputMPMs[[i]] <- make_leslie_mpm(
    survival = seq(juvSurv[i], adultSurv[i], length.out = 6),
    fertility = c(0, 0, rep(adultFert[i], 4)), n_stages = 6, split = FALSE
  )
}

outputMPMs
#> [[1]]
#>           [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.0000000 0.0000000 6.0000000 6.0000000 6.0000000 6.0000000
#> [2,] 0.0914806 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.0000000 0.1947122 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.0000000 0.0000000 0.2979437 0.0000000 0.0000000 0.0000000
#> [5,] 0.0000000 0.0000000 0.0000000 0.4011753 0.0000000 0.0000000
#> [6,] 0.0000000 0.0000000 0.0000000 0.0000000 0.5044068 0.6076384
#> 
#> [[2]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 7.0000000 7.0000000 7.0000000 7.0000000
#> [2,] 0.09370754 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.2138931 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.3340787 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4542642 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5744498 0.6946353
#> 
#> [[3]]
#>            [,1]      [,2]      [,3]       [,4]       [,5]       [,6]
#> [1,] 0.00000000 0.0000000 10.000000 10.0000000 10.0000000 10.0000000
#> [2,] 0.02861395 0.0000000  0.000000  0.0000000  0.0000000  0.0000000
#> [3,] 0.00000000 0.1136645  0.000000  0.0000000  0.0000000  0.0000000
#> [4,] 0.00000000 0.0000000  0.198715  0.0000000  0.0000000  0.0000000
#> [5,] 0.00000000 0.0000000  0.000000  0.2837656  0.0000000  0.0000000
#> [6,] 0.00000000 0.0000000  0.000000  0.0000000  0.3688161  0.4538666
#> 
#> [[4]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 4.0000000 4.0000000 4.0000000 4.0000000
#> [2,] 0.08304476 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1989952 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.3149456 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4308961 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5468465 0.6627969
#> 
#> [[5]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 6.0000000 6.0000000 6.0000000 6.0000000
#> [2,] 0.06417455 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1877448 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.3113151 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4348854 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5584556 0.6820259
```

Here’s one way to do a similar thing with uncertainty applied to a
Gompertz mortality.

``` r
sample_size <- 5
b0_values <- rnorm(n = sample_size, mean = 0.3, sd = 0.1)
b1_values <- rnorm(n = sample_size, mean = 0.4, sd = 0.1)
fertility_values <- rnorm(n = sample_size, mean = 3, sd = 1)

outputMPMs <- NULL
for (i in 1:sample_size) {
  surv_prob <- model_survival(
    params = c(b0_values[i], b1_values[i]),
    model = "Gompertz"
  )
  survival <- surv_prob$px

  maturity <- 2
  fertility <- c(
    rep(0, maturity),
    rep(fertility_values[i], length(survival) - maturity)
  )

  outputMPMs[[i]] <- make_leslie_mpm(
    survival = survival, fertility = fertility,
    n_stages = length(survival), split = FALSE
  )
}

outputMPMs
#> [[1]]
#>           [,1]      [,2]      [,3]      [,4]       [,5]
#> [1,] 0.0000000 0.0000000 3.9657529 3.9657529 3.96575288
#> [2,] 0.5662538 0.0000000 0.0000000 0.0000000 0.00000000
#> [3,] 0.0000000 0.4267964 0.0000000 0.0000000 0.00000000
#> [4,] 0.0000000 0.0000000 0.2795021 0.0000000 0.00000000
#> [5,] 0.0000000 0.0000000 0.0000000 0.1483049 0.05742431
#> 
#> [[2]]
#>           [,1]      [,2]      [,3]      [,4]      [,5]
#> [1,] 0.0000000 0.0000000 2.1854291 2.1854291 2.1854291
#> [2,] 0.7828594 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.0000000 0.6593341 0.0000000 0.0000000 0.0000000
#> [4,] 0.0000000 0.0000000 0.4922804 0.0000000 0.0000000
#> [5,] 0.0000000 0.0000000 0.0000000 0.2994381 0.1285137
#> 
#> [[3]]
#>           [,1]      [,2]      [,3]      [,4]       [,5]
#> [1,] 0.0000000 0.0000000 3.2839578 3.2839578 3.28395781
#> [2,] 0.6591217 0.0000000 0.0000000 0.0000000 0.00000000
#> [3,] 0.0000000 0.5037044 0.0000000 0.0000000 0.00000000
#> [4,] 0.0000000 0.0000000 0.3236247 0.0000000 0.00000000
#> [5,] 0.0000000 0.0000000 0.0000000 0.1562993 0.04720172
#> 
#> [[4]]
#>           [,1]      [,2]      [,3]      [,4]      [,5]       [,6]
#> [1,] 0.0000000 0.0000000 2.8383014 2.8383014 2.8383014 2.83830135
#> [2,] 0.7775471 0.0000000 0.0000000 0.0000000 0.0000000 0.00000000
#> [3,] 0.0000000 0.6636757 0.0000000 0.0000000 0.0000000 0.00000000
#> [4,] 0.0000000 0.0000000 0.5127486 0.0000000 0.0000000 0.00000000
#> [5,] 0.0000000 0.0000000 0.0000000 0.3367703 0.0000000 0.00000000
#> [6,] 0.0000000 0.0000000 0.0000000 0.0000000 0.1697708 0.05561344
#> 
#> [[5]]
#>           [,1]      [,2]      [,3]      [,4]
#> [1,] 0.0000000 0.0000000 4.9355718 4.9355718
#> [2,] 0.5533382 0.0000000 0.0000000 0.0000000
#> [3,] 0.0000000 0.3959549 0.0000000 0.0000000
#> [4,] 0.0000000 0.0000000 0.2344795 0.1032486
```

### Simulate sampling error for an MPM

The function `add_mpm_error` can be used to simulate an MPM with
sampling error, based on expected transition rates (survival and
fecundity) and sample sizes. The expected transition rates must be
provided as matrices. The sample size(s) can be given as either a matrix
of sample sizes for each element of the matrix or as a single value
which is then applied to all elements of the matrix.

The function uses a binomial process to simulate survival/growth
elements and a Poisson process to simulate the fecundity elements. As a
result, when sample sizes are large, the simulated MPM will closely
reflect the expected transition rates. In contrast, when sample sizes
are small, the simulated matrices will become more variable.

To illustrate use of the function, the following code first generates a
3-stage Leslie matrix using the `make_leslie_mpm` function. It then
passes the U and F matrices from this Leslie matrix to the
`add_mpm_error` function. Then, two matrices are simulated, first with a
sample size of 1000, and then with a sample size of seven.

``` r
mats <- make_leslie_mpm(
  survival = c(0.3, 0.5, 0.8),
  fertility = c(0, 2.2, 4.4),
  n_stages = 3, split = TRUE
)

add_mpm_error(
  mat_U = mats$mat_U, mat_F = mats$mat_F,
  sample_size = 1000, split = FALSE, by_type = FALSE
)
#>       [,1]  [,2]  [,3]
#> [1,] 0.000 2.255 4.482
#> [2,] 0.287 0.000 0.000
#> [3,] 0.000 0.507 0.794

add_mpm_error(
  mat_U = mats$mat_U, mat_F = mats$mat_F,
  sample_size = 7, split = FALSE, by_type = FALSE
)
#>           [,1]      [,2]     [,3]
#> [1,] 0.0000000 1.8571429 4.714286
#> [2,] 0.4285714 0.0000000 0.000000
#> [3,] 0.0000000 0.7142857 1.000000
```

A list of an arbitrary number of matrices can be generated easily using
`replicate`, as follows.

``` r
replicate(
  n = 5,
  add_mpm_error(
    mat_U = mats$mat_U, mat_F = mats$mat_F,
    sample_size = 7, split = FALSE, by_type = FALSE
  )
)
#> , , 1
#> 
#>      [,1]      [,2]      [,3]
#> [1,]    0 1.5714286 4.1428571
#> [2,]    0 0.0000000 0.0000000
#> [3,]    0 0.4285714 0.7142857
#> 
#> , , 2
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.2857143 5.5714286
#> [2,] 0.7142857 0.0000000 0.0000000
#> [3,] 0.0000000 0.5714286 0.7142857
#> 
#> , , 3
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.1428571 4.4285714
#> [2,] 0.1428571 0.0000000 0.0000000
#> [3,] 0.0000000 0.5714286 0.5714286
#> 
#> , , 4
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 1.7142857 4.0000000
#> [2,] 0.7142857 0.0000000 0.0000000
#> [3,] 0.0000000 0.5714286 0.8571429
#> 
#> , , 5
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.5714286 4.5714286
#> [2,] 0.4285714 0.0000000 0.0000000
#> [3,] 0.0000000 0.4285714 0.7142857
```

### Generate single random Lefkovitch MPMs

The `random_mpm` function can be used to generate a random Lefkovitch
matrix population model (MPM) with element values based on defined life
history archetypes. The function draws survival and transition/growth
probabilities from a Dirichlet distribution to ensure that the column
totals, including death, are less than or equal to 1. Fecundity can be
specified as a single value or as a vector with a length equal to the
dimensions of the matrix. If specified as a single value, it is placed
in the top-right corner of the matrix. If specified as a vector of
length `n_stages`, it spans the entire top row of the matrix. The
`archetype` argument can be used to constrain the MPMs, for example,
`archetype = 2` constraints the survival probability to increase
monotonically as individuals advance to later stages. For more
information, see the documentation for `random_mpm` and Takada et
al. (2018). In the following example, I split the output matrices into
the `U` and `F` matrices, which could be summed to create the `A`
matrix.

``` r
(rMPM <- random_mpm(
  n_stages = 3, fecundity = 20,
  archetype = 2, split = TRUE
))
#> $mat_A
#>            [,1]        [,2]       [,3]
#> [1,] 0.01566286 0.003962617 20.2372038
#> [2,] 0.19165445 0.447044844  0.1369993
#> [3,] 0.25834510 0.111258159  0.3916082
#> 
#> $mat_U
#>            [,1]        [,2]      [,3]
#> [1,] 0.01566286 0.003962617 0.2372038
#> [2,] 0.19165445 0.447044844 0.1369993
#> [3,] 0.25834510 0.111258159 0.3916082
#> 
#> $mat_F
#>      [,1] [,2] [,3]
#> [1,]    0    0   20
#> [2,]    0    0    0
#> [3,]    0    0    0
```

### Generate a set of random Lefkovitch MPMs

The `generate_mpm_set` function can be used to quickly generate large
numbers of Lefkovitch MPMs using the above approach. For example, the
following code generates five MPMs with archetype 1. By using the
`constraint` argument, users can specify an acceptable characteristics
for the set of matrices. In this case, population growth rate range,
which can be useful for life history analyses where we might assume that
only life histories with lambda values close to 1 can persist in nature.
We set the argument `as_compadre = FALSE` to ensure that the function
returns a `list` object rather than a `CompadreDB` object.

``` r
library(popbio)
constrain_df <- data.frame(fun = "lambda", arg = NA, lower = 0.9, upper = 1.1)
generate_mpm_set(
  n = 5, n_stages = 4, fecundity = 8, archetype = 1, constraint = constrain_df,
  as_compadre = FALSE
)
#> $A_list
#> $A_list[[1]]
#>            [,1]       [,2]       [,3]       [,4]
#> [1,] 0.18613484 0.05056112 0.60606250 8.03563397
#> [2,] 0.06525489 0.23191129 0.02425596 0.15026015
#> [3,] 0.30463553 0.08240703 0.08948712 0.02062413
#> [4,] 0.01236183 0.14045978 0.04548197 0.18125603
#> 
#> $A_list[[2]]
#>            [,1]       [,2]      [,3]       [,4]
#> [1,] 0.24550383 0.17451532 0.3054684 8.31033310
#> [2,] 0.19319756 0.35861915 0.1851036 0.44100809
#> [3,] 0.11691720 0.28889696 0.1836001 0.08302706
#> [4,] 0.02694353 0.05514741 0.1076480 0.15043028
#> 
#> $A_list[[3]]
#>             [,1]       [,2]       [,3]       [,4]
#> [1,] 0.027883153 0.28550192 0.18463803 8.18854957
#> [2,] 0.497257332 0.12466879 0.12901066 0.36556709
#> [3,] 0.000321996 0.12822913 0.07978954 0.03463416
#> [4,] 0.012942131 0.08459218 0.03693279 0.18702167
#> 
#> $A_list[[4]]
#>            [,1]        [,2]       [,3]       [,4]
#> [1,] 0.45535069 0.079556357 0.01573857 8.44687525
#> [2,] 0.12608798 0.809470988 0.13932014 0.16388405
#> [3,] 0.35947604 0.063327966 0.26672277 0.04283801
#> [4,] 0.02558323 0.004365279 0.08267203 0.08580600
#> 
#> $A_list[[5]]
#>            [,1]       [,2]      [,3]       [,4]
#> [1,] 0.05029395 0.33485342 0.2077841 8.06016689
#> [2,] 0.12684505 0.01529961 0.1784790 0.62796386
#> [3,] 0.19514844 0.40393834 0.3428090 0.03261264
#> [4,] 0.02243209 0.10121339 0.1090846 0.07553934
#> 
#> 
#> $U_list
#> $U_list[[1]]
#>            [,1]       [,2]       [,3]       [,4]
#> [1,] 0.18613484 0.05056112 0.60606250 0.03563397
#> [2,] 0.06525489 0.23191129 0.02425596 0.15026015
#> [3,] 0.30463553 0.08240703 0.08948712 0.02062413
#> [4,] 0.01236183 0.14045978 0.04548197 0.18125603
#> 
#> $U_list[[2]]
#>            [,1]       [,2]      [,3]       [,4]
#> [1,] 0.24550383 0.17451532 0.3054684 0.31033310
#> [2,] 0.19319756 0.35861915 0.1851036 0.44100809
#> [3,] 0.11691720 0.28889696 0.1836001 0.08302706
#> [4,] 0.02694353 0.05514741 0.1076480 0.15043028
#> 
#> $U_list[[3]]
#>             [,1]       [,2]       [,3]       [,4]
#> [1,] 0.027883153 0.28550192 0.18463803 0.18854957
#> [2,] 0.497257332 0.12466879 0.12901066 0.36556709
#> [3,] 0.000321996 0.12822913 0.07978954 0.03463416
#> [4,] 0.012942131 0.08459218 0.03693279 0.18702167
#> 
#> $U_list[[4]]
#>            [,1]        [,2]       [,3]       [,4]
#> [1,] 0.45535069 0.079556357 0.01573857 0.44687525
#> [2,] 0.12608798 0.809470988 0.13932014 0.16388405
#> [3,] 0.35947604 0.063327966 0.26672277 0.04283801
#> [4,] 0.02558323 0.004365279 0.08267203 0.08580600
#> 
#> $U_list[[5]]
#>            [,1]       [,2]      [,3]       [,4]
#> [1,] 0.05029395 0.33485342 0.2077841 0.06016689
#> [2,] 0.12684505 0.01529961 0.1784790 0.62796386
#> [3,] 0.19514844 0.40393834 0.3428090 0.03261264
#> [4,] 0.02243209 0.10121339 0.1090846 0.07553934
#> 
#> 
#> $F_list
#> $F_list[[1]]
#>      [,1] [,2] [,3] [,4]
#> [1,]    0    0    0    8
#> [2,]    0    0    0    0
#> [3,]    0    0    0    0
#> [4,]    0    0    0    0
#> 
#> $F_list[[2]]
#>      [,1] [,2] [,3] [,4]
#> [1,]    0    0    0    8
#> [2,]    0    0    0    0
#> [3,]    0    0    0    0
#> [4,]    0    0    0    0
#> 
#> $F_list[[3]]
#>      [,1] [,2] [,3] [,4]
#> [1,]    0    0    0    8
#> [2,]    0    0    0    0
#> [3,]    0    0    0    0
#> [4,]    0    0    0    0
#> 
#> $F_list[[4]]
#>      [,1] [,2] [,3] [,4]
#> [1,]    0    0    0    8
#> [2,]    0    0    0    0
#> [3,]    0    0    0    0
#> [4,]    0    0    0    0
#> 
#> $F_list[[5]]
#>      [,1] [,2] [,3] [,4]
#> [1,]    0    0    0    8
#> [2,]    0    0    0    0
#> [3,]    0    0    0    0
#> [4,]    0    0    0    0
```

### Plot a matrix

It can be helpful to visualise the matrices. This can be accomplished
with the function `plot_matrix`. The output of `plot_matrix` is of class
`ggplot` and as such the colour scheme can be modified in the usual way
with, for example, `scale_fill_gradient` or similar.

Here’s the matrix:

``` r
rMPM$mat_U
#>            [,1]        [,2]      [,3]
#> [1,] 0.01566286 0.003962617 0.2372038
#> [2,] 0.19165445 0.447044844 0.1369993
#> [3,] 0.25834510 0.111258159 0.3916082
```

And here’s the plot:

``` r
p <- plot_matrix(rMPM$mat_U)
p + ggplot2::scale_fill_gradient(low = "black", high = "yellow")
```

<img src="man/figures/plot_a_matrix01.png" width="300" style="display: block; margin: auto;" />

## Contributions

All contributions are welcome. Please note that this project is released
with a [Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By participating in this project you agree to abide by its terms.

There are numerous ways of contributing.

1.  You can submit bug reports, suggestions etc. by [opening an
    issue](https://github.com/jonesor/mpmsim/issues).

2.  You can copy or fork the repository, make your own code edits and
    then send us a pull request. [Here’s how to do
    that](https://jarv.is/notes/how-to-pull-request-fork-github/).

3.  You are also welcome to email me.
