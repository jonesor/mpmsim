# Model mortality hazard, survivorship and age-specific survival probability using a mortality model

Generates an actuarial life table based on a defined mortality model.

## Usage

``` r
model_survival(params, age = NULL, model, truncate = 0.01)

model_mortality(params, age = NULL, model, truncate = 0.01)
```

## Arguments

- params:

  Numeric vector representing the parameters of the mortality model.

- age:

  Numeric vector representing age. The default is `NULL`, whereby the
  survival trajectory is modelled from age 0 to the age at which the
  survivorship of the synthetic cohort declines to a threshold defined
  by the `truncate` argument, which has a default of `0.01` (i.e. 1% of
  the cohort remaining alive).

- model:

  A character string specifying the name of the mortality model to be
  used. Options are `gompertz`, `gompertzmakeham`, `exponential`,
  `siler`, `weibull`, and `weibullmakeham`. These names are not
  case-sensitive.

- truncate:

  a value defining how the life table output should be truncated. The
  default is `0.01`, indicating that the life table is truncated so that
  survivorship (`lx`) \> 0.01 (i.e. the age at which 1% of the cohort
  remains alive).

## Value

A dataframe in the form of a lifetable with columns for age (`x`),
hazard (`hx`), survivorship (`lx`) and mortality (`qx`) and survival
probability within interval (`px`).

## Details

The required parameters varies depending on the mortality model. The
parameters are provided as a vector.

\*For `gompertz` and `weibull`, the parameters are `b0`, `b1`. \*For
`gompertzmakeham` and `weibullmakeham` the parameters are `b0`, `b1` and
`C`. \*For `exponential`, the parameter is `C`. \*For `siler`, the
parameters are `a0`, `a1`, `C`, `b0` and `b1`.

Note that the parameters must be provided in the order mentioned here.
`x` represents age.

- Gompertz: \\h_x = b_0 \mathrm{e}^{b_1 x}\\

- Gompertz-Makeham: \\h_x = b_0 \mathrm{e}^{b_1 x} + c\\

- Exponential: \\h_x = c\\

- Siler: \\h_x = a_0 \mathrm{e}^{-a_1 x} + c + b_0 \mathrm{e}^{b_1 x}\\

- Weibull: \\h_x = b_0 b_1 (b_1 x)^{(b_0 - 1)}\\

- Weibull-Makeham: \\h_x = b_0 b_1 (b_1 x)^{(b_0 - 1)} + c\\

In the output, the probability of survival (`px`) (and death (`qx`))
represent the probability of individuals that enter the age interval
\\\[x,x+1\]\\ survive until the end of the interval (or die before the
end of the interval). It is not possible to estimate a value for this in
the final row of the life table (because there is no \\x+1\\ value) and
therefore the input values of `age` (x) may need to be extended to
capture this final interval.

## References

Cox, D.R. & Oakes, D. (1984) Analysis of Survival Data. Chapman and
Hall, London, UK.

Pinder III, J.E., Wiener, J.G. & Smith, M.H. (1978) The Weibull
distribution: a method of summarizing survivorship data. Ecology, 59,
175–179.

Pletcher, S. (1999) Model fitting and hypothesis testing for
age-specific mortality data. Journal of Evolutionary Biology, 12,
430–439.

Siler, W. (1979) A competing-risk model for animal mortality. Ecology,
60, 750–757.

Vaupel, J., Manton, K. & Stallard, E. (1979) The impact of heterogeneity
in individual frailty on the dynamics of mortality. Demography, 16,
439–454.

## See also

