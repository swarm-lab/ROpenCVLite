# ROpenCVLite - Install OpenCV with R <img src="man/figures/logo.png" align="right" alt="" width="120" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/swarm-lab/ROpenCVLite/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/swarm-lab/ROpenCVLite/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/swarm-lab/ROpenCVLite/branch/master/graph/badge.svg)](https://app.codecov.io/gh/swarm-lab/ROpenCVLite?branch=master)
[![CRAN status](https://www.r-pkg.org/badges/version/ROpenCVLite)](https://CRAN.R-project.org/package=ROpenCVLite)
[![CRANLOGS downloads](https://cranlogs.r-pkg.org/badges/ROpenCVLite)](https://cran.r-project.org/package=ROpenCVLite)

<!-- badges: end -->

## Description 

[`ROpenCVLite`](https://github.com/swarm-lab/ROpenCVLite) is a utility package 
that installs [`OpenCV`](https://opencv.org/) within [`R`](https://cran.r-project.org) 
for use by other packages. This package is not a wrapper around [`OpenCV`](https://opencv.org/) 
(it does not provide access to [`OpenCV`](https://opencv.org/) functions in R), 
not is it a computer vision package for [`R`](https://cran.r-project.org). All 
it does is compiling and installing [`OpenCV`](https://opencv.org/) within your 
[`R`](https://cran.r-project.org) installation so that other packages can easily 
find it and compile against it. 

---

## Quick start guides

1. [Installing ROpenCVLite](https://swarm-lab.github.io/ROpenCVLite/articles/install.html)
2. [Using ROpenCVLite](https://swarm-lab.github.io/ROpenCVLite/articles/usage.html)
3. [Function documentation](https://swarm-lab.github.io/ROpenCVLite/reference/)

---

## FAQ

### What is OpenCV? 

[`OpenCV`](https://opencv.org/) is one of the most - if not the most - popular 
and efficient open-source computer vision library available today. If you want 
to develop fast video processing software or implement real time computer vision 
algorithms, you pretty much have to use [`OpenCV`](https://opencv.org/) nowadays. 

### Why is [`ROpenCVLite`](https://github.com/swarm-lab/ROpenCVLite) necessary?

There are no computer vision package available for [`R`](https://cran.r-project.org) 
currently. There are some very good image processing packages (see 
[imager](https://dahtah.github.io/imager/) for instance) but none of them can 
handle fast processing of large videos.

The goal of [`ROpenCVLite`](https://github.com/swarm-lab/ROpenCVLite) is to 
promote the development of efficient computer vision packages for [`R`](https://cran.r-project.org) 
based on [`OpenCV`](https://opencv.org/). [`ROpenCVLite`](https://github.com/swarm-lab/ROpenCVLite)
facilitates the installation of [`OpenCV`](https://opencv.org/) in a convenient 
location for other packages to find it and compile against it. 

### Couldn't you just ship [`OpenCV`](https://opencv.org/)'s binaries with your package?

Yes, but... it is fairly difficult to ship binary files compiled against 
[`OpenCV`](https://opencv.org/) that will work for sure on someone else's computer. 
It is not [`OpenCV`](https://opencv.org/)'s fault; it is because there are so many 
video formats and standards for peripherals out there that nobody can be certain 
what interfaces and libraries will be available on anyone's computer to grab 
images from videos and camera streams. The least worst solution for developers 
is therefore to make sure that there is a copy of [`OpenCV`](https://opencv.org/) 
on each user's computer that has been compiled taking into account the 
specificities of said computer.

HOWEVER...

[`OpenCV`](https://opencv.org/) is notoriously difficult to compile and install 
from scratch, especially for people without experience with low level languages.
This is where [`ROpenCVLite`](https://github.com/swarm-lab/ROpenCVLite) come into 
play. This package tries as much as possible to cleanly compile [`OpenCV`](https://opencv.org/)
and to install it in a standardized location that all [`R`](https://cran.r-project.org) 
package developers can easily find.

### Why "Lite"? Are you keeping something from us? 

[`ROpenCVLite`](https://github.com/swarm-lab/ROpenCVLite) compiles and installs 
the core modules of the [`OpenCV`](https://opencv.org/) library but does not 
compile or install its [contributed extra modules](https://github.com/opencv/opencv_contrib).
This is to reduce the compilation time (which is already long enough) and also 
because most of these extra modules are (1) too specific for most applications of 
[`OpenCV`](https://opencv.org/), and (2) they do not always compile nicely.

We will work toward providing a mechanism to install the extra modules, but this 
is not part of our immediate plans. 
