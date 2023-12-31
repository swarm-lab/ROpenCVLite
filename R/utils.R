#' @title Install Location of OpenCV
#'
#' @description This function returns the location at which OpenCV is installed.
#'
#' @return A character string.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'
#' @examples
#' \dontrun{
#'  OpenCVPath()
#' }
#'
#' @export
OpenCVPath <- function() {
  pkgPath <- find.package("ROpenCVLite")

  if (file.exists(paste0(pkgPath, "/path"))) {
    path <- readLines(paste0(pkgPath, "/path"), 1)
  } else {
    path <- character()
  }

  if (length(path) == 0)
    path <- defaultOpenCVPath()

  if (dir.exists(paste0(path, "/include/"))) {
    path
  } else {
    stop("OpenCV is not installed on this system. Please use installOpenCV() to install it.")
  }
}


#' @title Check OpenCV Installation
#'
#' @description This function checks that OpenCV is installed and accessible.
#'
#' @return A boolean.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'
#' @examples
#' isOpenCVInstalled()
#'
#' @export
isOpenCVInstalled <- function() {
  path <- try(OpenCVPath(), silent = TRUE)

  if (inherits(path, "try-error")) {
    FALSE
  } else {
    dir.exists(paste0(path, "/include/"))
  }
}


#' @title Check Cmake Installation
#'
#' @description This function checks that Cmake is installed on the system.
#'
#' @return A boolean.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'
#' @examples
#' isCmakeInstalled()
#'
#' @export
isCmakeInstalled <- function() {
  cmake <- system("cmake --version", ignore.stdout = TRUE) == 0

  if (cmake) {
    cmake
  } else {
    cat("------------------ CMAKE NOT FOUND --------------------\n")
    cat("\n")
    cat("CMake was not found on the PATH. Please install CMake:\n")
    cat("\n")
    cat(" - installr::install.cmake()  (Windows; inside the R console)\n")
    cat(" - yum install cmake          (Fedora/CentOS; inside a terminal)\n")
    cat(" - apt install cmake          (Debian/Ubuntu; inside a terminal)\n")
    cat(" - brew install cmake         (MacOS; inside a terminal with Homebrew)\n")
    cat(" - port install cmake         (MacOS; inside a terminal with MacPorts)\n")
    cat("\n")
    cat("Alternatively install CMake from: <https://cmake.org/>\n")
    cat("\n")
    cat("-------------------------------------------------------\n")
    cat("\n")
    cmake
  }
}


#' @title OpenCV Version
#'
#' @description This function determines the version of OpenCV installed within
#'  R.
#'
#' @return A character string.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'
#' @examples
#' if (isOpenCVInstalled()) {
#'   opencvVersion()
#' }
#'
#' @export
opencvVersion <- function() {
  if (isOpenCVInstalled()) {
    if (.Platform$OS.type == "windows") {
      pcPath <- "/OpenCVConfig-version.cmake"
      pc <- utils::read.table(paste0(OpenCVPath(), pcPath), sep = "\t")[1, 1]
      paste0("Version ", gsub(")", "", gsub(".*VERSION ", "", pc)))
    } else {
      odir <- dir(OpenCVPath())
      lib <- odir[grepl("lib", odir)]
      pcPath <- paste0("/", lib, "/cmake/opencv4/OpenCVConfig-version.cmake")
      pc <- utils::read.table(paste0(OpenCVPath(), pcPath), sep = "\t")[1, 1]
      paste0("Version ", gsub(")", "", gsub(".*VERSION ", "", pc)))
    }
  } else {
    stop("OpenCV is not installed on this system. Please use installOpenCV() to install it.")
  }
}


#' @title C/C++ configuration options
#'
#' @description This function returns the configuration options for compiling
#'  C/C++-based packages against OpenCV installed by \code{\link{ROpenCVLite}}.
#'
#' @param output Either 'libs' for library configuration options or 'cflags' for
#'  C/C++ configuration flags.
#'
#' @param arch architecture relevant for Windows.  If \code{NULL}, then
#'  \code{R.version$arch} will be used.
#'
#' @return A concatenated character string (with \code{\link{cat}}) of the
#'  configuration options.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'
#' @examples
#' \dontrun{
#'  if (isOpenCVInstalled()) {
#'    opencvConfig()
#'    opencvConfig(output = "cflags")
#'    opencvConfig(arch = R.version$arch)
#'  }
#' }
#'
#' @export
opencvConfig <- function(output = "libs", arch = NULL) {
  if (!isOpenCVInstalled())
    stop("OpenCV is not installed on this system. Please use installOpenCV() to install it.")

  prefix <- OpenCVPath()

  if (output == "libs") {
    if (.Platform$OS.type == "windows") {
      if (is.null(arch)) {
        arch = R.version$arch
      }
      if (grepl("i386", arch)) {
        execPrefix <- paste0(prefix, "/x86/mingw")
      } else {
        execPrefix <- paste0(prefix, "/x64/mingw")
      }
      libDir <- paste0(execPrefix, "/lib")
      libs <- gsub("libopencv", "opencv", list.files(libDir, "lib*"))
      libs <- gsub("\\.a", "", libs)
      libs <- gsub("\\.dll", "", libs)
      libs <- ifelse(substring(libs, 1, 3) == "lib", substring(libs, 4), libs)
      libs <- paste0("-l", libs)
      cat(paste0('-L"', utils::shortPathName(libDir), '"'), libs)
    } else {
      execPrefix <- prefix
      odir <- dir(execPrefix)
      lib <- odir[grepl("lib", odir)]
      libDir <- paste0(execPrefix, "/", lib)
      libs <- gsub("libopencv", "opencv", list.files(libDir, "lib*"))
      libs <- gsub("\\.so", "", libs)
      libs <- gsub("\\.dylib", "", libs)
      libs <- libs[!grepl("\\.", libs)]
      libs <- paste0("-l", libs)
      if (Sys.info()[1] == "Darwin") {
        cat(paste0("-L", libDir, " ", paste0(libs, collapse = " ")))
      } else {
        cat(paste0("-Wl,-rpath=", libDir, " ", "-L", libDir, " ", paste0(libs, collapse = " ")))
      }
    }
  } else if (output == "cflags") {
    if (.Platform$OS.type == "windows") {
      includedirOld <- paste0(prefix, "/include/opencv2")
      includedirNew <- paste0(prefix, "/include")

      if (is.null(arch)) {
        arch = R.version$arch
      }
      if (grepl("i386", arch)) {
        execdir <- paste0(prefix, "/x86/mingw/bin")
      } else {
        execdir <- paste0(prefix, "/x64/mingw/bin")
      }

      cat(paste0('-I"', utils::shortPathName(includedirOld), '" -I"',
                 utils::shortPathName(includedirNew), '" -I"',
                 utils::shortPathName(execdir), '"'))
    } else {
      includedirOld <- paste0(prefix, "/include/opencv4")
      includedirNew <- paste0(prefix, "/include")

      cat(paste0("-I", includedirOld, " -I", includedirNew))
    }
  } else {
    stop("output should be either 'libs' or 'cflags'")
  }
}
