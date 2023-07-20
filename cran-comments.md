## Test environments

* local M1 OS X 13.4.1, R 4.3.1
* local Windows 10, R 4.3.1
* local Ubuntu 22.04, R 4.3.1
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

* Version jumps in minor (submitted: 4.80.0, existing: 4.70.0)

This is normal. The package version follows that of OpenCV. 

* Package CITATION file contains call(s) to old-style citEntry(). Please use bibentry() instead.

Fixed. 