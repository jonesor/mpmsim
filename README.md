
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
#>           [,1]      [,2]       [,3]
#> [1,] 0.0439475 0.6041381 19.1302650
#> [2,] 0.3291956 0.2212507  0.5249632
#> [3,] 0.2425926 0.0174448  0.2232077
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
#>            [,1]        [,2]        [,3]       [,4]
#> [1,] 0.26069608 0.008581756 0.222077168 8.12345826
#> [2,] 0.32967890 0.418495203 0.549735802 0.08264036
#> [3,] 0.20105617 0.396947680 0.183791385 0.29850866
#> [4,] 0.02426507 0.007671967 0.001383292 0.24038201
#> 
#> [[2]]
#>            [,1]       [,2]       [,3]       [,4]
#> [1,] 0.16948521 0.35504165 0.14706447 2.37137468
#> [2,] 0.30123223 0.02995564 0.13817722 0.08666098
#> [3,] 0.10526559 0.00358321 0.29183262 0.12223809
#> [4,] 0.09669112 0.36744343 0.03204811 0.21799740
#> 
#> [[3]]
#>              [,1]       [,2]       [,3]      [,4]
#> [1,] 0.2926736060 0.06539588 0.34444416 5.0679812
#> [2,] 0.5404181850 0.16550630 0.10968319 0.3005765
#> [3,] 0.0007363151 0.33155625 0.32287918 0.1713006
#> [4,] 0.0178612944 0.05276945 0.01413147 0.4517913
#> 
#> [[4]]
#>            [,1]       [,2]       [,3]       [,4]
#> [1,] 0.27218247 0.08694622 0.03308619 3.14609842
#> [2,] 0.46523765 0.14721639 0.09716663 0.48633870
#> [3,] 0.17169441 0.65324947 0.22460452 0.14188099
#> [4,] 0.06532525 0.09936760 0.07377066 0.02785618
#> 
#> [[5]]
#>            [,1]       [,2]       [,3]        [,4]
#> [1,] 0.02483521 0.07413944 0.26268694 3.002234008
#> [2,] 0.04099351 0.14979742 0.08030862 0.029431448
#> [3,] 0.48333636 0.36179127 0.20963262 0.465826277
#> [4,] 0.15335198 0.14189984 0.18359047 0.003202194
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
#>            [,1]      [,2]      [,3]      [,4]      [,5]     [,6]
#> [1,] 0.00000000 0.0000000 9.0000000 9.0000000 9.0000000 9.000000
#> [2,] 0.02399914 0.0000000 0.0000000 0.0000000 0.0000000 0.000000
#> [3,] 0.00000000 0.1663665 0.0000000 0.0000000 0.0000000 0.000000
#> [4,] 0.00000000 0.0000000 0.3087339 0.0000000 0.0000000 0.000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4511013 0.0000000 0.000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5934687 0.735836
#> 
#> [[2]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 5.0000000 5.0000000 5.0000000 5.0000000
#> [2,] 0.09862958 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.2218143 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.3449991 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4681838 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5913686 0.7145533
#> 
#> [[3]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 5.0000000 5.0000000 5.0000000 5.0000000
#> [2,] 0.06234883 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1810817 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2998146 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4185475 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5372804 0.6560133
#> 
#> [[4]]
#>            [,1]      [,2]       [,3]       [,4]       [,5]       [,6]
#> [1,] 0.00000000 0.0000000 13.0000000 13.0000000 13.0000000 13.0000000
#> [2,] 0.02521585 0.0000000  0.0000000  0.0000000  0.0000000  0.0000000
#> [3,] 0.00000000 0.1784043  0.0000000  0.0000000  0.0000000  0.0000000
#> [4,] 0.00000000 0.0000000  0.3315928  0.0000000  0.0000000  0.0000000
#> [5,] 0.00000000 0.0000000  0.0000000  0.4847813  0.0000000  0.0000000
#> [6,] 0.00000000 0.0000000  0.0000000  0.0000000  0.6379698  0.7911583
#> 
#> [[5]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]     [,6]
#> [1,] 0.00000000 0.0000000 7.0000000 7.0000000 7.0000000 7.000000
#> [2,] 0.07846517 0.0000000 0.0000000 0.0000000 0.0000000 0.000000
#> [3,] 0.00000000 0.1541393 0.0000000 0.0000000 0.0000000 0.000000
#> [4,] 0.00000000 0.0000000 0.2298135 0.0000000 0.0000000 0.000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.3054877 0.0000000 0.000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.3811619 0.456836
#> 
#> [[6]]
#>            [,1]     [,2]      [,3]      [,4]      [,5]     [,6]
#> [1,] 0.00000000 0.000000 7.0000000 7.0000000 7.0000000 7.000000
#> [2,] 0.08783621 0.000000 0.0000000 0.0000000 0.0000000 0.000000
#> [3,] 0.00000000 0.201466 0.0000000 0.0000000 0.0000000 0.000000
#> [4,] 0.00000000 0.000000 0.3150957 0.0000000 0.0000000 0.000000
#> [5,] 0.00000000 0.000000 0.0000000 0.4287255 0.0000000 0.000000
#> [6,] 0.00000000 0.000000 0.0000000 0.0000000 0.5423552 0.655985
#> 
#> [[7]]
#>            [,1]      [,2]       [,3]       [,4]      [,5]       [,6]
#> [1,] 0.00000000 0.0000000 10.0000000 10.0000000 10.000000 10.0000000
#> [2,] 0.08165423 0.0000000  0.0000000  0.0000000  0.000000  0.0000000
#> [3,] 0.00000000 0.2013594  0.0000000  0.0000000  0.000000  0.0000000
#> [4,] 0.00000000 0.0000000  0.3210646  0.0000000  0.000000  0.0000000
#> [5,] 0.00000000 0.0000000  0.0000000  0.4407698  0.000000  0.0000000
#> [6,] 0.00000000 0.0000000  0.0000000  0.0000000  0.560475  0.6801802
#> 
#> [[8]]
#>            [,1]    [,2]      [,3]     [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.00000 7.0000000 7.000000 7.0000000 7.0000000
#> [2,] 0.01943044 0.00000 0.0000000 0.000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.16692 0.0000000 0.000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.00000 0.3144095 0.000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.00000 0.0000000 0.461899 0.0000000 0.0000000
#> [6,] 0.00000000 0.00000 0.0000000 0.000000 0.6093886 0.7568781
#> 
#> [[9]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 8.0000000 8.0000000 8.0000000 8.0000000
#> [2,] 0.07935611 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1722725 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2651889 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.3581054 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.4510218 0.5439382
#> 
#> [[10]]
#>           [,1]      [,2]    [,3]      [,4]      [,5]      [,6]
#> [1,] 0.0000000 0.0000000 9.00000 9.0000000 9.0000000 9.0000000
#> [2,] 0.0273763 0.0000000 0.00000 0.0000000 0.0000000 0.0000000
#> [3,] 0.0000000 0.1704931 0.00000 0.0000000 0.0000000 0.0000000
#> [4,] 0.0000000 0.0000000 0.31361 0.0000000 0.0000000 0.0000000
#> [5,] 0.0000000 0.0000000 0.00000 0.4567268 0.0000000 0.0000000
#> [6,] 0.0000000 0.0000000 0.00000 0.0000000 0.5998436 0.7429605
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
#> [1,] 0.000 2.147 4.488
#> [2,] 0.295 0.000 0.000
#> [3,] 0.000 0.523 0.805

