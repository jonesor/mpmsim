
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
random_mpm(n_stages = 3, fecundity = 20, archetype = 2)
#>            [,1]      [,2]        [,3]
#> [1,] 0.13856470 0.1094323 21.51479653
#> [2,] 0.05942948 0.3154578  0.15796859
#> [3,] 0.39408915 0.2221478  0.06740558
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
#>            [,1]        [,2]       [,3]       [,4]
#> [1,] 0.19441019 0.101868588 0.27856577 4.38730882
#> [2,] 0.11199035 0.007396034 0.13080709 0.06325692
#> [3,] 0.30228032 0.393344785 0.34379230 0.17189456
#> [4,] 0.01857974 0.355972122 0.06155679 0.03595146
#> 
#> [[2]]
#>            [,1]        [,2]       [,3]       [,4]
#> [1,] 0.16087025 0.007965866 0.30831536 6.04174993
#> [2,] 0.04839423 0.001410582 0.02679914 0.16234035
#> [3,] 0.03503225 0.627916411 0.13506866 0.09616047
#> [4,] 0.06162356 0.174297009 0.24419545 0.32005717
#> 
#> [[3]]
#>            [,1]       [,2]       [,3]       [,4]
#> [1,] 0.14238183 0.33471816 0.56824473 5.37076905
#> [2,] 0.09982341 0.15877107 0.02511372 0.30586225
#> [3,] 0.46106713 0.07950218 0.35913850 0.04806223
#> [4,] 0.02282255 0.25059710 0.02002908 0.04884638
#> 
#> [[4]]
#>            [,1]       [,2]       [,3]       [,4]
#> [1,] 0.01556247 0.17848857 0.07421000 3.35419954
#> [2,] 0.09403416 0.25544420 0.48483778 0.37035721
#> [3,] 0.31807333 0.24239537 0.34008386 0.01753869
#> [4,] 0.22072016 0.01423263 0.02159969 0.15466707
#> 
#> [[5]]
#>            [,1]       [,2]        [,3]      [,4]
#> [1,] 0.50941327 0.06773736 0.383812992 9.2388899
#> [2,] 0.03033213 0.53020963 0.007931427 0.2518594
#> [3,] 0.06899417 0.15395948 0.271587092 0.1747808
#> [4,] 0.02293426 0.05392704 0.010618526 0.3140571
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
#> [1,] 0.0000000 0.0000000 5.0000000 5.0000000 5.0000000 5.0000000
#> [2,] 0.0795325 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.0000000 0.2050049 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.0000000 0.0000000 0.3304773 0.0000000 0.0000000 0.0000000
#> [5,] 0.0000000 0.0000000 0.0000000 0.4559497 0.0000000 0.0000000
#> [6,] 0.0000000 0.0000000 0.0000000 0.0000000 0.5814221 0.7068945
#> 
#> [[2]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 5.0000000 5.0000000 5.0000000 5.0000000
#> [2,] 0.05343046 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1642391 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2750478 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.3858565 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.4966652 0.6074739
#> 
#> [[3]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 5.0000000 5.0000000 5.0000000 5.0000000
#> [2,] 0.05697604 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1309042 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2048323 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.2787605 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.3526886 0.4266168
#> 
#> [[4]]
#>          [,1]     [,2]     [,3]     [,4]     [,5]     [,6]
#> [1,] 0.000000 0.000000 1.000000 1.000000 1.000000 1.000000
#> [2,] 0.033584 0.000000 0.000000 0.000000 0.000000 0.000000
#> [3,] 0.000000 0.149089 0.000000 0.000000 0.000000 0.000000
#> [4,] 0.000000 0.000000 0.264594 0.000000 0.000000 0.000000
#> [5,] 0.000000 0.000000 0.000000 0.380099 0.000000 0.000000
#> [6,] 0.000000 0.000000 0.000000 0.000000 0.495604 0.611109
#> 
#> [[5]]
#>           [,1]      [,2]      [,3]     [,4]      [,5]      [,6]
#> [1,] 0.0000000 0.0000000 5.0000000 5.000000 5.0000000 5.0000000
#> [2,] 0.0828996 0.0000000 0.0000000 0.000000 0.0000000 0.0000000
#> [3,] 0.0000000 0.2017187 0.0000000 0.000000 0.0000000 0.0000000
#> [4,] 0.0000000 0.0000000 0.3205379 0.000000 0.0000000 0.0000000
#> [5,] 0.0000000 0.0000000 0.0000000 0.439357 0.0000000 0.0000000
#> [6,] 0.0000000 0.0000000 0.0000000 0.000000 0.5581762 0.6769953
#> 
#> [[6]]
#>             [,1]      [,2]      [,3]      [,4]      [,5]     [,6]
#> [1,] 0.000000000 0.0000000 9.0000000 9.0000000 9.0000000 9.000000
#> [2,] 0.006583689 0.0000000 0.0000000 0.0000000 0.0000000 0.000000
#> [3,] 0.000000000 0.1061271 0.0000000 0.0000000 0.0000000 0.000000
#> [4,] 0.000000000 0.0000000 0.2056706 0.0000000 0.0000000 0.000000
#> [5,] 0.000000000 0.0000000 0.0000000 0.3052141 0.0000000 0.000000
#> [6,] 0.000000000 0.0000000 0.0000000 0.0000000 0.4047575 0.504301
#> 
#> [[7]]
#>            [,1]      [,2]      [,3]     [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 5.0000000 5.000000 5.0000000 5.0000000
#> [2,] 0.09874068 0.0000000 0.0000000 0.000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.2079698 0.0000000 0.000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.3171989 0.000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.426428 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.000000 0.5356572 0.6448863
#> 
#> [[8]]
#>            [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 9.0000000 9.0000000 9.0000000 9.0000000
#> [2,] 0.01161575 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1347412 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.2578667 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.0000000 0.3809922 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.0000000 0.0000000 0.5041177 0.6272432
#> 
#> [[9]]
#>             [,1]      [,2]      [,3]      [,4]      [,5]      [,6]
#> [1,] 0.000000000 0.0000000 4.0000000 4.0000000 4.0000000 4.0000000
#> [2,] 0.002087788 0.0000000 0.0000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.000000000 0.1214714 0.0000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.000000000 0.0000000 0.2408549 0.0000000 0.0000000 0.0000000
#> [5,] 0.000000000 0.0000000 0.0000000 0.3602385 0.0000000 0.0000000
#> [6,] 0.000000000 0.0000000 0.0000000 0.0000000 0.4796221 0.5990056
#> 
#> [[10]]
#>            [,1]      [,2]     [,3]      [,4]      [,5]      [,6]
#> [1,] 0.00000000 0.0000000 7.000000 7.0000000 7.0000000 7.0000000
#> [2,] 0.02605249 0.0000000 0.000000 0.0000000 0.0000000 0.0000000
#> [3,] 0.00000000 0.1194622 0.000000 0.0000000 0.0000000 0.0000000
#> [4,] 0.00000000 0.0000000 0.212872 0.0000000 0.0000000 0.0000000
#> [5,] 0.00000000 0.0000000 0.000000 0.3062817 0.0000000 0.0000000
#> [6,] 0.00000000 0.0000000 0.000000 0.0000000 0.3996914 0.4931012
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
#> [1,] 0.000 2.193 4.376
#> [2,] 0.324 0.000 0.000
#> [3,] 0.000 0.520 0.813

