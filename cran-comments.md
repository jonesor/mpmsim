## R CMD check results

* This removes package dependency on MCMCpack, which is being archived.

## Test environments
- R-hub Windows Server 2022, R-devel, 64 bit
- R-hub Ubuntu Linux 20.04.1 LTS, R-release, GCC
- R-hub Fedora Linux, R-devel, clang, gfortran


── mpmsim 2.0.0: NOTE

  Build ID:   mpmsim_2.0.0.tar.gz-5be2978c54374c56bc9581668c1af5b5
  Platform:   Windows Server 2022, R-devel, 64 bit
  Submitted:  5h 51m 55.7s ago
  Build time: 7m 0.8s

❯ checking HTML version of manual ... NOTE
  Skipping checking math rendering: package 'V8' unavailable

❯ checking for non-standard things in the check directory ... NOTE
  Found the following files/directories:

❯ checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

0 errors ✔ | 0 warnings ✔ | 3 notes ✖

── mpmsim 2.0.0: NOTE

  Build ID:   mpmsim_2.0.0.tar.gz-8994246cd3e1417ea0c012811635dbf4
  Platform:   Ubuntu Linux 20.04.1 LTS, R-release, GCC
  Submitted:  5h 51m 55.8s ago
  Build time: 2h 24m 50.7s

❯ checking examples ... [9s/36s] NOTE
  Examples with CPU (user + system) or elapsed time > 5s
              user system elapsed
  compute_ci 2.572  0.044  10.836

❯ checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found
  Skipping checking math rendering: package 'V8' unavailable

0 errors ✔ | 0 warnings ✔ | 2 notes ✖

── mpmsim 2.0.0: NOTE

  Build ID:   mpmsim_2.0.0.tar.gz-644860475a5047238cab78884f060a4e
  Platform:   Fedora Linux, R-devel, clang, gfortran
  Submitted:  5h 51m 56s ago
  Build time: 2h 15m 59.2s

❯ checking examples ... [9s/33s] NOTE
  Examples with CPU (user + system) or elapsed time > 5s
              user system elapsed
  compute_ci 2.546  0.036  10.187

❯ checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found
  Skipping checking math rendering: package 'V8' unavailable

0 errors ✔ | 0 warnings ✔ | 2 notes ✖
