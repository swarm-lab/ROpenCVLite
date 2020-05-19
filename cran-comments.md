## Test environments

* local OS X 10.15.4, R 4.0.0
* local Windows 10, R 4.0.0
* local Ubuntu 20.04, R 4.0.0
* travis CI Ubuntu 16.04, R 3.6.1
* travis CI OS X 10.13.6, R 3.6.1
* appveyor Windows Server 2012 R2, R 4.0.0

## R CMD check results

There were no ERRORs, WARNINGs or NOTEs.

## Downstream dependencies

There are currently no downstream dependencies for this package.

## CRAN team comments

The package has "SystemRequirements: cmake". A check was added during 
installation to make sure CMake is on the path. The installation fails if CMake
is not found and an error message is displayed with instructions on how to 
install CMake. 
