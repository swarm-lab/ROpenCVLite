## Test environments

* local M4 OS X 14.5, R 4.1.3, 4.2.3, 4.3.2, 4.4.3, 4.5, R devel
* local Windows 11, R R 4.1.3, 4.2.3, 4.3.2, 4.4.3, 4.5, R devel
* local Ubuntu 24.04, R 4.1.3, 4.2.3, 4.3.2, 4.4.3, 4.5, R devel
* Github Actions "windows-latest (release)"
* Github Actions "macOS-latest (release)"
* Github Actions "ubuntu-latest (release)"
* Github Actions "ubuntu-latest (devel)"
* Github Actions "ubuntu-latest (oldrel-1)"
* win-builder.r-project.org

## R CMD check results

* N/A.

## Downstream dependencies

There are currently no downstream dependencies for this package.

## CRAN team comments

* 1 NOTE: Version jumps in minor (submitted: 4.110.0, existing: 4.90.2)

This is normal. Version 4.100.0 was skipped because I chose to skip the upgrade
to OpenCV 4.10.0 and move directly to OpenCV 4.11.0. 