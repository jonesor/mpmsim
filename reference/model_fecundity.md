# Model reproductive output with age using set functional forms

This function computes reproductive output (often referred to as
fertility in human demography and fecundity in population biology) based
on the logistic, step, von Bertalanffy, Hadwiger, and normal models. The
logistic model assumes that reproductive output increases sigmoidally
with age from maturity until a maximum is reached. The step model
assumes that reproductive output is zero before the age of maturity and
then remains constant. The von Bertalanffy model assumes that, after
maturity, reproductive output increases asymptotically with age until a
maximum is reached. In this formulation, the model is set up so that
reproductive output is 0 at the 'age of maturity - 1', and increases
from that point. The Hadwiger model, while originally intended to model
human fertility with a characteristic hump-shaped curve, is applied here
to model fecundity (actual offspring production). For all models, the
output ensures that reproductive output is zero before the age at
maturity.

## Usage

``` r
model_fecundity(params, age = NULL, maturity = 0, model = "logistic")

model_reproduction(params, age = NULL, maturity = 0, model = "logistic")

model_fertility(params, age = NULL, maturity = 0, model = "logistic")
```

## Arguments

- params:

  A numeric vector of parameters for the selected model. The number and
  meaning of parameters depend on the selected model.

- age:

  A numeric vector representing age. For use in creation of MPMs and
  life tables, these should be integers.

- maturity:

  A non-negative numeric value indicating the age at maturity. Whatever
  model is used, the reproductive output is forced to be 0 below the age
  of maturity.

- model:

  A character string specifying the model to use. Must be one of
  "logistic", "step", "vonbertalanffy","normal" or "hadwiger".

## Value

A numeric vector representing the computed reproductive output values.

## Details

The required parameters varies depending on the model used. The
parameters are provided as a vector and the parameters must be provided
in the order mentioned here.

- Logistic: \\f_x = A / (1 + exp(-k (x - x_m)))\\

- Step: \\f_x= \begin{cases} A, x \geq m \\ 0, x \< m \end{cases}\\

- von Bertalanffy: \\f_x = A (1 - exp(-k (x - x_0)))\\

- Normal: \\f_x = A \times \exp\left(
  -\frac{1}{2}\left(\frac{x-\mu}{\sigma}\right)^{2}\\\right)\\

- Hadwiger: \\f_x = \frac{ab}{C} \left (\frac{C}{x} \right )
  ^\frac{3}{2} \exp \left \\ -b^2 \left ( \frac{C}{x}+\frac{x}{C}-2
  \right ) \right \\\\

## References

Bertalanffy, L. von (1938) A quantitative theory of organic growth
(inquiries on growth laws. II). Human Biology 10:181–213.

Peristera, P. & Kostaki, A. (2007) Modeling fertility in modern
populations. Demographic Research. 16. Article 6, 141-194
[doi:10.4054/DemRes.2007.16.6](https://doi.org/10.4054/DemRes.2007.16.6)

## See also

[`model_mortality()`](https://jonesor.github.io/mpmsim/reference/model_survival.md)
to model age-specific survival using mortality models.

Other trajectories:
[`model_survival()`](https://jonesor.github.io/mpmsim/reference/model_survival.md)

## Author

Owen Jones <jones@biology.sdu.dk>

## Examples

``` r
# Compute reproductive output using the step model
model_fecundity(age = 0:20, params = c(A = 10), maturity = 2, model = "step")
#>  [1]  0  0 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10

# Compute reproductive output using the logistic model
model_fecundity(
  age = 0:20, params = c(A = 10, k = 0.5, x_m = 8), maturity =
    0, model = "logistic"
)
#>  [1] 0.1798621 0.2931223 0.4742587 0.7585818 1.1920292 1.8242552 2.6894142
#>  [8] 3.7754067 5.0000000 6.2245933 7.3105858 8.1757448 8.8079708 9.2414182
#> [15] 9.5257413 9.7068777 9.8201379 9.8901306 9.9330715 9.9592986 9.9752738

# Compute reproductive output using the von Bertalanffy model
model_fecundity(
  age = 0:20, params = c(A = 10, k = .3), maturity = 2, model =
    "vonbertalanffy"
)
#>  [1] 0.000000 0.000000 2.591818 4.511884 5.934303 6.988058 7.768698 8.347011
#>  [9] 8.775436 9.092820 9.327945 9.502129 9.631168 9.726763 9.797581 9.850044
#> [17] 9.888910 9.917703 9.939033 9.954834 9.966540

# Compute reproductive output using the normal model
model_fecundity(
  age = 0:20, params = c(A = 10, mu = 4, sd = 2), maturity = 0,
  model = "normal"
)
#>  [1] 1.353353e+00 3.246525e+00 6.065307e+00 8.824969e+00 1.000000e+01
#>  [6] 8.824969e+00 6.065307e+00 3.246525e+00 1.353353e+00 4.393693e-01
#> [11] 1.110900e-01 2.187491e-02 3.354626e-03 4.006530e-04 3.726653e-05
#> [16] 2.699579e-06 1.522998e-07 6.691586e-09 2.289735e-10 6.101937e-12
#> [21] 1.266417e-13

# Compute reproductive output using the Hadwiger model
model_fecundity(
  age = 0:50, params = c(a = 0.91, b = 3.85, C = 29.78),
  maturity = 0, model = "hadwiger"
)
#>  [1]  0.000000e+00 1.722961e-178  2.632756e-83  7.775444e-52  2.900424e-36
#>  [6]  4.854202e-27  5.511959e-21  9.752061e-17  1.285955e-13  3.012210e-11
#> [11]  2.109246e-09  6.146616e-08  9.291611e-07  8.485057e-06  5.218334e-05
#> [16]  2.340447e-04  8.125653e-04  2.285572e-03  5.396092e-03  1.099593e-02
#> [21]  1.977597e-02  3.196159e-02  4.710896e-02  6.409793e-02  8.132898e-02
#> [26]  9.704998e-02  1.097012e-01  1.181803e-01  1.219739e-01  1.211525e-01
#> [31]  1.162609e-01  1.081542e-01  9.782452e-02  8.625345e-02  7.430620e-02
#> [36]  6.267207e-02  5.184481e-02  4.213231e-02  3.368422e-02  2.652753e-02
#> [41]  2.060288e-02  1.579689e-02  1.196842e-02  8.967956e-03  6.650857e-03
#> [46]  4.885343e-03  3.556515e-03  2.567565e-03  1.839156e-03  1.307766e-03
#> [51]  9.235335e-04

model_reproduction(age = 0:20, params = c(A = 10), maturity = 2, model = "step")
#>  [1]  0  0 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10
model_fertility(age = 0:20, params = c(A = 10), maturity = 2, model = "step")
#>  [1]  0  0 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10
```
