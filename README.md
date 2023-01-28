
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mpmsim <img src="man/figures/logo_mpmsim.png" align="right" height="100" style="float:right; height:100px;">

<!-- badges: start -->
<!-- badges: end -->

`mpmsim` contains tools for generating random or semi-random matrix
population models (MPMs) given a particular life history archetype. It
also facilitates the generation of Leslie matrices, and the simulation
of MPMs based on expected transition rates and sample sizes. This can be
useful for exploring uncertainty in inferences when sample sizes are
small (or unknown).

## Installation

You can install the development version of `mpmsim` like this:

``` r
# install package 'remotes' if necessary
# will already be installed if 'devtools' is installed
install.packages("remotes")

# argument 'build_opts = NULL' only needed if you want to build vignettes
remotes::install_github("jonesor/mpmsim", build_opts = NULL)
```

## Usage

First, load the package.

``` r
library(mpmsim)
```

### Generate a Leslie matrix

The `make_leslie_matrix` function can be used to generate a Leslie
matrix, where the stages represent discrete age classes. In a Leslie
matrix, survival is represented in the lower sub-diagonal and the
lower-right-hand corner element, while fertility is shown in the top
row. Both survival and fertility have a length equal to the number of
stages in the model. Users can specify both survival and fertility as
either a single value or a vector of values, with a length equal to the
dimensions of the matrix model. If these arguments are single values,
the value is repeated along the survival/fertility sequence.

``` r
make_leslie_matrix(
  survival = seq(0.1, 0.45, length.out = 4),
  fertility = c(0, 0, 2.4, 5), n_stages = 4, split = FALSE
)
#>      [,1]      [,2]      [,3] [,4]
#> [1,]  0.0 0.0000000 2.4000000 5.00
#> [2,]  0.1 0.0000000 0.0000000 0.00
#> [3,]  0.0 0.2166667 0.0000000 0.00
#> [4,]  0.0 0.0000000 0.3333333 0.45
```

Users can generate large numbers of plausible Leslie matrices by
repeating the `make_leslie_matrix` command in a loop. For example, the
following code produces a list of 10 Leslie matrices that have
increasing survival with age.

