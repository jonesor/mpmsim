
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
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 7.0000000 7.0000000 7.0000000 7.0000000
#> [2,] 0.04118865 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1673406 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2934926 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4196445 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5457965 0.6719484
#> 
#> [[2]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 5.0000000 5.0000000 5.0000000 5.0000000
#> [2,] 0.01210159 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1078452 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2035889 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.2993325 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.3950761 0.4908198
#> 
#> [[3]]
#>            [,1]      [,2]      [,3]       [,4]       [,5]       [,6]
#> [1,] 0.00000000 0.0000000 12.000000 12.0000000 12.0000000 12.0000000
#> [2,] 0.02930994 0.0000000  0.000000  0.0000000  0.0000000  0.0000000
#> [3,] 0.00000000 0.1542125  0.000000  0.0000000  0.0000000  0.0000000
#> [4,] 0.00000000 0.0000000  0.279115  0.0000000  0.0000000  0.0000000
#> [5,] 0.00000000 0.0000000  0.000000  0.4040176  0.0000000  0.0000000
#> [6,] 0.00000000 0.0000000  0.000000  0.0000000  0.5289202  0.6538227
#> 
#> [[4]]
#>            [,1]      [,2]      [,3]     [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 7.0000000 7.000000 7.0000000 7.0000000
#> [2,] 0.08456303 0.0000000 0.0000000 0.000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.2207337 0.0000000 0.000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.3569044 0.000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.493075 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.000000 0.6292457 0.7654164
#> 
#> [[5]]
#>            [,1]      [,2]      [,3]    [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 6.0000000 6.00000 6.0000000 6.0000000
#> [2,] 0.05699084 0.0000000 0.0000000 0.00000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1330206 0.0000000 0.00000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2090503 0.00000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.28508 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.00000 0.3611097 0.4371395
#> 
#> [[6]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 2.0000000 2.0000000 2.0000000 2.0000000
#> [2,] 0.01442993 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1557757 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2971214 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4384672 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5798129 0.7211587
#> 
#> [[7]]
#>            [,1]     [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.000000 6.0000000 6.0000000 6.0000000 6.0000000
#> [2,] 0.05752491 0.000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.140396 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.000000 0.2232671 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.000000 0.0000000 0.3061382 0.0000000 0.0000000
#> [6,] 0.00000000 0.000000 0.0000000 0.0000000 0.3890093 0.4718804
#> 
#> [[8]]
#>            [,1]      [,2]     [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 7.000000 7.0000000 7.0000000 7.0000000
#> [2,] 0.08203721 0.0000000 0.000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1465071 0.000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.210977 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.000000 0.2754469 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.000000 0.0000000 0.3399168 0.4043867
#> 
#> [[9]]
#>            [,1]      [,2]    [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 5.00000 5.0000000 5.0000000 5.0000000
#> [2,] 0.04716641 0.0000000 0.00000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1214032 0.00000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.19564 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.00000 0.2698768 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.00000 0.0000000 0.3441136 0.4183503
#> 
#> [[10]]
#>           [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.0000000 0.0000000 3.0000000 3.0000000 3.0000000 3.0000000
#> [2,] 0.0917043 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.0000000 0.1815941 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.0000000 0.0000000 0.2714839 0.0000000 0.0000000 0.0000000
#> [5,] 0.0000000 0.0000000 0.0000000 0.3613736 0.0000000 0.0000000
#> [6,] 0.0000000 0.0000000 0.0000000 0.0000000 0.4512634 0.5411532
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
#>       [,1]  [,2]  [,3]
#> [1,] 0.000 2.180 4.458
#> [2,] 0.299 0.000 0.000
#> [3,] 0.000 0.536 0.793

simulate_mpm(
  matU = mats$matU, matF = mats$matF,
  sample_size = 7, split = FALSE
)
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.4285714 4.2857143
#> [2,] 0.5714286 0.0000000 0.0000000
#> [3,] 0.0000000 0.4285714 0.8571429
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
#> [1,] 0.0000000 1.1428571 4.7142857
#> [2,] 0.2857143 0.0000000 0.0000000
#> [3,] 0.0000000 0.5714286 0.8571429
#> 
#> , , 2
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.4285714 4.8571429
#> [2,] 0.1428571 0.0000000 0.0000000
#> [3,] 0.0000000 0.7142857 0.8571429
#> 
#> , , 3
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.2857143 4.2857143
#> [2,] 0.1428571 0.0000000 0.0000000
#> [3,] 0.0000000 0.2857143 0.7142857
#> 
#> , , 4
#> 
#>           [,1]      [,2]     [,3]
#> [1,] 0.0000000 2.8571429 4.142857
#> [2,] 0.2857143 0.0000000 0.000000
#> [3,] 0.0000000 0.4285714 1.000000
#> 
#> , , 5
#> 
#>           [,1]      [,2]     [,3]
#> [1,] 0.0000000 1.7142857 3.714286
#> [2,] 0.1428571 0.0000000 0.000000
#> [3,] 0.0000000 0.5714286 1.000000
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
#>           [,1]      [,2]        [,3]
#> [1,] 0.1101680 0.3208383 17.25137614
#> [2,] 0.3473225 0.2401982  0.09530453
#> [3,] 0.1388808 0.1067494  0.61513722
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
#>            [,1]        [,2]       [,3]       [,4]
#> [1,] 0.08396256 0.037471944 0.01241634 4.10140303
#> [2,] 0.08832627 0.135231937 0.32492699 0.09943638
#> [3,] 0.17614282 0.451050390 0.34655483 0.27178162
#> [4,] 0.13430059 0.008556661 0.06383719 0.21419332
#> 
#> [[2]]
#>             [,1]       [,2]       [,3]       [,4]
#> [1,] 0.510553771 0.30487794 0.25680321 2.55432932
#> [2,] 0.000873154 0.05833942 0.01095387 0.30554443
#> [3,] 0.196608915 0.32738547 0.09796783 0.03961696
#> [4,] 0.040965157 0.20692105 0.41945808 0.03440813
#> 
#> [[3]]
#>            [,1]       [,2]       [,3]      [,4]
#> [1,] 0.12534995 0.08856549 0.50265568 5.0151634
#> [2,] 0.09029332 0.53381851 0.22311129 0.2872258
#> [3,] 0.13523087 0.20348139 0.01969804 0.0402803
#> [4,] 0.03416139 0.06421989 0.24363340 0.2493481
#> 
#> [[4]]
#>            [,1]        [,2]       [,3]       [,4]
#> [1,] 0.04811155 0.488040514 0.14341295 7.43334320
#> [2,] 0.12257546 0.114182140 0.58026218 0.16681269
#> [3,] 0.73918175 0.206185854 0.08091527 0.30683555
#> [4,] 0.01369368 0.005066602 0.04265726 0.07717937
#> 
#> [[5]]
#>           [,1]       [,2]      [,3]      [,4]
#> [1,] 0.2043390 0.35249341 0.2282437 3.5005028
#> [2,] 0.2767119 0.44971373 0.1959247 0.1076575
#> [3,] 0.1223184 0.11184164 0.1870900 0.1211524
#> [4,] 0.1064033 0.05074229 0.1186717 0.1857593
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
