## Test environments
* local OS X 10.14.6, R 3.6.2
* local Windows 10, R 3.6.2
* local Ubuntu 19.10, R 3.6.2
* travis CI Ubuntu 16.04, R 3.6.1
* travis CI OS X 10.13.6, R 3.6.1
* appveyor Windows Server 2012 R2, R 3.6.2

## R CMD check results
There were no ERRORs, WARNINGs or NOTEs.

## Downstream dependencies

There are currently no downstream dependencies for this package.

## CRAN team comments

On Debian: 

* checking top-level files ... NOTE
  possible bashism in configure line 5 (type):
  if type cmake >/dev/null 2>&1; then
  
  Fixed
  
On Windows:

* checking whether package 'ROpenCVLite' can be installed ... ERROR
  Installation failed.
  See 'd:/RCompile/CRANincoming/R-devel/ROpenCVLite.Rcheck/00install.out' for details.
  
  Fixed