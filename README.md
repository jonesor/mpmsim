
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

To generate a random matrix population models (MPM) with element values
based on defined life history archetypes you can use `randomMPM`. This
function draws survival and transition/growth probabilities from a
Dirichlet distribution to ensure that the column totals (including
death) are less than or equal to 1.

Fecundity is included as a single value, or as a vector with a length
equal to the dimensions of the matrix. If it is a single value, it is
placed as a single element on the top right of the matrix. If it is a
vector of length `n_stages` then the fertility vector spans the entire
top row of the matrix.

User can specify `archetype` to constrain the MPMs. For example, in
archetype 2, the survival probability (column sums of the survival
matrix) is constrained to increase monotonically as the individuals
advance to later stages. See `?randomMPM` for details.

``` r
randomMPM(n_stages = 3, fecundity = 20, archetype = 2)
#>            [,1]       [,2]       [,3]
#> [1,] 0.11620921 0.14372774 20.0675600
#> [2,] 0.26576613 0.02757268  0.1633497
#> [3,] 0.00107092 0.42294720  0.5340742
```

Generate a set of MPMs.

Sets of MPMs generated using the above approach can be quickly generated
using `generate_mpm_set`. For example, to generate 5 MPMs from archetype
1 we can use the following code. Users can specify acceptable population
growth for the set of matrices by setting the lower and upper bounds
using the `lower_lambda` and `upper_lambda` arguments. This in life
history analyses because, theoretically, only life histories with lambda
values close to 1 will persist in nature.

``` r
generate_mpm_set(n = 5, n_stages = 4, fecundity = 8, archetype = 1,
                 lower_lambda = 0.9, upper_lambda = 1.1)
#> [[1]]
#>            [,1]       [,2]       [,3]       [,4]
#> [1,] 0.17427067 0.05888230 0.36915383 9.18949098
#> [2,] 0.17606823 0.15757849 0.03750198 0.15840708
#> [3,] 0.46319948 0.08184315 0.40646985 0.44545083
#> [4,] 0.02828567 0.02222508 0.05114579 0.07173967
#> 
#> [[2]]
#>             [,1]       [,2]       [,3]       [,4]
#> [1,] 0.062072760 0.16135076 0.08423174 10.4720553
#> [2,] 0.090329882 0.42104163 0.05752026  0.1638947
#> [3,] 0.149154463 0.01950919 0.19408643  0.0126581
#> [4,] 0.002785221 0.06040652 0.21733491  0.3016201
#> 
#> [[3]]
#>            [,1]        [,2]       [,3]        [,4]
#> [1,] 0.18345612 0.029694371 0.16460823 10.13109203
#> [2,] 0.76676325 0.055000090 0.25289635  0.07938665
#> [3,] 0.01050466 0.191581549 0.21914069  0.17409025
#> [4,] 0.02421943 0.007210633 0.07703888  0.39655141
#> 
#> [[4]]
#>            [,1]       [,2]      [,3]       [,4]
#> [1,] 0.20211588 0.10951441 0.3229090 9.01079706
#> [2,] 0.39851377 0.36250381 0.1745692 0.06012571
#> [3,] 0.18013305 0.04242312 0.2585454 0.22281841
#> [4,] 0.02883082 0.01840708 0.1035100 0.21779493
#> 
#> [[5]]
#>            [,1]      [,2]      [,3]        [,4]
#> [1,] 0.23187421 0.2463346 0.4011290 10.23685933
#> [2,] 0.09216768 0.2968050 0.1765780  0.01328934
#> [3,] 0.08940358 0.0496237 0.1328935  0.29954532
#> [4,] 0.02700473 0.0721664 0.2548938  0.10711660
```

## Generate a Leslie matrix

Generating a Leslie matrix (a matrix where the stages represent discrete
age classes) is handled with the `make_leslie_matrix` function. In a
Leslie matrix survival is always in the lower subdiagonal and the
lower-right-hand corner element, while fertility is shown in the top
row. Both survival and fertility thus have a length equal to the number
of stages in the model.

Users can specify both survival and fertility as either a single value
or a vector of values of length equal to the dimensions of the matrix
model. If these arguments are single values, the value is repeated along
the survival/fertility sequence.

``` r
make_leslie_matrix(survival = seq(0.1, 0.45, length.out = 4), 
                   fertility = c(0,0,2.4,5), n_stages = 4, split = FALSE)
#>      [,1]      [,2]      [,3] [,4]
#> [1,]  0.0 0.0000000 2.4000000 5.00
#> [2,]  0.1 0.0000000 0.0000000 0.00
#> [3,]  0.0 0.2166667 0.0000000 0.00
#> [4,]  0.0 0.0000000 0.3333333 0.45
```

Generating plausible sets of Leslie matrices can then be handled by
repeating the `make_leslie_matrix` command in a loop. For example, in
the following code I produce 10 Leslie matrices with increasing survival
with age.

