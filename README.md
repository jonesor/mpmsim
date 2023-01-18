
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mpmsim

<!-- badges: start -->
<!-- badges: end -->

`mpmsim` is a tool for generating random or semi-random matrix
population models given a particular archetype, based on life history.

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

Generate single MPMs.

``` r
randomMPM(n_stages = 3, fecundity = 20, archetype = 2)
#>           [,1]       [,2]       [,3]
#> [1,] 0.1971009 0.40656619 17.3016635
#> [2,] 0.1389959 0.03748209  0.1466313
#> [3,] 0.1063780 0.16983129  0.4638856
```

Generate a set of MPMs.

``` r
generate_mpm_set(n = 5, n_stages = 4, fecundity = 8, archetype = 1,
                 lower_lambda = 0.9, upper_lambda = 1.1)
#> [[1]]
#>             [,1]       [,2]       [,3]      [,4]
#> [1,] 0.084835671 0.19845247 0.19485556 8.3006487
#> [2,] 0.421842894 0.07613636 0.01949171 0.1628955
#> [3,] 0.052359268 0.05712192 0.43599505 0.4210052
#> [4,] 0.003895723 0.18924968 0.11959985 0.0521750
#> 
#> [[2]]
#>            [,1]       [,2]        [,3]       [,4]
#> [1,] 0.04120901 0.04848291 0.112390910 3.20770959
#> [2,] 0.29618493 0.27881988 0.453719230 0.06874116
#> [3,] 0.46789844 0.10731462 0.009122404 0.09168118
#> [4,] 0.02267990 0.14520438 0.097356536 0.09257322
#> 
#> [[3]]
#>            [,1]       [,2]       [,3]       [,4]
#> [1,] 0.28607973 0.19594825 0.32344327 12.0457354
#> [2,] 0.07593150 0.17217736 0.16696383  0.2264886
#> [3,] 0.19065039 0.05502933 0.16176871  0.3192714
#> [4,] 0.01903717 0.17209200 0.03446208  0.1803897
#> 
#> [[4]]
#>            [,1]       [,2]       [,3]       [,4]
#> [1,] 0.03243101 0.26701695 0.06173738 4.06127609
#> [2,] 0.11252279 0.16247557 0.35107403 0.15134692
#> [3,] 0.23434593 0.05569025 0.12574771 0.57578458
#> [4,] 0.16843867 0.10024792 0.07448124 0.01131813
#> 
#> [[5]]
#>            [,1]       [,2]      [,3]       [,4]
#> [1,] 0.21357579 0.69752577 0.1016558 3.14320259
#> [2,] 0.21255391 0.08896422 0.2155359 0.37251914
#> [3,] 0.05680686 0.01927643 0.3207602 0.16661732
#> [4,] 0.07408518 0.13618487 0.2191140 0.06633543
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