simulate_mpm(
  matU = mats$matU, matF = mats$matF,
  sample_size = 7, split = FALSE
)
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.2857143 4.7142857
#> [2,] 0.2857143 0.0000000 0.0000000
#> [3,] 0.0000000 0.1428571 0.8571429
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
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.0000000 4.4285714
#> [2,] 0.4285714 0.0000000 0.0000000
#> [3,] 0.0000000 0.7142857 0.7142857
#> 
#> , , 2
#> 
#>           [,1]      [,2]     [,3]
#> [1,] 0.0000000 2.0000000 2.857143
#> [2,] 0.4285714 0.0000000 0.000000
#> [3,] 0.0000000 0.4285714 1.000000
#> 
#> , , 3
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 1.4285714 5.4285714
#> [2,] 0.2857143 0.0000000 0.0000000
#> [3,] 0.0000000 0.5714286 0.5714286
#> 
#> , , 4
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 1.7142857 4.4285714
#> [2,] 0.2857143 0.0000000 0.0000000
#> [3,] 0.0000000 0.7142857 0.8571429
#> 
#> , , 5
#> 
#>           [,1]      [,2]      [,3]
#> [1,] 0.0000000 2.5714286 3.1428571
#> [2,] 0.4285714 0.0000000 0.0000000
#> [3,] 0.0000000 0.4285714 0.7142857
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
