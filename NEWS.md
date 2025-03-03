# mpmsim 3.2.0

- minor bug fixes and documentation improvements.
- removed deprecated functions `generate_mpm_set()` and `random_mpm()`

# mpmsim 3.1.0

- Added function synonym: `model_reproduction()` is synonymous with `model_fertility` and `model_fecundity`.
- Improved documentation including to the three vignettes focussing on Leslie models, Lefkovitch models, and error propagation respectively.
- Fixed minor typographical errors in other documentation.

# mpmsim 3.0.0

- When sets of matrices are returned as `CompadreDB` objects, the archetype (Lefkovitch) or model parameters (Leslie), are now included as metadata.
- Added function `rand_leslie_set()` to generate sets of Leslie matrices where the parameters of the constituent mortality and fertility functions are drawn randomly from defined distributions. The function returns a `CompadreDB` object by default, but can also be set to produce lists of MPMs or life tables.
- `generate_mpm_set()` is now deprecated, and will be removed at a later date. Users should use `rand_lefko_set()` instead. 
- `random_mpm()` is now deprecated, and will be removed at a later date. Users should use `rand_lefko_mpm()` instead.
- The new set generation functions omit the arguments `split`, `by_type` and `as_compadre`, which governed output types in `generate_mpm_set()`. These arguments been replaced with a simpler and more transparent argument, `output`.
- Added new function `compute_ci_U()` which calculates confidence intervals for traits derived from matrix models where only the U submatrix is used. For example, life expectancy (using the function `Rage::life_expect_mean()`). 
- Added a vignette for generating Leslie matrices.
- Added a vignette for generating Lefkovitch matrices.


# mpmsim 2.0.0

- removed dependency on `MCMCpack`, which is reportedly being archived from CRAN. This change means that previous versions of `mpmsim` may not function correctly and it is advisable to update to the new version.

# mpmsim 1.1.0

- modified the simulation of fecundity in `random_mpm()`. Now the values are provided as mean fecundity and can be provided as a range of values, whereby a value is drawn from a random uniform distribution. This is the best way to create a set of models with different fecundity properties.
- added function to simulate the action of drivers such as weather on vital rates: `drive_vital_rate()`.
- added `model_mortality()` as an alias for `model_survival()`.
- function `generate_mpm_set()` now returns a `CompadreDB` object by default.
- added full suite of unit tests using `testthat`. Test coverage 97.17%.

# mpmsim 1.0.0

### First release, with the following functionality.

- Functions for simulating Lefkovitch matrix models: `generate_mpm_set()` and`random_mpm()`.
- A function for constructing Leslie matrix models: `make_leslie_mpm()`, which can make use of outputs from functions for describing demographic trajectories (`model_fertility()` and `model_survival()`).
- Functions for calculating and propagating error: `add_mpm_error()`, `calculate_errors()` and `compute_ci()`.
- A utility function: `plot_matrix()`
