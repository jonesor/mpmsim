
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
#>           [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.0000000 0.0000000 3.0000000 3.0000000 3.0000000 3.0000000
#> [2,] 0.0656512 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.0000000 0.1763965 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.0000000 0.0000000 0.2871418 0.0000000 0.0000000 0.0000000
#> [5,] 0.0000000 0.0000000 0.0000000 0.3978871 0.0000000 0.0000000
#> [6,] 0.0000000 0.0000000 0.0000000 0.0000000 0.5086323 0.6193776
#> 
#> [[2]]
#>             [,1]       [,2]       [,3]       [,4]       [,5]       [,6]
#> [1,] 0.000000000 0.00000000 12.0000000 12.0000000 12.0000000 12.0000000
#> [2,] 0.008795031 0.00000000  0.0000000  0.0000000  0.0000000  0.0000000
#> [3,] 0.000000000 0.09994633  0.0000000  0.0000000  0.0000000  0.0000000
#> [4,] 0.000000000 0.00000000  0.1910976  0.0000000  0.0000000  0.0000000
#> [5,] 0.000000000 0.00000000  0.0000000  0.2822489  0.0000000  0.0000000
#> [6,] 0.000000000 0.00000000  0.0000000  0.0000000  0.3734002  0.4645515
#> 
#> [[3]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 6.0000000 6.0000000 6.0000000 6.0000000
#> [2,] 0.06423081 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1392641 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2142974 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.2893308 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.3643641 0.4393974
#> 
#> [[4]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 6.0000000 6.0000000 6.0000000 6.0000000
#> [2,] 0.09491101 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1964703 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2980296 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.3995889 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5011482 0.6027075
#> 
#> [[5]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 6.0000000 6.0000000 6.0000000 6.0000000
#> [2,] 0.08240418 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1622303 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2420564 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.3218825 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.4017086 0.4815348
#> 
#> [[6]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]    [,6]
#> [1,] 0.00000000 0.0000000 4.0000000 4.0000000 4.0000000 4.00000
#> [2,] 0.04123266 0.0000000 0.0000000 0.0000000 0.0000000 0.00000
#> [3,] 0.00000000 0.1403901 0.0000000 0.0000000 0.0000000 0.00000
#> [4,] 0.00000000 0.0000000 0.2395476 0.0000000 0.0000000 0.00000
#> [5,] 0.00000000 0.0000000 0.0000000 0.3387051 0.0000000 0.00000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.4378626 0.53702
#> 
#> [[7]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 6.0000000 6.0000000 6.0000000 6.0000000
#> [2,] 0.06229579 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1722117 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2821277 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.3920436 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5019596 0.6118755
#> 
#> [[8]]
#>             [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.000000000 0.0000000 6.0000000 6.0000000 6.0000000 6.0000000
#> [2,] 0.009700667 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.000000000 0.1240653 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.000000000 0.0000000 0.2384299 0.0000000 0.0000000 0.0000000
#> [5,] 0.000000000 0.0000000 0.0000000 0.3527946 0.0000000 0.0000000
#> [6,] 0.000000000 0.0000000 0.0000000 0.0000000 0.4671592 0.5815238
#> 
#> [[9]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 8.0000000 8.0000000 8.0000000 8.0000000
#> [2,] 0.07450128 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.2141854 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.3538696 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4935538 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.6332379 0.7729221
#> 
#> [[10]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]     [,6]
#> [1,] 0.00000000 0.0000000 4.0000000 4.0000000 4.0000000 4.000000
#> [2,] 0.05479254 0.0000000 0.0000000 0.0000000 0.0000000 0.000000
#> [3,] 0.00000000 0.1446912 0.0000000 0.0000000 0.0000000 0.000000
#> [4,] 0.00000000 0.0000000 0.2345899 0.0000000 0.0000000 0.000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.3244886 0.0000000 0.000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.4143873 0.504286
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
#> [1,] 0.000 2.190 4.447
#> [2,] 0.302 0.000 0.000
#> [3,] 0.000 0.492 0.817

simulate_mpm(
  mat_U = mats$mat_U, mat_F = mats$mat_F,
  sample_size = 7, split = FALSE
)
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.0000000 4.7142857
#> [2,] 0.1428571 0.0000000 0.0000000
#> [3,] 0.0000000 0.5714286 0.8571429
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
#> [1,] 0.0000000 2.4285714 4.428571
#> [2,] 0.4285714 0.0000000 0.000000
#> [3,] 0.0000000 0.4285714 1.000000
#> 
#> , , 2
#> 
#>      [,1]      [,2]      [,3]
#> [1,]    0 4.8571429 4.0000000
#> [2,]    0 0.0000000 0.0000000
#> [3,]    0 0.2857143 0.8571429
#> 
#> , , 3
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 3.0000000 3.8571429
#> [2,] 0.4285714 0.0000000 0.0000000
#> [3,] 0.0000000 0.4285714 0.5714286
#> 
#> , , 4
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 1.7142857 4.2857143
#> [2,] 0.1428571 0.0000000 0.0000000
#> [3,] 0.0000000 0.4285714 0.7142857
#> 
#> , , 5
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.1428571 3.7142857
#> [2,] 0.4285714 0.0000000 0.0000000
#> [3,] 0.0000000 0.4285714 0.8571429
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
#> [1,] 0.2324819 0.3666990 10.0960396
#> [2,] 0.3873532 0.2480638  0.3152925
#> [3,] 0.2036706 0.2091546  0.5048013
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
#>              [,1]        [,2]       [,3]       [,4]
#> [1,] 0.1645177342 0.610991891 0.23135344 9.07910321
#> [2,] 0.5890962651 0.224612402 0.07443333 0.04455804
#> [3,] 0.1404268376 0.002383847 0.01612078 0.27835159
#> [4,] 0.0008268506 0.040626823 0.10005081 0.26047600
#> 
#> [[2]]
#>            [,1]       [,2]       [,3]       [,4]
#> [1,] 0.10621097 0.07873622 0.45339792 3.19323419
#> [2,] 0.16772579 0.08741431 0.14073814 0.12075058
#> [3,] 0.01222886 0.02487642 0.04265495 0.47938159
#> [4,] 0.17165145 0.18727777 0.04457954 0.07714673
#> 
#> [[3]]
#>              [,1]      [,2]       [,3]       [,4]
#> [1,] 0.3221727570 0.2309754 0.29278448 10.1424508
#> [2,] 0.0327679410 0.1082533 0.23901568  0.1102037
#> [3,] 0.0004149306 0.2119596 0.06944177  0.3281222
#> [4,] 0.0356489585 0.3080424 0.20516812  0.1506851
#> 
#> [[4]]
#>            [,1]       [,2]       [,3]       [,4]
#> [1,] 0.04722622 0.28630310 0.08148105 4.28328527
#> [2,] 0.30373260 0.02308337 0.69139996 0.41573741
#> [3,] 0.22356493 0.20474291 0.02400055 0.02246726
#> [4,] 0.04988378 0.03127154 0.15882817 0.17982528
#> 
#> [[5]]
#>            [,1]        [,2]       [,3]       [,4]
#> [1,] 0.33033325 0.004459272 0.08082837 5.10963730
#> [2,] 0.07219818 0.161151362 0.05449363 0.13088889
#> [3,] 0.04546335 0.098430565 0.06929914 0.07032627
#> [4,] 0.11061477 0.324820172 0.05826027 0.04783397
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
