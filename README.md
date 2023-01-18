
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

To generate a random matrix population models (MPM) with element values
based on defined life history archetypes you can use `random_mpm`. This
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
advance to later stages. See `?random_mpm` for details, and also examine
Takada et al. (2018).

``` r
random_mpm(n_stages = 3, fecundity = 20, archetype = 2)
#>            [,1]      [,2]        [,3]
#> [1,] 0.04297920 0.4203700 14.08999013
#> [2,] 0.09928825 0.1338935  0.02894109
#> [3,] 0.41494796 0.2994080  0.81189121
```

### Generate a set of random MPMs

Sets of MPMs generated using the above approach can be quickly generated
using `generate_mpm_set`. For example, to generate 5 MPMs from archetype
1 we can use the following code. Users can specify acceptable population
growth for the set of matrices by setting the lower and upper bounds
using the `lower_lambda` and `upper_lambda` arguments. This in life
history analyses because, theoretically, only life histories with lambda
values close to 1 will persist in nature.

``` r
generate_mpm_set(
  n = 5, n_stages = 4, fecundity = 8, archetype = 1,
  lower_lambda = 0.9, upper_lambda = 1.1
)
#> [[1]]
#>             [,1]       [,2]       [,3]       [,4]
#> [1,] 0.151954694 0.36618655 0.33066744 10.2294103
#> [2,] 0.062273017 0.15389930 0.17461886  0.1289330
#> [3,] 0.008823189 0.40898405 0.06367064  0.2562773
#> [4,] 0.036605652 0.06590819 0.28215108  0.1150272
#> 
#> [[2]]
#>            [,1]       [,2]        [,3]       [,4]
#> [1,] 0.30003749 0.12527222 0.083178929 8.44836509
#> [2,] 0.24229012 0.35584784 0.101020384 0.04424346
#> [3,] 0.17545589 0.08580214 0.792182186 0.04514914
#> [4,] 0.05171532 0.00551012 0.004394455 0.30836658
#> 
#> [[3]]
#>            [,1]        [,2]       [,3]      [,4]
#> [1,] 0.01325541 0.537288751 0.05495564 9.0527785
#> [2,] 0.35748517 0.224135541 0.53844599 0.4332646
#> [3,] 0.11854363 0.172158452 0.18878448 0.1952609
#> [4,] 0.02309417 0.003925161 0.04142422 0.1368077
#> 
#> [[4]]
#>            [,1]        [,2]        [,3]      [,4]
#> [1,] 0.55972466 0.037491534 0.281607178 7.1822819
#> [2,] 0.11018831 0.724953072 0.088460058 0.1424905
#> [3,] 0.06685899 0.207605301 0.004231066 0.4065424
#> [4,] 0.00917357 0.004517743 0.283362045 0.2415372
#> 
#> [[5]]
#>             [,1]       [,2]        [,3]       [,4]
#> [1,] 0.154545782 0.31506623 0.652869250 9.24470439
#> [2,] 0.084404937 0.03783642 0.184604383 0.26139254
#> [3,] 0.730747725 0.36420103 0.017552692 0.28101791
#> [4,] 0.006981233 0.08112881 0.003401835 0.09804773
```

### Generate a Leslie matrix

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
    fertility = c(0, 0, rep(adultFert[i], 4)), n_stages = 6, split = FALSE
  )
}

