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
#> 1   0 0.1000000 1.00000000 0.1047940 0.8952060
#> 2   1 0.1221403 0.89520604 0.1264684 0.8735316
#> 3   2 0.1491825 0.78199076 0.1522310 0.8477690
#> 4   3 0.1822119 0.66294755 0.1826689 0.8173311
#> 5   4 0.2225541 0.54184762 0.2183674 0.7816326
#> 6   5 0.2718282 0.42352577 0.2598612 0.7401388
#> 7   6 0.3320117 0.31346785 0.3075654 0.6924346
#> 8   7 0.4055200 0.21705598 0.3616804 0.6383196
#> 9   8 0.4953032 0.13855108 0.4220729 0.5779271
#> 10  9 0.6049647 0.08007243 0.4881401 0.5118599
#> 11 10 0.7389056 0.04098586 0.5586772 0.4413228
#> 12 11 0.9025013 0.01808800 0.6317825 0.3682175

model_mortality(
  params = c(b_0 = 0.1, b_1 = 0.2, C = 0.1),
  model = "GompertzMakeham",
  truncate = 0.1
)
#>   x        hx        lx        qx        px
#> 1 0 0.2000000 1.0000000 0.1899841 0.8100159
#> 2 1 0.2221403 0.8100159 0.2095959 0.7904041
#> 3 2 0.2491825 0.6402399 0.2329069 0.7670931
#> 4 3 0.2822119 0.4911236 0.2604483 0.7395517
#> 5 4 0.3225541 0.3632113 0.2927496 0.7072504
#> 6 5 0.3718282 0.2568814 0.3302947 0.6697053
#> 7 6 0.4320117 0.1720348 0.3734593 0.6265407
#> 8 7 0.5055200 0.1077868 0.4224246 0.5775754

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
#> 1  0 0.3000000 1.00000000 0.2601709 0.7398291
#> 2  1 0.3040134 0.73982915 0.2661248 0.7338752
#> 3  2 0.3162145 0.54294225 0.2781235 0.7218765
#> 4  3 0.3370930 0.39193723 0.2963347 0.7036653
#> 5  4 0.3674870 0.27579264 0.3209736 0.6790264
#> 6  5 0.4086161 0.18727050 0.3522563 0.6477437
#> 7  6 0.4621311 0.12130329 0.3903316 0.6096684
#> 8  7 0.5301797 0.07395478 0.4351903 0.5648097
#> 9  8 0.6154929 0.04177037 0.4865519 0.5134481
#> 10 9 0.7214946 0.02144692 0.5437371 0.4562629

model_mortality(
  params = c(b_0 = 1.4, b_1 = 0.18),
  model = "Weibull"
)
#>     x        hx         lx         qx        px
#> 1   0 0.0000000 1.00000000 0.08666529 0.9133347
#> 2   1 0.1269140 0.91333471 0.13807022 0.8619298
#> 3   2 0.1674640 0.78723039 0.16706809 0.8329319
#> 4   3 0.1969509 0.65570931 0.18885258 0.8111474
#> 5   4 0.2209701 0.53187691 0.20666935 0.7933307
#> 6   5 0.2416003 0.42195426 0.22190437 0.7780956
#> 7   6 0.2598783 0.32832076 0.23529864 0.7647014
#> 8   7 0.2764068 0.25106733 0.24730150 0.7526985
#> 9   8 0.2915718 0.18897800 0.25820877 0.7417912
#> 10  9 0.3056374 0.14018223 0.26822690 0.7317731
#> 11 10 0.3187936 0.10258158 0.27750644 0.7224936
#> 12 11 0.3311819 0.07411453 0.28616093 0.7138391
#> 13 12 0.3429115 0.05290585 0.29427842 0.7057216
#> 14 13 0.3540682 0.03733680 0.30192871 0.6980713
#> 15 14 0.3647210 0.02606375 0.30916820 0.6908318
#> 16 15 0.3749264 0.01800567 0.31604319 0.6839568
#> 17 16 0.3847313 0.01231510 0.32259218 0.6774078

model_mortality(
  params = c(b_0 = 1.1, b_1 = 0.05, c = 0.2),
  model = "WeibullMakeham"
)
#>     x        hx         lx        qx        px
#> 1   0 0.2000000 1.00000000 0.2110535 0.7889465
#> 2   1 0.2407624 0.78894654 0.2152390 0.7847610
#> 3   2 0.2436881 0.61913445 0.2170189 0.7829811
#> 4   3 0.2454959 0.48477055 0.2182251 0.7817749
#> 5   4 0.2468237 0.37898146 0.2191480 0.7808520
#> 6   5 0.2478803 0.29592843 0.2198997 0.7801003
#> 7   6 0.2487612 0.23085385 0.2205360 0.7794640
#> 8   7 0.2495187 0.17994227 0.2210888 0.7789112
#> 9   8 0.2501844 0.14015905 0.2215784 0.7784216
#> 10  9 0.2507790 0.10910284 0.2220182 0.7779818
#> 11 10 0.2513168 0.08488002 0.2224179 0.7775821
#> 12 11 0.2518083 0.06600119 0.2227845 0.7772155
#> 13 12 0.2522610 0.05129715 0.2231232 0.7768768
#> 14 13 0.2526810 0.03985156 0.2234382 0.7765618
#> 15 14 0.2530729 0.03094720 0.2237328 0.7762672
#> 16 15 0.2534403 0.02402330 0.2240095 0.7759905
#> 17 16 0.2537863 0.01864185 0.2242704 0.7757296
#> 18 17 0.2541134 0.01446103 0.2245174 0.7754826
#> 19 18 0.2544236 0.01121428 0.2247520 0.7752480

model_survival(params = c(b_0 = 0.1, b_1 = 0.2), model = "Gompertz")
#>     x        hx         lx        qx        px
#> 1   0 0.1000000 1.00000000 0.1047940 0.8952060
#> 2   1 0.1221403 0.89520604 0.1264684 0.8735316
#> 3   2 0.1491825 0.78199076 0.1522310 0.8477690
#> 4   3 0.1822119 0.66294755 0.1826689 0.8173311
#> 5   4 0.2225541 0.54184762 0.2183674 0.7816326
#> 6   5 0.2718282 0.42352577 0.2598612 0.7401388
#> 7   6 0.3320117 0.31346785 0.3075654 0.6924346
#> 8   7 0.4055200 0.21705598 0.3616804 0.6383196
#> 9   8 0.4953032 0.13855108 0.4220729 0.5779271
#> 10  9 0.6049647 0.08007243 0.4881401 0.5118599
#> 11 10 0.7389056 0.04098586 0.5586772 0.4413228
#> 12 11 0.9025013 0.01808800 0.6317825 0.3682175
```