[`model_fecundity()`](https://jonesor.github.io/mpmsim/reference/model_fecundity.md)
to model age-specific reproductive output using various functions.

Other trajectories:
[`model_fecundity()`](https://jonesor.github.io/mpmsim/reference/model_fecundity.md)

## Author

Owen Jones <jones@biology.sdu.dk>

## Examples

``` r
model_mortality(params = c(b_0 = 0.1, b_1 = 0.2), model = "Gompertz")
#>     x        hx         lx        qx        px
#> 1   0 0.1000000 1.00000000 0.1051240 0.8948760
#> 2   1 0.1221403 0.89487598 0.1268617 0.8731383
#> 3   2 0.1491825 0.78135045 0.1526972 0.8473028
#> 4   3 0.1822119 0.66204041 0.1832179 0.8167821
#> 5   4 0.2225541 0.54074272 0.2190086 0.7809914
#> 6   5 0.2718282 0.42231542 0.2606027 0.7393973
#> 7   6 0.3320117 0.31225886 0.3084127 0.6915873
#> 8   7 0.4055200 0.21595427 0.3626343 0.6373657
#> 9   8 0.4953032 0.13764186 0.4231275 0.5768725
#> 10  9 0.6049647 0.07940180 0.4892807 0.5107193
#> 11 10 0.7389056 0.04055203 0.5598781 0.4401219
#> 12 11 0.9025013 0.01784784 0.6330059 0.3669941

model_mortality(
  params = c(b_0 = 0.1, b_1 = 0.2, C = 0.1),
  model = "GompertzMakeham",
  truncate = 0.1
)
#>   x        hx        lx        qx        px
#> 1 0 0.2000000 1.0000000 0.1902827 0.8097173
#> 2 1 0.2221403 0.8097173 0.2099518 0.7900482
#> 3 2 0.2491825 0.6397156 0.2333287 0.7666713
#> 4 3 0.2822119 0.4904516 0.2609450 0.7390550
#> 5 4 0.3225541 0.3624707 0.2933298 0.7066702
#> 6 5 0.3718282 0.2561472 0.3309657 0.6690343
#> 7 6 0.4320117 0.1713713 0.3742259 0.6257741
#> 8 7 0.5055200 0.1072397 0.4232876 0.5767124

model_mortality(params = c(c = 0.2), model = "Exponential", age = 0:10)
#>     x  hx        lx        qx        px
#> 1   0 0.2 1.0000000 0.1812692 0.8187308
#> 2   1 0.2 0.8187308 0.1812692 0.8187308
#> 3   2 0.2 0.6703200 0.1812692 0.8187308
#> 4   3 0.2 0.5488116 0.1812692 0.8187308
#> 5   4 0.2 0.4493290 0.1812692 0.8187308
#> 6   5 0.2 0.3678794 0.1812692 0.8187308
#> 7   6 0.2 0.3011942 0.1812692 0.8187308
#> 8   7 0.2 0.2465970 0.1812692 0.8187308
#> 9   8 0.2 0.2018965 0.1812692 0.8187308
#> 10  9 0.2 0.1652989 0.1812692 0.8187308
#> 11 10 0.2 0.1353353        NA        NA

model_mortality(
  params = c(a_0 = 0.1, a_1 = 0.2, C = 0.1, b_0 = 0.1, b_1 = 0.2),
  model = "Siler",
  age = 0:10
)
#>    x        hx         lx        qx        px
#> 1  0 0.3000000 1.00000000 0.2606669 0.7393331
#> 2  1 0.3040134 0.73933313 0.2666366 0.7333634
#> 3  2 0.3162145 0.54219987 0.2786665 0.7213335
#> 4  3 0.3370930 0.39110690 0.2969238 0.7030762
#> 5  4 0.3674870 0.27497795 0.3216226 0.6783774
#> 6  5 0.4086161 0.18653882 0.3529771 0.6470229
#> 7  6 0.4621311 0.12069488 0.3911330 0.6088670
#> 8  7 0.5301797 0.07348713 0.4360763 0.5639237
#> 9  8 0.6154929 0.04144114 0.4875201 0.5124799
#> 10 9 0.7214946 0.02123775 0.5447766 0.4552234

model_mortality(
  params = c(b_0 = 1.4, b_1 = 0.18),
  model = "Weibull"
)
#>     x        hx         lx         qx        px
#> 1   0 0.0000000 1.00000000 0.06148553 0.9385145
#> 2   1 0.1269140 0.93851447 0.13686918 0.8631308
#> 3   2 0.1674640 0.81006076 0.16657160 0.8334284
#> 4   3 0.1969509 0.67512765 0.18857273 0.8114273
#> 5   4 0.2209701 0.54781698 0.20648690 0.7935131
#> 6   5 0.2416003 0.43469995 0.22177479 0.7782252
#> 7   6 0.2598783 0.33829446 0.23520126 0.7647987
#> 8   7 0.2764068 0.25872718 0.24722531 0.7527747
#> 9   8 0.2915718 0.19476327 0.25814734 0.7418527
#> 10  9 0.3056374 0.14448565 0.26817620 0.7318238
#> 11 10 0.3187936 0.10573804 0.27746379 0.7225362
#> 12 11 0.3311819 0.07639956 0.28612450 0.7138755
#> 13 12 0.3429115 0.05453977 0.29424691 0.7057531
#> 14 13 0.3540682 0.03849161 0.30190116 0.6980988
#> 15 14 0.3647210 0.02687095 0.30914389 0.6908561
#> 16 15 0.3749264 0.01856396 0.31602155 0.6839785
#> 17 16 0.3847313 0.01269735 0.32257279 0.6774272

model_mortality(
  params = c(b_0 = 1.1, b_1 = 0.05, c = 0.2),
  model = "WeibullMakeham"
)
#>     x        hx         lx        qx        px
#> 1   0 0.2000000 1.00000000 0.1977871 0.8022129
#> 2   1 0.2407624 0.80221294 0.2151206 0.7848794
#> 3   2 0.2436881 0.62964040 0.2169760 0.7830240
#> 4   3 0.2454959 0.49302353 0.2182027 0.7817973
#> 5   4 0.2468237 0.38544447 0.2191342 0.7808658
#> 6   5 0.2478803 0.30098040 0.2198903 0.7801097
#> 7   6 0.2487612 0.23479772 0.2205292 0.7794708
#> 8   7 0.2495187 0.18301798 0.2210836 0.7789164
#> 9   8 0.2501844 0.14255570 0.2215743 0.7784257
#> 10  9 0.2507790 0.11096903 0.2220149 0.7779851
#> 11 10 0.2513168 0.08633225 0.2224152 0.7775848
#> 12 11 0.2518083 0.06713065 0.2227822 0.7772178
#> 13 12 0.2522610 0.05217514 0.2231213 0.7768787
#> 14 13 0.2526810 0.04053375 0.2234366 0.7765634
#> 15 14 0.2530729 0.03147703 0.2237313 0.7762687
#> 16 15 0.2534403 0.02443463 0.2240082 0.7759918
#> 17 16 0.2537863 0.01896108 0.2242693 0.7757307
#> 18 17 0.2541134 0.01470869 0.2245164 0.7754836
#> 19 18 0.2544236 0.01140635 0.2247511 0.7752489

model_survival(params = c(b_0 = 0.1, b_1 = 0.2), model = "Gompertz")
#>     x        hx         lx        qx        px
#> 1   0 0.1000000 1.00000000 0.1051240 0.8948760
#> 2   1 0.1221403 0.89487598 0.1268617 0.8731383
#> 3   2 0.1491825 0.78135045 0.1526972 0.8473028
#> 4   3 0.1822119 0.66204041 0.1832179 0.8167821
#> 5   4 0.2225541 0.54074272 0.2190086 0.7809914
#> 6   5 0.2718282 0.42231542 0.2606027 0.7393973
#> 7   6 0.3320117 0.31225886 0.3084127 0.6915873
#> 8   7 0.4055200 0.21595427 0.3626343 0.6373657
#> 9   8 0.4953032 0.13764186 0.4231275 0.5768725
#> 10  9 0.6049647 0.07940180 0.4892807 0.5107193
#> 11 10 0.7389056 0.04055203 0.5598781 0.4401219
#> 12 11 0.9025013 0.01784784 0.6330059 0.3669941
```
