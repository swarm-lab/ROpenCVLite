## Test environments

* local OS X 11.0.1, R 4.0.3
* local Windows 10, R 4.0.3
* local Ubuntu 20.04, R 4.0.3
* Github Actions "windows-latest (release)"
* Github Actions "macOS-latest (release)"
* Github Actions "ubuntu-20.04-latest (release)"
* Github Actions "ubuntu-20.04-latest (devel)"
* r-hub Windows Server 2008 R2 SP1, R-devel, 32/64 bit
* r-hub Ubuntu Linux 16.04 LTS, R-release, GCC
* r-hub Fedora Linux, R-devel, clang, gfortran
* win-builder.r-project.org

## R CMD check results

There were no ERRORs or WARNINGs.

## Downstream dependencies

There are currently no downstream dependencies for this package.

## CRAN team comments

* Version jumps in minor (submitted: 4.50.0, existing: 4.30.2). Is this intended?

Yes. The version numbering follows that of the OpenCV version that is installed 
by the package (4.5 in this particular case). 

* Found the following (possibly) invalid URLs:
  URL: http://opencv.org/ (moved to https://opencv.org/)
  From: inst/doc/install.html
        inst/doc/usage.html
        README.md
       
Fixed. 

