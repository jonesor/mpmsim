# Changelog

## mpmsim 3.3.0

CRAN release: 2026-04-24

- Fixed typo in
  [`calculate_errors()`](https://jonesor.github.io/mpmsim/reference/calculate_errors.md):
  the `mat_U_error` element in the returned list was incorrectly named
  `,mat_U_error` when `type = "sem"`, causing `NULL` to be returned on
  access.
- Fixed broken vectorisation in
  [`driven_vital_rate()`](https://jonesor.github.io/mpmsim/reference/driven_vital_rate.md):
  conditions `length(slope > 1)` and `length(error_sd > 1)` were always
  evaluating to `TRUE` regardless of input, preventing correct handling
  of matrix inputs.
- Fixed wrong parameter row indices in
  [`rand_leslie_set()`](https://jonesor.github.io/mpmsim/reference/rand_leslie_set.md)
  for the Siler mortality model (`b_0` and `b_1` were drawn from the
  same ranges as `a_0` and `a_1`) and for multi-parameter fecundity
  models (`logistic`, `vonBertalanffy`, `normal`, `hadwiger`), where all
  parameters were incorrectly drawn from the first row of
  `fecundity_params`.
- Removed orphaned expression in internal function
  `add_mpm_error_indiv()` that had no effect.

## mpmsim 3.2.1

CRAN release: 2025-06-05

- minor bug fixes.

## mpmsim 3.2.0

CRAN release: 2025-03-06

- minor bug fixes and documentation improvements.
- removed deprecated functions `generate_mpm_set()` and `random_mpm()`

## mpmsim 3.1.0

CRAN release: 2024-10-12

- Added function synonym:
  [`model_reproduction()`](https://jonesor.github.io/mpmsim/reference/model_fecundity.md)
  is synonymous with `model_fertility` and `model_fecundity`.
- Improved documentation including to the three vignettes focussing on
  Leslie models, Lefkovitch models, and error propagation respectively.
- Fixed minor typographical errors in other documentation.

## mpmsim 3.0.0

CRAN release: 2024-07-01

- When sets of matrices are returned as `CompadreDB` objects, the
  archetype (Lefkovitch) or model parameters (Leslie), are now included
  as metadata.
- Added function
  [`rand_leslie_set()`](https://jonesor.github.io/mpmsim/reference/rand_leslie_set.md)
  to generate sets of Leslie matrices where the parameters of the
  constituent mortality and fertility functions are drawn randomly from
  defined distributions. The function returns a `CompadreDB` object by
  default, but can also be set to produce lists of MPMs or life tables.
- `generate_mpm_set()` is now deprecated, and will be removed at a later
  date. Users should use
  [`rand_lefko_set()`](https://jonesor.github.io/mpmsim/reference/rand_lefko_set.md)
  instead.
- `random_mpm()` is now deprecated, and will be removed at a later date.
  Users should use
  [`rand_lefko_mpm()`](https://jonesor.github.io/mpmsim/reference/rand_lefko_mpm.md)
  instead.
- The new set generation functions omit the arguments `split`, `by_type`
  and `as_compadre`, which governed output types in
  `generate_mpm_set()`. These arguments been replaced with a simpler and
  more transparent argument, `output`.
- Added new function
  [`compute_ci_U()`](https://jonesor.github.io/mpmsim/reference/compute_ci_U.md)
  which calculates confidence intervals for traits derived from matrix
  models where only the U submatrix is used. For example, life
  expectancy (using the function
  [`Rage::life_expect_mean()`](https://rdrr.io/pkg/Rage/man/life_expect.html)).
- Added a vignette for generating Leslie matrices.
- Added a vignette for generating Lefkovitch matrices.

## mpmsim 2.0.0

CRAN release: 2024-01-15

- removed dependency on `MCMCpack`, which is reportedly being archived
  from CRAN. This change means that previous versions of `mpmsim` may
  not function correctly and it is advisable to update to the new
  version.

## mpmsim 1.1.0

CRAN release: 2023-09-29

- modified the simulation of fecundity in `random_mpm()`. Now the values
  are provided as mean fecundity and can be provided as a range of
  values, whereby a value is drawn from a random uniform distribution.
  This is the best way to create a set of models with different
  fecundity properties.
- added function to simulate the action of drivers such as weather on
  vital rates: `drive_vital_rate()`.
- added
  [`model_mortality()`](https://jonesor.github.io/mpmsim/reference/model_survival.md)
  as an alias for
  [`model_survival()`](https://jonesor.github.io/mpmsim/reference/model_survival.md).
- function `generate_mpm_set()` now returns a `CompadreDB` object by
  default.
- added full suite of unit tests using `testthat`. Test coverage 97.17%.

## mpmsim 1.0.0

CRAN release: 2023-04-18

#### First release, with the following functionality.

- Functions for simulating Lefkovitch matrix models:
  `generate_mpm_set()` and`random_mpm()`.
- A function for constructing Leslie matrix models:
  [`make_leslie_mpm()`](https://jonesor.github.io/mpmsim/reference/make_leslie_mpm.md),
  which can make use of outputs from functions for describing
  demographic trajectories
  ([`model_fertility()`](https://jonesor.github.io/mpmsim/reference/model_fecundity.md)
  and
  [`model_survival()`](https://jonesor.github.io/mpmsim/reference/model_survival.md)).
- Functions for calculating and propagating error:
  [`add_mpm_error()`](https://jonesor.github.io/mpmsim/reference/add_mpm_error.md),
  [`calculate_errors()`](https://jonesor.github.io/mpmsim/reference/calculate_errors.md)
  and
  [`compute_ci()`](https://jonesor.github.io/mpmsim/reference/compute_ci.md).
- A utility function:
  [`plot_matrix()`](https://jonesor.github.io/mpmsim/reference/plot_matrix.md)
