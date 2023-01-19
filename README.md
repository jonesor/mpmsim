
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mpmsim

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

First remember to load the package.

``` r
library(mpmsim)
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
#>            [,1]        [,2]        [,3]
#> [1,] 0.14593481 0.007827801 18.11573135
#> [2,] 0.26071218 0.287536334  0.09134083
#> [3,] 0.09852245 0.338007399  0.78820450
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
#>             [,1]       [,2]      [,3]       [,4]
#> [1,] 0.064408732 0.19225511 0.1630526 5.05030022
#> [2,] 0.362072964 0.10325923 0.2245503 0.11250344
#> [3,] 0.008312629 0.33342500 0.2932137 0.02378394
#> [4,] 0.032424958 0.06810737 0.2972872 0.32113716
#> 
#> [[2]]
#>             [,1]       [,2]       [,3]       [,4]
#> [1,] 0.819935311 0.33252212 0.01560667 2.00828838
#> [2,] 0.076067966 0.15186750 0.52037328 0.08833381
#> [3,] 0.030469115 0.13730222 0.14996826 0.29747834
#> [4,] 0.006764007 0.09055314 0.06526593 0.57119447
#> 
#> [[3]]
#>            [,1]       [,2]        [,3]      [,4]
#> [1,] 0.36404945 0.30897256 0.292034462 2.0407118
#> [2,] 0.04920986 0.49314064 0.004769913 0.3070033
#> [3,] 0.40605086 0.09240266 0.092382356 0.3084696
#> [4,] 0.11178377 0.03479140 0.067128935 0.0614791
#> 
#> [[4]]
#>            [,1]       [,2]       [,3]       [,4]
#> [1,] 0.02760317 0.21540974 0.08144286 1.02504746
#> [2,] 0.23027843 0.05060720 0.13743130 0.54661451
#> [3,] 0.51124413 0.09249182 0.08792638 0.29240540
#> [4,] 0.21719111 0.11598901 0.30070810 0.06425316
#> 
#> [[5]]
#>            [,1]       [,2]        [,3]       [,4]
#> [1,] 0.18894171 0.11260624 0.024629726 5.07550296
#> [2,] 0.36168035 0.58972901 0.001749499 0.31297409
#> [3,] 0.04935836 0.03890263 0.555065578 0.21863629
#> [4,] 0.02334261 0.02593192 0.326267519 0.01731732
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
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 5.0000000 5.0000000 5.0000000 5.0000000
#> [2,] 0.08329273 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1914417 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2995907 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4077397 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5158888 0.6240378
#> 
#> [[2]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 5.0000000 5.0000000 5.0000000 5.0000000
#> [2,] 0.01647593 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1452402 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2740045 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4027688 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5315331 0.6602974
#> 
#> [[3]]
#>            [,1]      [,2]     [,3]     [,4]     [,5]     [,6]
#> [1,] 0.00000000 0.0000000 6.000000 6.000000 6.000000 6.000000
#> [2,] 0.08245093 0.0000000 0.000000 0.000000 0.000000 0.000000
#> [3,] 0.00000000 0.1521489 0.000000 0.000000 0.000000 0.000000
#> [4,] 0.00000000 0.0000000 0.221847 0.000000 0.000000 0.000000
#> [5,] 0.00000000 0.0000000 0.000000 0.291545 0.000000 0.000000
#> [6,] 0.00000000 0.0000000 0.000000 0.000000 0.361243 0.430941
#> 
#> [[4]]
#>            [,1]      [,2]      [,3]      [,4]     [,5]     [,6]
#> [1,] 0.00000000 0.0000000 4.0000000 4.0000000 4.000000 4.000000
#> [2,] 0.08905316 0.0000000 0.0000000 0.0000000 0.000000 0.000000
#> [3,] 0.00000000 0.1772351 0.0000000 0.0000000 0.000000 0.000000
#> [4,] 0.00000000 0.0000000 0.2654171 0.0000000 0.000000 0.000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.3535991 0.000000 0.000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.441781 0.529963
#> 
#> [[5]]
#>            [,1]     [,2]       [,3]       [,4]       [,5]       [,6]
#> [1,] 0.00000000 0.000000 15.0000000 15.0000000 15.0000000 15.0000000
#> [2,] 0.03790716 0.000000  0.0000000  0.0000000  0.0000000  0.0000000
#> [3,] 0.00000000 0.156967  0.0000000  0.0000000  0.0000000  0.0000000
#> [4,] 0.00000000 0.000000  0.2760268  0.0000000  0.0000000  0.0000000
#> [5,] 0.00000000 0.000000  0.0000000  0.3950866  0.0000000  0.0000000
#> [6,] 0.00000000 0.000000  0.0000000  0.0000000  0.5141464  0.6332061
#> 
#> [[6]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 6.0000000 6.0000000 6.0000000 6.0000000
#> [2,] 0.09731798 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1906858 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2840536 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.3774215 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.4707893 0.5641571
#> 
#> [[7]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 9.0000000 9.0000000 9.0000000 9.0000000
#> [2,] 0.07364893 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1571379 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2406268 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.3241157 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.4076047 0.4910936
#> 
#> [[8]]
#>            [,1]      [,2]     [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 7.000000 7.0000000 7.0000000 7.0000000
#> [2,] 0.07149147 0.0000000 0.000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.2001247 0.000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.328758 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.000000 0.4573913 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.000000 0.0000000 0.5860246 0.7146578
#> 
#> [[9]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 4.0000000 4.0000000 4.0000000 4.0000000
#> [2,] 0.03279912 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1172902 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2017813 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.2862724 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.3707634 0.4552545
#> 
#> [[10]]
#>             [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.000000000 0.0000000 7.0000000 7.0000000 7.0000000 7.0000000
#> [2,] 0.008235867 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.000000000 0.1564386 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.000000000 0.0000000 0.3046413 0.0000000 0.0000000 0.0000000
#> [5,] 0.000000000 0.0000000 0.0000000 0.4528441 0.0000000 0.0000000
#> [6,] 0.000000000 0.0000000 0.0000000 0.0000000 0.6010468 0.7492495
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
  matU = mats$matU, matF = mats$matF,
  sample_size = 1000, split = FALSE
)
#>      [,1]  [,2] [,3]
#> [1,] 0.00 2.227 4.31
#> [2,] 0.29 0.000 0.00
#> [3,] 0.00 0.504 0.79

simulate_mpm(
  matU = mats$matU, matF = mats$matF,
  sample_size = 7, split = FALSE
)
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 1.5714286 3.8571429
#> [2,] 0.2857143 0.0000000 0.0000000
#> [3,] 0.0000000 0.2857143 0.7142857
```

A list of an arbitrary number of matrices can be generated easily using
`replicate`, as follows.

``` r
replicate(
  n = 5,
  simulate_mpm(
    matU = mats$matU, matF = mats$matF,
    sample_size = 7, split = FALSE
  )
)
#> , , 1
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 1.8571429 4.4285714
#> [2,] 0.1428571 0.0000000 0.0000000
#> [3,] 0.0000000 0.4285714 0.8571429
#> 
#> , , 2
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.0000000 3.7142857
#> [2,] 0.1428571 0.0000000 0.0000000
#> [3,] 0.0000000 0.7142857 0.8571429
#> 
#> , , 3
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 1.7142857 4.7142857
#> [2,] 0.4285714 0.0000000 0.0000000
#> [3,] 0.0000000 0.4285714 0.5714286
#> 
#> , , 4
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.2857143 5.7142857
#> [2,] 0.2857143 0.0000000 0.0000000
#> [3,] 0.0000000 0.2857143 0.8571429
#> 
#> , , 5
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 1.5714286 3.8571429
#> [2,] 0.1428571 0.0000000 0.0000000
#> [3,] 0.0000000 0.4285714 0.7142857
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