``` r
juvSurv <- runif(n = 10, min = 0.0, max = 0.1)
adultSurv <- runif(n = 10, min = 0.4, max = 0.8)
adultFert <- rpois(10, 6)

outputMPMs <- NULL
for (i in 1:10) {
  outputMPMs[[i]] <- make_leslie_matrix(
    survival = seq(juvSurv[i], adultSurv[i], length.out = 6),
    fertility = c(0, 0, rep(adultFert[i],4)), n_stages = 6, split = FALSE
  )
}

outputMPMs
#> [[1]]
#>           [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.0000000 0.0000000 3.0000000 3.0000000 3.0000000 3.0000000
#> [2,] 0.0871615 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.0000000 0.2081163 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.0000000 0.0000000 0.3290712 0.0000000 0.0000000 0.0000000
#> [5,] 0.0000000 0.0000000 0.0000000 0.4500261 0.0000000 0.0000000
#> [6,] 0.0000000 0.0000000 0.0000000 0.0000000 0.5709809 0.6919358
#> 
#> [[2]]
#>            [,1]      [,2]      [,3]      [,4]     [,5]      [,6]
#> [1,] 0.00000000 0.0000000 4.0000000 4.0000000 4.000000 4.0000000
#> [2,] 0.09668342 0.0000000 0.0000000 0.0000000 0.000000 0.0000000
#> [3,] 0.00000000 0.1597171 0.0000000 0.0000000 0.000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2227507 0.0000000 0.000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.2857843 0.000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.348818 0.4118516
#> 
#> [[3]]
#>            [,1]      [,2]      [,3]      [,4]     [,5]      [,6]
#> [1,] 0.00000000 0.0000000 6.0000000 6.0000000 6.000000 6.0000000
#> [2,] 0.04743121 0.0000000 0.0000000 0.0000000 0.000000 0.0000000
#> [3,] 0.00000000 0.1804617 0.0000000 0.0000000 0.000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.3134921 0.0000000 0.000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4465226 0.000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.579553 0.7125835
#> 
#> [[4]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 6.0000000 6.0000000 6.0000000 6.0000000
#> [2,] 0.02280794 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1080472 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.1932865 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.2785258 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.3637652 0.4490045
#> 
#> [[5]]
#>            [,1]      [,2]      [,3]     [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 5.0000000 5.000000 5.0000000 5.0000000
#> [2,] 0.05032659 0.0000000 0.0000000 0.000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1829437 0.0000000 0.000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.3155609 0.000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.448178 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.000000 0.5807952 0.7134123
#> 
#> [[6]]
#>            [,1]      [,2]       [,3]       [,4]       [,5]       [,6]
#> [1,] 0.00000000 0.0000000 10.0000000 10.0000000 10.0000000 10.0000000
#> [2,] 0.05155415 0.0000000  0.0000000  0.0000000  0.0000000  0.0000000
#> [3,] 0.00000000 0.1496332  0.0000000  0.0000000  0.0000000  0.0000000
#> [4,] 0.00000000 0.0000000  0.2477123  0.0000000  0.0000000  0.0000000
#> [5,] 0.00000000 0.0000000  0.0000000  0.3457914  0.0000000  0.0000000
#> [6,] 0.00000000 0.0000000  0.0000000  0.0000000  0.4438705  0.5419496
#> 
#> [[7]]
#>            [,1]      [,2]      [,3]      [,4]     [,5]      [,6]
#> [1,] 0.00000000 0.0000000 8.0000000 8.0000000 8.000000 8.0000000
#> [2,] 0.09151553 0.0000000 0.0000000 0.0000000 0.000000 0.0000000
#> [3,] 0.00000000 0.1687794 0.0000000 0.0000000 0.000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2460432 0.0000000 0.000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.3233071 0.000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.400571 0.4778348
#> 
#> [[8]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 6.0000000 6.0000000 6.0000000 6.0000000
#> [2,] 0.09587162 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1626929 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2295142 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.2963356 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.3631569 0.4299782
#> 
#> [[9]]
#>            [,1]     [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.000000 7.0000000 7.0000000 7.0000000 7.0000000
#> [2,] 0.06098503 0.000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.144159 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.000000 0.2273329 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.000000 0.0000000 0.3105068 0.0000000 0.0000000
#> [6,] 0.00000000 0.000000 0.0000000 0.0000000 0.3936807 0.4768547
#> 
#> [[10]]
#>           [,1]      [,2]      [,3]      [,4]      [,5]     [,6]
#> [1,] 0.0000000 0.0000000 8.0000000 8.0000000 8.0000000 8.000000
#> [2,] 0.0755579 0.0000000 0.0000000 0.0000000 0.0000000 0.000000
#> [3,] 0.0000000 0.1577147 0.0000000 0.0000000 0.0000000 0.000000
#> [4,] 0.0000000 0.0000000 0.2398715 0.0000000 0.0000000 0.000000
#> [5,] 0.0000000 0.0000000 0.0000000 0.3220283 0.0000000 0.000000
#> [6,] 0.0000000 0.0000000 0.0000000 0.0000000 0.4041851 0.486342
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
