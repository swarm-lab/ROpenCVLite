## Test environments

* local M1 OS X 12.3.1, R 4.2.1
* local Intel OS X 12.3.1, R 4.2.1
* local Windows 10, R 4.2.1
* local Ubuntu 22.04, R 4.2.1
* Github Actions "windows-latest (release)"
* Github Actions "macOS-latest (release)"
* Github Actions "ubuntu-latest (release)"
* Github Actions "ubuntu-latest (devel)"
* Github Actions "ubuntu-latest (oldrel-1)"
* r-hub Windows Server 2022, R-devel, 64 bit
* r-hub Ubuntu Linux 20.04.1 LTS, R-release, GCC
* r-hub Fedora Linux, R-devel, clang, gfortran
* win-builder.r-project.org

## R CMD check results

There were no ERRORs or WARNINGs.

## Downstream dependencies

There are currently no downstream dependencies for this package.

## CRAN team comments

This update was requested by Prof Brian Ripley in the following message:

"During installation this says repeatedly

Warning in installOpenCV() :
   OpenCV can only be installed in interactive mode or if the batch mode
is activated.
OpenCV was not installed at this time. You can install it at any time by
using the installOpenCV() function.

That's silly as you know it is not interactive.  Nor is it clear what
the 'batch mode' refers to, but this whole message is inappropriate
during installation.  And startup messages should be suppressible, using
packageStartupMessage() not message() and not warning().

Please correct before 2022-08-08 to safely retain your package on CRAN."
