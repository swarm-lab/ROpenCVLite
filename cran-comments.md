## Test environments

* GitHub Actions "windows-latest" (R release, oldrel-1, devel)
* GitHub Actions "macOS-latest" (R release, oldrel-1, devel)
* GitHub Actions "ubuntu-latest" (R release, oldrel-1, devel)
* win-builder.r-project.org (R-devel)
* Local macOS (Apple clang 21, CMake 4.3.4): full `installOpenCV()` build against
  real OpenCV 5.0.0 + opencv_contrib 5.0.0 sources, and `devtools::check()`

## R CMD check results

0 errors | 0 warnings | 0 notes

This is a major version bump (4.130.0 -> 5.0.0) to target OpenCV 5.0.0 (previously
OpenCV 4.13.0), so no "version jumps in minor" NOTE is expected this time.

## Downstream dependencies

There are currently no downstream dependencies for this package.
