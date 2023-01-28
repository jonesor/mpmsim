
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
following code produces a list of five Leslie matrices that have
increasing survival with age.

``` r
juvSurv <- runif(n = 10, min = 0.0, max = 0.1)
adultSurv <- runif(n = 10, min = 0.4, max = 0.8)
adultFert <- rpois(10, 6)

outputMPMs <- NULL
for (i in 1:5) {
  outputMPMs[[i]] <- make_leslie_matrix(
    survival = seq(juvSurv[i], adultSurv[i], length.out = 6),
    fertility = c(0, 0, rep(adultFert[i], 4)), n_stages = 6, split = FALSE
  )
}

outputMPMs
#> [[1]]
#>           [,1]      [,2]     [,3]      [,4]      [,5]      [,6]
#> [1,] 0.0000000 0.0000000 9.000000 9.0000000 9.0000000 9.0000000
#> [2,] 0.0914806 0.0000000 0.000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.0000000 0.1898038 0.000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.0000000 0.0000000 0.288127 0.0000000 0.0000000 0.0000000
#> [5,] 0.0000000 0.0000000 0.000000 0.3864503 0.0000000 0.0000000
#> [6,] 0.0000000 0.0000000 0.000000 0.0000000 0.4847735 0.5830967
#> 
#> [[2]]
#>            [,1]     [,2]      [,3]    [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.000000 3.0000000 3.00000 3.0000000 3.0000000
#> [2,] 0.09370754 0.000000 0.0000000 0.00000 0.0000000 0.0000000
#> [3,] 0.00000000 0.212495 0.0000000 0.00000 0.0000000 0.0000000
#> [4,] 0.00000000 0.000000 0.3312825 0.00000 0.0000000 0.0000000
#> [5,] 0.00000000 0.000000 0.0000000 0.45007 0.0000000 0.0000000
#> [6,] 0.00000000 0.000000 0.0000000 0.00000 0.5688574 0.6876449
#> 
#> [[3]]
#>            [,1]      [,2]       [,3]       [,4]       [,5]       [,6]
#> [1,] 0.00000000 0.0000000 12.0000000 12.0000000 12.0000000 12.0000000
#> [2,] 0.02861395 0.0000000  0.0000000  0.0000000  0.0000000  0.0000000
#> [3,] 0.00000000 0.1776649  0.0000000  0.0000000  0.0000000  0.0000000
#> [4,] 0.00000000 0.0000000  0.3267159  0.0000000  0.0000000  0.0000000
#> [5,] 0.00000000 0.0000000  0.0000000  0.4757669  0.0000000  0.0000000
#> [6,] 0.00000000 0.0000000  0.0000000  0.0000000  0.6248179  0.7738689
#> 
#> [[4]]
#>            [,1]      [,2]       [,3]       [,4]       [,5]       [,6]
#> [1,] 0.00000000 0.0000000 10.0000000 10.0000000 10.0000000 10.0000000
#> [2,] 0.08304476 0.0000000  0.0000000  0.0000000  0.0000000  0.0000000
#> [3,] 0.00000000 0.1668701  0.0000000  0.0000000  0.0000000  0.0000000
#> [4,] 0.00000000 0.0000000  0.2506955  0.0000000  0.0000000  0.0000000
#> [5,] 0.00000000 0.0000000  0.0000000  0.3345208  0.0000000  0.0000000
#> [6,] 0.00000000 0.0000000  0.0000000  0.0000000  0.4183462  0.5021715
#> 
#> [[5]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 3.0000000 3.0000000 3.0000000 3.0000000
#> [2,] 0.06417455 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1683231 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2724716 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.3766201 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.4807686 0.5849171
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
#> [1,] 0.000 2.254 4.468
#> [2,] 0.288 0.000 0.000
#> [3,] 0.000 0.510 0.796

simulate_mpm(
  mat_U = mats$mat_U, mat_F = mats$mat_F,
  sample_size = 7, split = FALSE
)
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.1428571 3.5714286
#> [2,] 0.1428571 0.0000000 0.0000000
#> [3,] 0.0000000 0.8571429 0.7142857
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
#>           [,1]      [,2]     [,3]
#> [1,] 0.0000000 2.5714286 4.285714
#> [2,] 0.1428571 0.0000000 0.000000
#> [3,] 0.0000000 0.5714286 1.000000
#> 
#> , , 2
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 1.8571429 4.2857143
#> [2,] 0.2857143 0.0000000 0.0000000
#> [3,] 0.0000000 0.4285714 0.7142857
#> 
#> , , 3
#> 
#>           [,1]      [,2]     [,3]
#> [1,] 0.0000000 3.7142857 5.571429
#> [2,] 0.4285714 0.0000000 0.000000
#> [3,] 0.0000000 0.7142857 1.000000
#> 
#> , , 4
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.0000000 3.7142857
#> [2,] 0.2857143 0.0000000 0.0000000
#> [3,] 0.0000000 0.5714286 0.8571429
#> 
#> , , 5
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.4285714 4.1428571
#> [2,] 0.4285714 0.0000000 0.0000000
#> [3,] 0.0000000 0.2857143 0.8571429
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
#>           [,1]       [,2]       [,3]
#> [1,] 0.4133773 0.35327506 34.1946023
#> [2,] 0.1407397 0.54843293  0.2623188
#> [3,] 0.1549665 0.08638207  0.5425563
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
#>            [,1]       [,2]        [,3]        [,4]
#> [1,] 0.17965064 0.25104495 0.559523884 6.689126138
#> [2,] 0.02662254 0.47968287 0.129292855 0.041311517
#> [3,] 0.01886626 0.07455046 0.262429106 0.009530747
#> [4,] 0.11444672 0.16316280 0.004452358 0.044294511
#> 
#> [[2]]
#>            [,1]       [,2]      [,3]        [,4]
#> [1,] 0.03464681 0.12182352 0.1345819 2.352397795
#> [2,] 0.20989377 0.40623251 0.1928804 0.248668603
#> [3,] 0.43853337 0.21736351 0.3651116 0.309936750
#> [4,] 0.05497098 0.07191438 0.2534837 0.007908794
#> 
#> [[3]]
#>            [,1]        [,2]       [,3]       [,4]
#> [1,] 0.06477820 0.114060884 0.16498562 8.72647650
#> [2,] 0.65342581 0.633632098 0.32476768 0.07536428
#> [3,] 0.17301635 0.083791098 0.22398663 0.09784590
#> [4,] 0.03931067 0.003203861 0.08297216 0.04447663
#> 
#> [[4]]
#>            [,1]       [,2]        [,3]       [,4]
#> [1,] 0.23045134 0.30005703 0.004633533 8.48003549
#> [2,] 0.18310129 0.05975363 0.155108149 0.25435636
#> [3,] 0.01690222 0.05074014 0.056616172 0.01804106
#> [4,] 0.06857838 0.10508779 0.153834415 0.01740904
#> 
#> [[5]]
#>             [,1]       [,2]       [,3]       [,4]
#> [1,] 0.613665888 0.02062234 0.06546807 6.05738363
#> [2,] 0.109387490 0.19737066 0.49630874 0.03287195
#> [3,] 0.185451642 0.25070529 0.14293562 0.17412229
#> [4,] 0.002160339 0.05510238 0.01734127 0.51050113
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
