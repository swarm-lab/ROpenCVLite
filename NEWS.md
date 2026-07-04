# ROpenCVLite 5.0.0

## New features

* Updates package to target OpenCV 5.0.0.
* **Breaking**: the default `modules` argument of `installOpenCV()` is updated for
  OpenCV 5's restructured module layout: `calib3d` is replaced by `calib`, `stereo`,
  and `geometry`; `features2d` is replaced by `features`; `xobjdetect` is added
  (provides `cv::CascadeClassifier`/`cv::HOGDescriptor`, moved out of `objdetect` and
  into `opencv_contrib` in OpenCV 5). `ml` and `gapi` keep their names but are now
  sourced from `opencv_contrib` instead of core. No backward-compatibility translation
  is provided for the old module names.
* The OpenCV build now requires a C++17-compatible toolchain (GCC 8+/Clang 9+/MSVC
  2017+), matching OpenCV 5's minimum requirement.
* On Windows, `installOpenCV()` now patches `3rdparty/mlas` to fix two MinGW build
  failures in OpenCV 5.0.0: (1) `posix_memalign` is not declared under MinGW,
  mirroring a fix already merged upstream (opencv/opencv#29352) after the 5.0.0 tag
  was cut; and (2) MinGW's `_xgetbv()` builtin fails to inline without an explicit
  `xsave` target attribute, which MSVC's `_xgetbv()` doesn't require (no upstream
  fix exists yet for this one).
* `installOpenCV()` now explicitly pins `CMAKE_ASM_COMPILER` to the same MinGW
  toolchain used for `CMAKE_C_COMPILER`/`CMAKE_CXX_COMPILER` on Windows, instead of
  letting CMake auto-detect an assembler. Needed for OpenCV 5's `dnn` module, whose
  `mlas` backend added hand-written `.S` assembly kernels that previously had no
  reason to be assembled; without this, CMake could pick up an unrelated, ABI-
  incompatible MinGW install elsewhere on `PATH`.
* `installOpenCV()` now verifies, immediately after installation, that every
  requested module produced a header on disk, and fails with an informative error
  instead of silently reporting success if CMake's `BUILD_LIST` dropped an
  unrecognized module name.

## Minor improvements and fixes

* `opencvVersion()` and `opencvConfig()` now derive the `opencvN` pkg-config/include
  path segment from the installed OpenCV's major version instead of hardcoding
  `opencv4`, so future major-version bumps don't require repeating this fix.
* Removes the "CMake 4 issue" workaround that patched
  `cmake/OpenCVGenPkgconfig.cmake`, since OpenCV 5.0.0 already declares an adequate
  `cmake_minimum_required` on its own.
* Fixes a pre-existing bug in `opencvConfig()` where the `pkg-config` lookup always
  silently failed and fell back to manual header/library discovery, because
  `PKG_CONFIG_PATH` was set to the library directory instead of its `pkgconfig`
  subdirectory. Found while build-verifying this release against a real OpenCV 5.0.0
  installation.

---

# ROpenCVLite 4.130.0

## New features

* Updates package to target OpenCV 4.13.0.
* `installOpenCV()` now respects custom install paths when setting `PATH` and
  `LD_LIBRARY_PATH` at package load time.
* `optimize_for_host` parameter in `installOpenCV()` is now supported on
  Unix and macOS (previously Windows-only).

## Minor improvements and fixes

* Fixes Rtools detection on systems with strict PowerShell execution policies
  by adding `-NoProfile` flag to PowerShell calls (thanks to @allan-sims, #54).
* Fixes a bug where old OpenCV installations were not removed when reinstalling.
* Removes a debug `print()` call from `removeOpenCV()`.
* Diagnostic messages now use `message()` throughout, enabling suppression via
  `suppressMessages()`.
* Path construction in `defaultOpenCVPath()` is now robust to install trees
  that contain "ROpenCVLite" in a parent directory.
* Build steps use `system2()` instead of `system(paste0(...))` for safer
  handling of paths with spaces.

---

# ROpenCVLite 4.110.0

## New features

* Upgrades package to OpenCV 4.11.0.

## Minor improvements and fixes

* Fixes issue with CMake 4.

---

# ROpenCVLite 4.90.2

## New features

* N/A.

## Minor improvements and fixes

* Removes pkgbuild dependency. 

---

# ROpenCVLite 4.90.1

## New features

* Adds WeChat QR code module (thanks to @wresch).
* Adds pkgconfig files (thanks to @wresch).  

## Minor improvements and fixes

* Remove some processor optimization to avoid errors on Windows with recent CPUs.

---

# ROpenCVLite 4.90.0

## New features

* Upgrade package to OpenCV 4.9.0.
* Remove support for R < 4.0.0.

## Minor improvements and fixes

* Add compilation flags required to avoid errors on Windows 11.
* Overhaul of the installation functions for easier update management. 

---

# ROpenCVLite 4.80.1

## New features

* N/A.

## Minor improvements and fixes

* Add compilation flags required with latest Rtools on Windows.

---

# ROpenCVLite 4.80.0

## New features

* Upgrade package to OpenCV 4.8.0.

## Minor improvements and fixes

* N/A.

---

# ROpenCVLite 4.70.0

## New features

* Upgrade package to OpenCV 4.7.0.

## Minor improvements and fixes

* N/A.

---

# ROpenCVLite 4.60.3

## New features

* Adds ximgproc "extra" module.

## Minor improvements and fixes

* N/A.

---

# ROpenCVLite 4.60.2

## New features

* Adds function to remove OpenCV.

## Minor improvements and fixes

* Removes unnecessary messages during package installation. 

---

# ROpenCVLite 4.60.1

## New features

* Upgrade package to OpenCV 4.6.0.

## Minor improvements and fixes

* N/A.

---

# ROpenCVLite 4.55.2

## New features

* N/A.

## Minor improvements and fixes

* Compatible with new RTools 4.2 toolchain.

---

# ROpenCVLite 4.55.1

## New features

* Add possibility to install OpenCV in custom directory.
* Change default installation directory.

## Minor improvements and fixes

* Fix documentation.

---

# ROpenCVLite 4.55.0

## New features

* Upgrade package to OpenCV 4.5.5.

## Minor improvements and fixes

* N/A.

---

# ROpenCVLite 4.52.1

## New features

* N/A.

## Minor improvements and fixes

* Fix installation bug on Windows after upgrade to latest pkgbuild version.

---

# ROpenCVLite 4.52.0

## New features

* Upgrade package to OpenCV 4.5.2

## Minor improvements and fixes

* N/A.

---

# ROpenCVLite 4.51.0

## New features

* Upgrade package to OpenCV 4.5.1
* OpenCV compiles with OpenCL support and other optimizations when possible. 

## Minor improvements and fixes

* N/A.

---

# ROpenCVLite 4.50.0

## New features

* Upgrade package to OpenCV 4.5.0
* OpenCV compiles  with OpenMP support when possible. 

## Minor improvements and fixes

* N/A.

---

# ROpenCVLite 4.430.2

## New features

N/A

## Minor improvements and fixes

* Fix an issue with detecting when a new version of OpenCV is available.

---

# ROpenCVLite 4.430.1

## New features

N/A

## Minor improvements and fixes

* Fix an issue with detecting Rtools with R 3.x on Windows.

---

# ROpenCVLite 4.430.0

## New features

* Package updated to use the latest OpenCV release (4.3.0).
* Package updated to work with RTools 4.0 (Windows only).

## Minor improvements and fixes

* A CMake check is now made during the package installation.

---

# ROpenCVLite 3.412.1

## New features

N/A

## Minor improvements and fixes

* If an old installation exists, it is deleted before upgrading/reinstalling OpenCV. 

---

# ROpenCVLite 0.3.412

## New features

* Package updated to use the latest OpenCV release (4.1.2). 

## Minor improvements and fixes

N/A

---

# ROpenCVLite 0.3.410

## New features

* Package ready for release to CRAN. 

## Minor improvements and fixes

N/A