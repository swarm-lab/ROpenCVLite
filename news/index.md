# Changelog

## ROpenCVLite 4.130.0

### New features

- Updates package to target OpenCV 4.13.0.
- [`installOpenCV()`](https://swarm-lab.github.io/ROpenCVLite/reference/installOpenCV.md)
  now respects custom install paths when setting `PATH` and
  `LD_LIBRARY_PATH` at package load time.
- `optimize_for_host` parameter in
  [`installOpenCV()`](https://swarm-lab.github.io/ROpenCVLite/reference/installOpenCV.md)
  is now supported on Unix and macOS (previously Windows-only).

### Minor improvements and fixes

- Fixes Rtools detection on systems with strict PowerShell execution
  policies by adding `-NoProfile` flag to PowerShell calls (thanks to
  [@allan-sims](https://github.com/allan-sims),
  [\#54](https://github.com/swarm-lab/ROpenCVLite/issues/54)).
- Fixes a bug where old OpenCV installations were not removed when
  reinstalling.
- Removes a debug [`print()`](https://rdrr.io/r/base/print.html) call
  from
  [`removeOpenCV()`](https://swarm-lab.github.io/ROpenCVLite/reference/removeOpenCV.md).
- Diagnostic messages now use
  [`message()`](https://rdrr.io/r/base/message.html) throughout,
  enabling suppression via
  [`suppressMessages()`](https://rdrr.io/r/base/message.html).
- Path construction in
  [`defaultOpenCVPath()`](https://swarm-lab.github.io/ROpenCVLite/reference/defaultOpenCVPath.md)
  is now robust to install trees that contain “ROpenCVLite” in a parent
  directory.
- Build steps use [`system2()`](https://rdrr.io/r/base/system2.html)
  instead of `system(paste0(...))` for safer handling of paths with
  spaces.

------------------------------------------------------------------------

## ROpenCVLite 4.110.0

CRAN release: 2025-05-05

### New features

- Upgrades package to OpenCV 4.11.0.

### Minor improvements and fixes

- Fixes issue with CMake 4.

------------------------------------------------------------------------

## ROpenCVLite 4.90.2

CRAN release: 2024-08-01

### New features

- N/A.

### Minor improvements and fixes

- Removes pkgbuild dependency.

------------------------------------------------------------------------

## ROpenCVLite 4.90.1

CRAN release: 2024-01-21

### New features

- Adds WeChat QR code module (thanks to
  [@wresch](https://github.com/wresch)).
- Adds pkgconfig files (thanks to [@wresch](https://github.com/wresch)).

### Minor improvements and fixes

- Remove some processor optimization to avoid errors on Windows with
  recent CPUs.

------------------------------------------------------------------------

## ROpenCVLite 4.90.0

CRAN release: 2024-01-08

### New features

- Upgrade package to OpenCV 4.9.0.
- Remove support for R \< 4.0.0.

### Minor improvements and fixes

- Add compilation flags required to avoid errors on Windows 11.
- Overhaul of the installation functions for easier update management.

------------------------------------------------------------------------

## ROpenCVLite 4.80.1

CRAN release: 2023-10-31

### New features

- N/A.

### Minor improvements and fixes

- Add compilation flags required with latest Rtools on Windows.

------------------------------------------------------------------------

## ROpenCVLite 4.80.0

CRAN release: 2023-07-20

### New features

- Upgrade package to OpenCV 4.8.0.

### Minor improvements and fixes

- N/A.

------------------------------------------------------------------------

## ROpenCVLite 4.70.0

CRAN release: 2023-01-06

### New features

- Upgrade package to OpenCV 4.7.0.

### Minor improvements and fixes

- N/A.

------------------------------------------------------------------------

## ROpenCVLite 4.60.3

CRAN release: 2022-12-01

### New features

- Adds ximgproc “extra” module.

### Minor improvements and fixes

- N/A.

------------------------------------------------------------------------

## ROpenCVLite 4.60.2

CRAN release: 2022-07-17

### New features

- Adds function to remove OpenCV.

### Minor improvements and fixes

- Removes unnecessary messages during package installation.

------------------------------------------------------------------------

## ROpenCVLite 4.60.1

CRAN release: 2022-07-16

### New features

- Upgrade package to OpenCV 4.6.0.

### Minor improvements and fixes

- N/A.

------------------------------------------------------------------------

## ROpenCVLite 4.55.2

CRAN release: 2022-05-18

### New features

- N/A.

### Minor improvements and fixes

- Compatible with new RTools 4.2 toolchain.

------------------------------------------------------------------------

## ROpenCVLite 4.55.1

### New features

- Add possibility to install OpenCV in custom directory.
- Change default installation directory.

### Minor improvements and fixes

- Fix documentation.

------------------------------------------------------------------------

## ROpenCVLite 4.55.0

CRAN release: 2022-04-13

### New features

- Upgrade package to OpenCV 4.5.5.

### Minor improvements and fixes

- N/A.

------------------------------------------------------------------------

## ROpenCVLite 4.52.1

CRAN release: 2022-02-17

### New features

- N/A.

### Minor improvements and fixes

- Fix installation bug on Windows after upgrade to latest pkgbuild
  version.

------------------------------------------------------------------------

## ROpenCVLite 4.52.0

CRAN release: 2021-07-05

### New features

- Upgrade package to OpenCV 4.5.2

### Minor improvements and fixes

- N/A.

------------------------------------------------------------------------

## ROpenCVLite 4.51.0

CRAN release: 2021-03-21

### New features

- Upgrade package to OpenCV 4.5.1
- OpenCV compiles with OpenCL support and other optimizations when
  possible.

### Minor improvements and fixes

- N/A.

------------------------------------------------------------------------

## ROpenCVLite 4.50.0

CRAN release: 2021-02-06

### New features

- Upgrade package to OpenCV 4.5.0
- OpenCV compiles with OpenMP support when possible.

### Minor improvements and fixes

- N/A.

------------------------------------------------------------------------

## ROpenCVLite 4.430.2

### New features

N/A

### Minor improvements and fixes

- Fix an issue with detecting when a new version of OpenCV is available.

------------------------------------------------------------------------

## ROpenCVLite 4.430.1

### New features

N/A

### Minor improvements and fixes

- Fix an issue with detecting Rtools with R 3.x on Windows.

------------------------------------------------------------------------

## ROpenCVLite 4.430.0

### New features

- Package updated to use the latest OpenCV release (4.3.0).
- Package updated to work with RTools 4.0 (Windows only).

### Minor improvements and fixes

- A CMake check is now made during the package installation.

------------------------------------------------------------------------

## ROpenCVLite 3.412.1

### New features

N/A

### Minor improvements and fixes

- If an old installation exists, it is deleted before
  upgrading/reinstalling OpenCV.

------------------------------------------------------------------------

## ROpenCVLite 0.3.412

CRAN release: 2019-12-19

### New features

- Package updated to use the latest OpenCV release (4.1.2).

### Minor improvements and fixes

N/A

------------------------------------------------------------------------

## ROpenCVLite 0.3.410

CRAN release: 2019-08-02

### New features

- Package ready for release to CRAN.

### Minor improvements and fixes

N/A
