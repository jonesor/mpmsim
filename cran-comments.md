## R CMD check results

* This is a minor update. Increased functionality and bug fixes.

## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)


── mpmsim 1.1.0: NOTE

  Build ID:   mpmsim_1.1.0.tar.gz-3a1f4a3a6c71439f9f4d170284c2f0c7
  Platform:   Windows Server 2022, R-devel, 64 bit
  Submitted:  2h 14m 12.3s ago
  Build time: 5m 3.5s

❯ checking HTML version of manual ... NOTE
  Skipping checking math rendering: package 'V8' unavailable

❯ checking for non-standard things in the check directory ... NOTE
  Found the following files/directories:
    ''NULL''

❯ checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

0 errors ✔ | 0 warnings ✔ | 3 notes ✖

── mpmsim 1.1.0: NOTE

  Build ID:   mpmsim_1.1.0.tar.gz-403fe0e244a546b58cbadc2b2fd256a2
  Platform:   Ubuntu Linux 20.04.1 LTS, R-release, GCC
  Submitted:  2h 14m 12.4s ago
  Build time: 1h 38m 59.1s

❯ checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found
  Skipping checking math rendering: package 'V8' unavailable

0 errors ✔ | 0 warnings ✔ | 1 note ✖

── mpmsim 1.1.0: NOTE

  Build ID:   mpmsim_1.1.0.tar.gz-7238f40553f54ca3952297583d3ce070
  Platform:   Fedora Linux, R-devel, clang, gfortran
  Submitted:  2h 14m 12.4s ago
  Build time: 1h 38m 44.8s

❯ checking examples ... [10s/21s] NOTE
  Examples with CPU (user + system) or elapsed time > 5s
              user system elapsed
  compute_ci 2.394  0.103   5.272

❯ checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found
  Skipping checking math rendering: package 'V8' unavailable

0 errors ✔ | 0 warnings ✔ | 2 notes ✖
