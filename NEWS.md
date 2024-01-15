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
