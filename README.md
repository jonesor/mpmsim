
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

Generate some MPMs.

``` r
randomMPM(nStage = 4, Fec = 20, archetype = 1)
#>            [,1]       [,2]       [,3]       [,4]
#> [1,] 0.02567980 0.14405647 0.09177158 28.4245054
#> [2,] 0.29585550 0.17424653 0.26756090  0.1034498
#> [3,] 0.18349073 0.43855577 0.20959059  0.2421175
#> [4,] 0.01802149 0.08671069 0.04776346  0.1444609
randomMPM(nStage = 3, Fec = 20, archetype = 2)
#>            [,1]      [,2]       [,3]
#> [1,] 0.47034344 0.1506038 20.0682623
#> [2,] 0.02261655 0.2984267  0.2472501
#> [3,] 0.17466562 0.4482221  0.6671148
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