simulate_mpm(
  matU = mats$matU, matF = mats$matF,
  sample_size = 7, split = FALSE
)
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 1.8571429 4.2857143
#> [2,] 0.4285714 0.0000000 0.0000000
#> [3,] 0.0000000 0.8571429 0.5714286
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
#> [1,] 0.0000000 1.4285714 4.8571429
#> [2,] 0.4285714 0.0000000 0.0000000
#> [3,] 0.0000000 0.1428571 0.5714286
#> 
#> , , 2
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 3.0000000 3.8571429
#> [2,] 0.2857143 0.0000000 0.0000000
#> [3,] 0.0000000 0.4285714 0.7142857
#> 
#> , , 3
#> 
#>           [,1]      [,2]     [,3]
#> [1,] 0.0000000 1.8571429 5.571429
#> [2,] 0.4285714 0.0000000 0.000000
#> [3,] 0.0000000 0.7142857 1.000000
#> 
#> , , 4
#> 
#>      [,1]      [,2]      [,3]
#> [1,]    0 1.8571429 4.4285714
#> [2,]    0 0.0000000 0.0000000
#> [3,]    0 0.5714286 0.8571429
#> 
#> , , 5
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.4285714 3.4285714
#> [2,] 0.4285714 0.0000000 0.0000000
#> [3,] 0.0000000 0.7142857 0.7142857
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
