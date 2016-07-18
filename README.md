# ROpenCVLite

**Not ready for production. Try at your own risks.**

## Package description

`ROpenCVLite` is a utility package that installs [`OpenCV`](http://opencv.org/) 
within `R` for use by other packages. This package is not a wrapper around 
`OpenCV` (it does not provide access to `OpenCV` functions in R), not is it a 
computer vision package for R. All it does is compiling and installing OpenCV 
within your R installation so that other packages can easily find it and compile 
against it. 

Read the [FAQ](#faq) below for more info about the what, why, and how of 
`ROpenCVLite`.

---

## Package installation

### Before installing 

#### Windows

Before installing `ROpenCVLite`, you will need to install the latest versions of
[`CMake`](https://cmake.org/) and [`Rtools`](https://cran.r-project.org/bin/windows/Rtools/). 

Download `CMake` for Windows at [https://cmake.org/download/](https://cmake.org/download/).

Download the latest "frozen" version of `Rtools` at 
[https://cran.r-project.org/bin/windows/Rtools/](https://cran.r-project.org/bin/windows/Rtools/).

In both cases, make sure to tell the installer to add `CMake` and `Rtools` to 
your "PATH".

#### Mac

Before installing `ROpenCVLite`, you will need to install the latest version of
[`CMake`](https://cmake.org/).

Download `CMake` for Mac at [https://cmake.org/download/](https://cmake.org/download/).
You can also use [`Homebrew`](http://brew.sh/) or [`MacPorts`](https://www.macports.org/)
if you prefer (I prefer!).

*`Homebrew`:*

```bash
brew install cmake
```

*`MacPorts`:*

```bash
sudo port install cmake
```

#### Linux

Before installing `ROpenCVLite`, you will need to install the latest version of
[`CMake`](https://cmake.org/).

Download `CMake` for Linux at [https://cmake.org/download/](https://cmake.org/download/).
However it is recommended that you install it using your distribution's package
management system.

*`Ubuntu`:*

```bash
sudo apt-get install cmake
```

[TODO: add more Linux install commands]

#### Mac, Linux and Windows

You will need to install the `devtools` package in `R`. 

```r
install.package("devtools")
```

### Installing `ROpenCVLite`

```r
devtools::install_github("swarm-lab/ROpenCVLite")
```

---

### FAQ

#### What is OpenCV? 

[`OpenCV`](http://opencv.org/) is one of the most - if not the most - popular 
and efficient open-source computer vision library available today. If you want 
to develop fast video processing software or implement real time computer vision 
algorithms, you pretty much have to use `OpenCV` nowadays. 

#### Why is `ROpenCVLite` necessary?

There are no computer vision package available for R currently. We have some 
very good image processing packages (see [imager](http://dahtah.github.io/imager/) 
for instance) but none of them can handle fast processing of large videos.

#### But you said that `ROpenCVLite` is not a computer vision package for R...

And it is not. "All" it does is compile and install `OpenCV` in a convenient 
location for other packages to find it and compile against it. 

Why? 

Because it is difficult to ship binary files compiled against `OpenCV` that will
work for sure on someone else's computer. It is not `OpenCV`'s fault, this is 
because there are so many video formats and standards for peripherals out there
that nobody can be certain what interfaces will be available on anyone's computer
to grab images from videos and camera streams. The least worst solution for 
developers is therefore to make sure that there is a copy of `OpenCV` on each 
user's computer that has been compiled taking into account the specificities of 
said computer.

BUT...

OpenCV is notoriously difficult to compile and install from scratch, and this is 
where `ROpenCVLite` come into play. This package tries as much as possible to 
cleanly compile `OpenCV`, and to install it in a standardized location that all
`R` developers can easily find should they decide to develop a package that 
requires `OpenCV`'s fantastic capabilities.

#### So, I can't use `ROpenCVLite` for computer vision?

No, but you can use it to develop a computer vision package for R (see our
[Rvision](https://github.com/swarm-lab/Rvision) package for instance). 

The goal of `ROpenCVLite` is to enable developers to create their own packages 
for R based on `OpenCV`. Computer vision is just one of the possible applications
for `OpenCV`. It can do many more things, such as fast matric processing and 
GPU computing. By providing access to a more standardized installation of 
`OpenCV`, we hope to help the `R` community take advantage of this fantastic 
library. 

#### I want to create a package using `OpenCV`. How does this work? 

We will put together a complete tutorial at some point, but the short answer is:

1. Set `ROpenCVLite` as a dependency of your package.
2. Use the `opencvConfig` function provided with the package to set the `PKG_LIBS`
and `PKG_CPPFLAGS` values in your Makevars and Makevars.win files. See for example 
the [Makevars](https://github.com/swarm-lab/Rvision/blob/master/src/Makevars) 
[Makevars.win](https://github.com/swarm-lab/Rvision/blob/master/src/Makevars.win)
files in our [Rvision](https://github.com/swarm-lab/Rvision) package.


#### Why "Lite"? Are you keeping something from me? 

`ROpenCVLite` compiles and installs the entire `OpenCV` library but does not 
compile or install its [contributed extra modules](https://github.com/opencv/opencv_contrib).
This is to reduce the compilation time (which is already long enough) and also 
because most of these extra modules are (1) useless for most applications of 
`OpenCV`, and (2) they do not always compile nicely.

We will work toward providing a mechanism to install the extra modules, but this 
is not part of our immediate plans. 

In the meantime, you can take your chances with our [`ROpenCV`](https://github.com/swarm-lab/ROpenCV) 
package that attempts to compile and install `OpenCV` and all its extra modules.
It'll take time and success is absolutely not guaranteed (though we had good 
results on our Mac and Linux machines so far).

---