outputMPMs
#> [[1]]
#>           [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.0000000 0.0000000 4.0000000 4.0000000 4.0000000 4.0000000
#> [2,] 0.0231118 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.0000000 0.1441347 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.0000000 0.0000000 0.2651577 0.0000000 0.0000000 0.0000000
#> [5,] 0.0000000 0.0000000 0.0000000 0.3861806 0.0000000 0.0000000
#> [6,] 0.0000000 0.0000000 0.0000000 0.0000000 0.5072035 0.6282265
#> 
#> [[2]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 4.0000000 4.0000000 4.0000000 4.0000000
#> [2,] 0.09908685 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1818381 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2645893 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.3473406 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.4300918 0.5128431
#> 
#> [[3]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 6.0000000 6.0000000 6.0000000 6.0000000
#> [2,] 0.09773877 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.2373579 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.3769771 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.5165962 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.6562154 0.7958345
#> 
#> [[4]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 4.0000000 4.0000000 4.0000000 4.0000000
#> [2,] 0.02348222 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1624863 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.3014905 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4404946 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5794987 0.7185028
#> 
#> [[5]]
#>            [,1]     [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.000000 5.0000000 5.0000000 5.0000000 5.0000000
#> [2,] 0.06741211 0.000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.165301 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.000000 0.2631899 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.000000 0.0000000 0.3610788 0.0000000 0.0000000
#> [6,] 0.00000000 0.000000 0.0000000 0.0000000 0.4589677 0.5568565
#> 
#> [[6]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 9.0000000 9.0000000 9.0000000 9.0000000
#> [2,] 0.02063834 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1100773 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.1995163 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.2889552 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.3783942 0.4678332
#> 
#> [[7]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 2.0000000 2.0000000 2.0000000 2.0000000
#> [2,] 0.02279723 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1525209 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2822445 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4119681 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5416917 0.6714153
#> 
#> [[8]]
#>           [,1]      [,2]      [,3]      [,4]      [,5]     [,6]
#> [1,] 0.0000000 0.0000000 5.0000000 5.0000000 5.0000000 5.000000
#> [2,] 0.0754935 0.0000000 0.0000000 0.0000000 0.0000000 0.000000
#> [3,] 0.0000000 0.1965598 0.0000000 0.0000000 0.0000000 0.000000
#> [4,] 0.0000000 0.0000000 0.3176261 0.0000000 0.0000000 0.000000
#> [5,] 0.0000000 0.0000000 0.0000000 0.4386924 0.0000000 0.000000
#> [6,] 0.0000000 0.0000000 0.0000000 0.0000000 0.5597587 0.680825
#> 
#> [[9]]
#>             [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.000000000 0.0000000 4.0000000 4.0000000 4.0000000 4.0000000
#> [2,] 0.003620279 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.000000000 0.1068147 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.000000000 0.0000000 0.2100092 0.0000000 0.0000000 0.0000000
#> [5,] 0.000000000 0.0000000 0.0000000 0.3132036 0.0000000 0.0000000
#> [6,] 0.000000000 0.0000000 0.0000000 0.0000000 0.4163981 0.5195925
#> 
#> [[10]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 4.0000000 4.0000000 4.0000000 4.0000000
#> [2,] 0.08906701 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.2145504 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.3400337 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.4655171 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5910004 0.7164838
```

### Simulate an MPM using a particular sample size

The idea here is that we can simulate an MPM based on expected
transition rates (survival, fecundity) and the sample sizes. The
expected transition rates are provided as matrices, and sample size is
provided as either a matrix of sample sizes for each element of the
matrix, or as a single value. The function returns a simulated MPM that
has assumed a binomial process for the survival/growth elements, and a
Poisson process for the fecundity elements.

Users can thus expect the simulated MPM to closely reflect the expected
transition rates when sample sizes are large, and that the simulated
matrices become more variable when sample sizes are small.

In this example, I first generate a 3-stage Leslie matrix using
`make_leslie_matrix`. I then pass the U and F matrices from this Leslie
matrix to the `simulate_mpm` function.

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
#> [1,] 0.000 2.184 4.370
#> [2,] 0.307 0.000 0.000
#> [3,] 0.000 0.479 0.818

simulate_mpm(
  matU = mats$matU, matF = mats$matF,
  sample_size = 7, split = FALSE
)
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 3.1428571 3.5714286
#> [2,] 0.2857143 0.0000000 0.0000000
#> [3,] 0.0000000 0.8571429 0.5714286
```

A list of matrices using the same inputs can be generated easily using
`replicate`.

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
#> [1,] 0.0000000 1.4285714 3.428571
#> [2,] 0.1428571 0.0000000 0.000000
#> [3,] 0.0000000 0.4285714 1.000000
#> 
#> , , 2
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.4285714 4.8571429
#> [2,] 0.1428571 0.0000000 0.0000000
#> [3,] 0.0000000 0.5714286 0.8571429
#> 
#> , , 3
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.5714286 4.4285714
#> [2,] 0.2857143 0.0000000 0.0000000
#> [3,] 0.0000000 0.7142857 0.8571429
#> 
#> , , 4
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 1.8571429 4.7142857
#> [2,] 0.4285714 0.0000000 0.0000000
#> [3,] 0.0000000 0.4285714 0.8571429
#> 
#> , , 5
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.4285714 5.1428571
#> [2,] 0.2857143 0.0000000 0.0000000
#> [3,] 0.0000000 0.8571429 0.7142857
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
