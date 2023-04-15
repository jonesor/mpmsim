## R CMD check results

* This is a new package

## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)

## R CMD check results
❯ On windows-x86_64-devel (r-devel), ubuntu-gcc-release (r-release)
  checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Owen Jones <jones@biology.sdu.dk>'
  
  New submission

❯ On windows-x86_64-devel (r-devel), fedora-clang-devel (r-devel)
  checking HTML version of manual ... NOTE
  Skipping checking math rendering: package 'V8' unavailable

❯ On windows-x86_64-devel (r-devel)
  checking for detritus in the temp directory ... NOTE
  Found the following files/directories:

❯ On ubuntu-gcc-release (r-release)
  checking examples ... [9s/25s] NOTE
  Examples with CPU (user + system) or elapsed time > 5s
              user system elapsed
  compute_ci 2.231  0.075   6.881

❯ On fedora-clang-devel (r-devel)
  checking CRAN incoming feasibility ... [6s/25s] NOTE
  Maintainer: ‘Owen Jones <jones@biology.sdu.dk>’
  
  New submission

❯ On fedora-clang-devel (r-devel)
  checking examples ... [9s/27s] NOTE
  Examples with CPU (user + system) or elapsed time > 5s
              user system elapsed
  compute_ci 2.436  0.076   6.806

0 errors ✔ | 0 warnings ✔ | 6 notes ✖