``` r
juvSurv <- runif(n = 10, min = 0.0, max = 0.1)
adultSurv <- runif(n = 10, min = 0.4, max = 0.8)
adultFert <- rpois(10, 6)

outputMPMs <- NULL
for (i in 1:10) {
  outputMPMs[[i]] <- make_leslie_matrix(
    survival = seq(juvSurv[i], adultSurv[i], length.out = 6),
    fertility = c(0, 0, rep(adultFert[i], 4)), n_stages = 6, split = FALSE
  )
}

outputMPMs
#> [[1]]
#>            [,1]     [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.000000 5.0000000 5.0000000 5.0000000 5.0000000
#> [2,] 0.03171265 0.000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.117554 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.000000 0.2033954 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.000000 0.0000000 0.2892368 0.0000000 0.0000000
#> [6,] 0.00000000 0.000000 0.0000000 0.0000000 0.3750782 0.4609196
#> 
#> [[2]]
#>            [,1]      [,2]     [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 5.000000 5.0000000 5.0000000 5.0000000
#> [2,] 0.09984141 0.0000000 0.000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.2193942 0.000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.338947 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.000000 0.4584998 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.000000 0.0000000 0.5780526 0.6976054
#> 
#> [[3]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 8.0000000 8.0000000 8.0000000 8.0000000
#> [2,] 0.01408936 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1089532 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2038171 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.2986809 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.3935448 0.4884087
#> 
#> [[4]]
#>              [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.0000000000 0.0000000 7.0000000 7.0000000 7.0000000 7.0000000
#> [2,] 0.0008906458 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.0000000000 0.1556224 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.0000000000 0.0000000 0.3103541 0.0000000 0.0000000 0.0000000
#> [5,] 0.0000000000 0.0000000 0.0000000 0.4650858 0.0000000 0.0000000
#> [6,] 0.0000000000 0.0000000 0.0000000 0.0000000 0.6198175 0.7745493
#> 
#> [[5]]
#>             [,1]      [,2]     [,3]      [,4]     [,5]      [,6]
#> [1,] 0.000000000 0.0000000 2.000000 2.0000000 2.000000 2.0000000
#> [2,] 0.006272971 0.0000000 0.000000 0.0000000 0.000000 0.0000000
#> [3,] 0.000000000 0.1096655 0.000000 0.0000000 0.000000 0.0000000
#> [4,] 0.000000000 0.0000000 0.213058 0.0000000 0.000000 0.0000000
#> [5,] 0.000000000 0.0000000 0.000000 0.3164505 0.000000 0.0000000
#> [6,] 0.000000000 0.0000000 0.000000 0.0000000 0.419843 0.5232355
#> 
#> [[6]]
#>            [,1]     [,2]       [,3]       [,4]       [,5]       [,6]
#> [1,] 0.00000000 0.000000 12.0000000 12.0000000 12.0000000 12.0000000
#> [2,] 0.03067128 0.000000  0.0000000  0.0000000  0.0000000  0.0000000
#> [3,] 0.00000000 0.115608  0.0000000  0.0000000  0.0000000  0.0000000
#> [4,] 0.00000000 0.000000  0.2005448  0.0000000  0.0000000  0.0000000
#> [5,] 0.00000000 0.000000  0.0000000  0.2854816  0.0000000  0.0000000
#> [6,] 0.00000000 0.000000  0.0000000  0.0000000  0.3704184  0.4553551
#> 
#> [[7]]
#>            [,1]      [,2]       [,3]       [,4]       [,5]       [,6]
#> [1,] 0.00000000 0.0000000 11.0000000 11.0000000 11.0000000 11.0000000
#> [2,] 0.09916526 0.0000000  0.0000000  0.0000000  0.0000000  0.0000000
#> [3,] 0.00000000 0.2213431  0.0000000  0.0000000  0.0000000  0.0000000
#> [4,] 0.00000000 0.0000000  0.3435209  0.0000000  0.0000000  0.0000000
#> [5,] 0.00000000 0.0000000  0.0000000  0.4656987  0.0000000  0.0000000
#> [6,] 0.00000000 0.0000000  0.0000000  0.0000000  0.5878766  0.7100544
#> 
#> [[8]]
#>            [,1]     [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.000000 9.0000000 9.0000000 9.0000000 9.0000000
#> [2,] 0.02693052 0.000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.132249 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.000000 0.2375674 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.000000 0.0000000 0.3428858 0.0000000 0.0000000
#> [6,] 0.00000000 0.000000 0.0000000 0.0000000 0.4482043 0.5535227
#> 
#> [[9]]
#>            [,1]      [,2]       [,3]      [,4]       [,5]       [,6]
#> [1,] 0.00000000 0.0000000 12.0000000 12.000000 12.0000000 12.0000000
#> [2,] 0.06873399 0.0000000  0.0000000  0.000000  0.0000000  0.0000000
#> [3,] 0.00000000 0.2015833  0.0000000  0.000000  0.0000000  0.0000000
#> [4,] 0.00000000 0.0000000  0.3344327  0.000000  0.0000000  0.0000000
#> [5,] 0.00000000 0.0000000  0.0000000  0.467282  0.0000000  0.0000000
#> [6,] 0.00000000 0.0000000  0.0000000  0.000000  0.6001314  0.7329808
#> 
#> [[10]]
#>             [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.000000000 0.0000000 7.0000000 7.0000000 7.0000000 7.0000000
#> [2,] 0.001555714 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.000000000 0.1516259 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.000000000 0.0000000 0.3016961 0.0000000 0.0000000 0.0000000
#> [5,] 0.000000000 0.0000000 0.0000000 0.4517663 0.0000000 0.0000000
#> [6,] 0.000000000 0.0000000 0.0000000 0.0000000 0.6018365 0.7519066
```

### Simulate an MPM using a particular sample size

The function `simulate_mpm` can be used to simulate an MPM based on
expected transition rates (survival and fecundity) and sample sizes. The
expected transition rates must be provided as matrices. The sample
size(s) can be given as either a matrix of sample sizes for each element
of the matrix or as a single value which is then applied to all elements
of the matrix.

The function uses a binomial process to simulate survival/growth
elements and a Poisson process to simulate the fecundity elements. As a
result, when sample sizes are large, the simulated MPM will closely
reflect the expected transition rates. In contrast, when sample sizes
are small, the simulated matrices will become more variable.

To illustrate use of the function, the following code first generates a
3-stage Leslie matrix using the `make_leslie_matrix` function. It then
passes the U and F matrices from this Leslie matrix to the
`simulate_mpm` function. Then, two matrices are simulated, first with a
sample size of 1000, and then with a sample size of seven.

``` r
mats <- make_leslie_matrix(
  survival = c(0.3, 0.5, 0.8),
  fertility = c(0, 2.2, 4.4),
  n_stages = 3, split = TRUE
)

simulate_mpm(
  mat_U = mats$mat_U, mat_F = mats$mat_F,
  sample_size = 1000, split = FALSE
)
#>       [,1]  [,2]  [,3]
#> [1,] 0.000 2.238 4.325
#> [2,] 0.293 0.000 0.000
#> [3,] 0.000 0.523 0.799

simulate_mpm(
  mat_U = mats$mat_U, mat_F = mats$mat_F,
  sample_size = 7, split = FALSE
)
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 1.7142857 4.2857143
#> [2,] 0.7142857 0.0000000 0.0000000
#> [3,] 0.0000000 0.4285714 0.8571429
```

