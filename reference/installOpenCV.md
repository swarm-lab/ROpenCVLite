# Install OpenCV

This function attempts to download, compile and install OpenCV on the
system. This process will take several minutes.

## Usage

``` r
installOpenCV(
  install_path = defaultOpenCVPath(),
  batch = FALSE,
  use_ccache = FALSE,
  optimize_for_host = FALSE,
  modules = c("calib3d", "core", "dnn", "features2d", "flann", "gapi", "highgui",
    "imgcodecs", "imgproc", "ml", "objdetect", "photo", "stitching", "video", "videoio",
    "ximgproc", "wechat_qrcode")
)
```

## Arguments

- install_path:

  A character string indicating the location at which OpenCV should be
  installed. By default, it is the value returned by
  [`defaultOpenCVPath`](https://swarm-lab.github.io/ROpenCVLite/reference/defaultOpenCVPath.md).

- batch:

  A boolean indicating whether to skip (`TRUE`) or not (`FALSE`, the
  default) the interactive installation dialog. This is useful when
  OpenCV needs to be installed in a non-interactive environment (e.g.,
  during a batch installation on a server).

- use_ccache:

  A boolean indicating whether to use `ccache` (`TRUE`) to speed up
  repeated compilations. Requires `ccache` to be installed and on the
  PATH. Defaults to `FALSE`.

- optimize_for_host:

  A boolean indicating whether to let CMake detect and use the host
  CPU's full instruction set (`TRUE`) instead of the defaults (`FALSE`).
  On Windows the default is a conservative SSE4/AVX-limited build; on
  Unix/macOS CMake's own defaults apply. Setting this to `TRUE` produces
  a faster binary on the build machine but the result may not run on
  other hardware.

- modules:

  A character vector of OpenCV modules to compile. Defaults to the full
  set supported by `ROpenCVLite`. Specify a subset to reduce compilation
  time when only specific functionality is needed.

## Value

A boolean.

## Author

Simon Garnier, <garnier@njit.edu>

## Examples

``` r
if (FALSE) { # \dontrun{
installOpenCV()
} # }
```
