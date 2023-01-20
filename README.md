
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
#>            [,1]       [,2]       [,3]
#> [1,] 0.06681077 0.44310794 20.0991912
#> [2,] 0.14291537 0.07835595  0.1071440
#> [3,] 0.34585609 0.32219084  0.6446542
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
#>            [,1]      [,2]        [,3]      [,4]
#> [1,] 0.47615296 0.1640520 0.077288092 4.0724199
#> [2,] 0.31748144 0.3690030 0.095624988 0.3116655
#> [3,] 0.09267518 0.2385501 0.225962344 0.3207601
#> [4,] 0.02495483 0.1565962 0.002010066 0.2360088
#> 
#> [[2]]
#>            [,1]       [,2]      [,3]       [,4]
#> [1,] 0.01532492 0.15189309 0.1753012 4.16153191
#> [2,] 0.25443577 0.61135185 0.0296407 0.14418805
#> [3,] 0.02341618 0.06594964 0.2068634 0.13434047
#> [4,] 0.07631327 0.05689800 0.3866793 0.09414428
#> 
#> [[3]]
#>            [,1]       [,2]       [,3]       [,4]
#> [1,] 0.37669343 0.26772493 0.34556059 5.35978969
#> [2,] 0.27216052 0.03003604 0.04994834 0.28624030
#> [3,] 0.01334549 0.09085876 0.03729242 0.22406641
#> [4,] 0.03117433 0.19170200 0.34621964 0.04189687
#> 
#> [[4]]
#>             [,1]      [,2]       [,3]       [,4]
#> [1,] 0.628592269 0.3043999 0.08385381 9.26316833
#> [2,] 0.042145553 0.1910208 0.34285635 0.14407589
#> [3,] 0.025206842 0.2963400 0.31799175 0.09840636
#> [4,] 0.006696841 0.1441207 0.10631229 0.09581372
#> 
#> [[5]]
#>            [,1]      [,2]       [,3]        [,4]
#> [1,] 0.02818701 0.1716045 0.13949021 10.02676035
#> [2,] 0.08549382 0.2986216 0.23375758  0.73680542
#> [3,] 0.19994477 0.2677951 0.31368833  0.07562312
#> [4,] 0.01015360 0.0827719 0.04768018  0.04092646
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
#> [2,] 0.06344449 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1921847 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.3209249 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4496651 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5784053 0.7071455
#> 
#> [[2]]
#>            [,1]      [,2]     [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 6.000000 6.0000000 6.0000000 6.0000000
#> [2,] 0.07887875 0.0000000 0.000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.2197414 0.000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.360604 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.000000 0.5014666 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.000000 0.0000000 0.6423293 0.7831919
#> 
#> [[3]]
#>             [,1]     [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.000000000 0.000000 3.0000000 3.0000000 3.0000000 3.0000000
#> [2,] 0.003407594 0.000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.000000000 0.151843 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.000000000 0.000000 0.3002783 0.0000000 0.0000000 0.0000000
#> [5,] 0.000000000 0.000000 0.0000000 0.4487137 0.0000000 0.0000000
#> [6,] 0.000000000 0.000000 0.0000000 0.0000000 0.5971491 0.7455844
#> 
#> [[4]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 9.0000000 9.0000000 9.0000000 9.0000000
#> [2,] 0.00286504 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1404709 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2780767 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4156826 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5532884 0.6908942
#> 
#> [[5]]
#>           [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.0000000 0.0000000 4.0000000 4.0000000 4.0000000 4.0000000
#> [2,] 0.0462455 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.0000000 0.1881875 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.0000000 0.0000000 0.3301295 0.0000000 0.0000000 0.0000000
#> [5,] 0.0000000 0.0000000 0.0000000 0.4720716 0.0000000 0.0000000
#> [6,] 0.0000000 0.0000000 0.0000000 0.0000000 0.6140136 0.7559556
#> 
#> [[6]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 6.0000000 6.0000000 6.0000000 6.0000000
#> [2,] 0.05628541 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1979251 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.3395649 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4812046 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.6228443 0.7644841
#> 
#> [[7]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 7.0000000 7.0000000 7.0000000 7.0000000
#> [2,] 0.08465516 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.2109595 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.3372639 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4635682 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5898726 0.7161769
#> 
#> [[8]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 9.0000000 9.0000000 9.0000000 9.0000000
#> [2,] 0.02595451 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1179125 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2098706 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.3018286 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.3937867 0.4857447
#> 
#> [[9]]
#>            [,1]     [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.000000 2.0000000 2.0000000 2.0000000 2.0000000
#> [2,] 0.02503694 0.000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.118461 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.000000 0.2118851 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.000000 0.0000000 0.3053091 0.0000000 0.0000000
#> [6,] 0.00000000 0.000000 0.0000000 0.0000000 0.3987332 0.4921573
#> 
#> [[10]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 3.0000000 3.0000000 3.0000000 3.0000000
#> [2,] 0.03820013 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1775295 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.3168588 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4561882 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5955176 0.7348469
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
#> [1,] 0.000 2.138 4.453
#> [2,] 0.305 0.000 0.000
#> [3,] 0.000 0.498 0.779

simulate_mpm(
  matU = mats$matU, matF = mats$matF,
  sample_size = 7, split = FALSE
)
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.0000000 4.8571429
#> [2,] 0.4285714 0.0000000 0.0000000
#> [3,] 0.0000000 0.7142857 0.5714286
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
#>           [,1]      [,2]     [,3]
#> [1,] 0.0000000 1.7142857 3.857143
#> [2,] 0.1428571 0.0000000 0.000000
#> [3,] 0.0000000 0.5714286 1.000000
#> 
#> , , 2
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 3.0000000 4.4285714
#> [2,] 0.2857143 0.0000000 0.0000000
#> [3,] 0.0000000 0.4285714 0.7142857
#> 
#> , , 3
#> 
#>           [,1]      [,2]     [,3]
#> [1,] 0.0000000 3.5714286 4.857143
#> [2,] 0.2857143 0.0000000 0.000000
#> [3,] 0.0000000 0.5714286 1.000000
#> 
#> , , 4
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 3.1428571 4.7142857
#> [2,] 0.1428571 0.0000000 0.0000000
#> [3,] 0.0000000 0.5714286 0.7142857
#> 
#> , , 5
#> 
#>           [,1]      [,2]     [,3]
#> [1,] 0.0000000 2.5714286 3.714286
#> [2,] 0.2857143 0.0000000 0.000000
#> [3,] 0.0000000 0.2857143 1.000000
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