A list of an arbitrary number of matrices can be generated easily using
`replicate`, as follows.

``` r
replicate(
  n = 5,
  simulate_mpm(
    mat_U = mats$mat_U, mat_F = mats$mat_F,
    sample_size = 7, split = FALSE
  )
)
#> , , 1
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 1.7142857 5.2857143
#> [2,] 0.5714286 0.0000000 0.0000000
#> [3,] 0.0000000 0.5714286 0.8571429
#> 
#> , , 2
#> 
#>           [,1]      [,2]     [,3]
#> [1,] 0.0000000 2.4285714 3.571429
#> [2,] 0.2857143 0.0000000 0.000000
#> [3,] 0.0000000 0.4285714 1.000000
#> 
#> , , 3
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.1428571 4.7142857
#> [2,] 0.1428571 0.0000000 0.0000000
#> [3,] 0.0000000 0.2857143 0.8571429
#> 
#> , , 4
#> 
#>      [,1]      [,2]      [,3]
#> [1,]    0 1.8571429 4.8571429
#> [2,]    0 0.0000000 0.0000000
#> [3,]    0 0.5714286 0.7142857
#> 
#> , , 5
#> 
#>           [,1]      [,2]     [,3]
#> [1,] 0.0000000 2.8571429 3.857143
#> [2,] 0.1428571 0.0000000 0.000000
#> [3,] 0.0000000 0.7142857 1.000000
```

### Generate single random MPMs

The `random_mpm` function can be used to generate a random matrix
population model (MPM) with element values based on defined life history
archetypes. The function draws survival and transition/growth
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
al. (2018).

``` r
random_mpm(n_stages = 3, fecundity = 20, archetype = 2)
#>            [,1]      [,2]        [,3]
#> [1,] 0.03013849 0.2296510 17.62602484
#> [2,] 0.07360409 0.2955212  0.09174857
#> [3,] 0.23197322 0.1316150  0.24920014
```

### Generate a set of random MPMs

The `generate_mpm_set` function can be used to quickly generate large
numbers of MPMs using the above approach. For example, the following
code generates five MPMs with archetype 1. By using the `lower_lambda`
and `upper_lambda` arguments, users can specify an acceptable population
growth rate range for the set of matrices. This can be useful for life
history analyses where we might assume that only life histories with
lambda values close to 1 can persist in nature.

``` r
generate_mpm_set(
  n = 5, n_stages = 4, fecundity = 8, archetype = 1,
  lower_lambda = 0.9, upper_lambda = 1.1
)
#> [[1]]
#>            [,1]       [,2]         [,3]      [,4]
#> [1,] 0.16581914 0.12030695 0.1894891956 9.1058563
#> [2,] 0.08833373 0.40131428 0.0009594756 0.1967155
#> [3,] 0.34061875 0.23424320 0.2227258980 0.2279947
#> [4,] 0.02565558 0.03163263 0.0139434264 0.4206811
#> 
#> [[2]]
#>            [,1]       [,2]      [,3]       [,4]
#> [1,] 0.22515940 0.08612383 0.1188343 5.23989405
#> [2,] 0.18866046 0.22485248 0.1330616 0.06024288
#> [3,] 0.07205247 0.54713874 0.1914553 0.19075985
#> [4,] 0.09088623 0.06256830 0.1155185 0.03158050
#> 
#> [[3]]
#>             [,1]       [,2]       [,3]      [,4]
#> [1,] 0.458928144 0.19667095 0.03699642 3.1761500
#> [2,] 0.029236785 0.07976548 0.53854696 0.2758728
#> [3,] 0.117630301 0.20342194 0.10129004 0.2121735
#> [4,] 0.008757561 0.49780870 0.21989306 0.1763272
#> 
#> [[4]]
#>            [,1]       [,2]       [,3]       [,4]
#> [1,] 0.17415655 0.01320256 0.61399405 2.46389629
#> [2,] 0.55416858 0.43058748 0.09810913 0.08574091
#> [3,] 0.03756986 0.44579122 0.08160542 0.09220091
#> [4,] 0.08663953 0.07603170 0.15725131 0.03601299
#> 
#> [[5]]
#>            [,1]       [,2]       [,3]        [,4]
#> [1,] 0.19471605 0.50946416 0.09972677 3.268725222
#> [2,] 0.11816427 0.03296324 0.20669402 0.102894315
#> [3,] 0.20755963 0.18356273 0.44770326 0.050308961
#> [4,] 0.04407425 0.25404288 0.07046485 0.007896076
```

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
