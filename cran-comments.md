## Test environments
* local OS X install, R 3.6.1
* ubuntu 16.04 (on travis-ci), R 3.6.1
* win-builder (release)

## R CMD check results
There were no ERRORs or WARNINGs.

There was 1 NOTE:

* Possibly mis-spelled words in DESCRIPTION:
  OpenCV (3:16, 11:23, 11:57, 13:67)

  OpenCV is not mis-spelled.

## Downstream dependencies

There are currently no downstream dependencies for this package.

## CRAN team comments

"Please write package names, software names and API names in 
single quotes (e.g. 'OpenCV') in Title and Description."

Fixed. 

"Please do not change the working directory in your functions.
If you really have to, please always ensure by an immediate call of 
on.exit() (e.g. on.exit(setwd(origDir))) that the old working directory 
is reset."

Calls to setwd() were removed. The functions do not change the working directory
anymore. 