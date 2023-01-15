
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mpmsim

<!-- badges: start -->
<!-- badges: end -->

`mpmsim` is a tool for randomly generating matrix population models
given a particular archetype, based on life history.

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
randomMPM(nStage = 2, Fec = 20, addFec = TRUE, archetype = 1)
#>            [,1]        [,2]
#> [1,] 0.06853215 16.51778569
#> [2,] 0.45926855  0.04015291
randomMPM(nStage = 2, Fec = 20, addFec = TRUE, archetype = 2)
#>            [,1]       [,2]
#> [1,] 0.26147678 22.2582935
#> [2,] 0.04290753  0.2370174
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
