# mpmsim (development version)

- added function to simulate the action of drivers such as weather on vital rates: `drive_vital_rate()`.
- added full suite of unit tests using `testthat`. Test coverage 97.01%.

# mpmsim 1.0.0

### First release, with the following functionality.

- Functions for simulating Lefkovitch matrix models: `generate_mpm_set()` and`random_mpm()`.
- A function for constructing Leslie matrix models: `make_leslie_mpm()`, which can make use of outputs from functions for describing demographic trajectories (`model_fertility()` and `model_survival()`).
- Functions for calculating and propagating error: `add_mpm_error()`, `calculate_errors()` and `compute_ci()`.
- A utility function: `plot_matrix()`
