# C/C++ configuration options

This function returns the configuration options for compiling
C/C++-based packages against OpenCV installed by
[`ROpenCVLite`](https://swarm-lab.github.io/ROpenCVLite/reference/ROpenCVLite-package.md).

## Usage

``` r
opencvConfig(output = "libs", arch = NULL)
```

## Arguments

- output:

  Either 'libs' for library configuration options or 'cflags' for C/C++
  configuration flags.

- arch:

  architecture relevant for Windows. If `NULL`, then `R.version$arch`
  will be used.

## Value

A concatenated character string (with
[`cat`](https://rdrr.io/r/base/cat.html)) of the configuration options.

## Author

Simon Garnier, <garnier@njit.edu>

## Examples

``` r
if (FALSE) { # \dontrun{
 if (isOpenCVInstalled()) {
   opencvConfig()
   opencvConfig(output = "cflags")
   opencvConfig(arch = R.version$arch)
 }
} # }
```
