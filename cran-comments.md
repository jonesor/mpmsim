## Resubmission

This is a patch release.

In this version I have:

- fixed a typo in `calculate_errors()` that caused the `mat_U_error` element
  of the returned list to be misnamed when `type = "sem"`
- fixed vectorisation in `driven_vital_rate()` so matrix inputs are handled
  correctly
- fixed parameter row indexing in `rand_leslie_set()` for the Siler mortality
  model and several multi-parameter fecundity models
- removed an orphaned expression in the internal function
  `add_mpm_error_indiv()`

## R CMD check results

I ran the following local checks on macOS with R 4.5.3:

- `testthat::test_local(".")`
- `R CMD build .`
- `R CMD check --no-manual mpmsim_3.3.0.tar.gz`

All checks passed.

0 errors | 0 warnings | 0 notes

## Test environments

- local macOS, R 4.5.3
- GitHub Actions linux, `ubuntu-latest`, `R-*`
- GitHub Actions m1-san, `macos-15`, `R-*`
- GitHub Actions macOS, `macos-13`, `R-*`
- GitHub Actions macOS arm64, `macos-latest`, `R-*`
- GitHub Actions windows, `windows-latest`, `R-*`
