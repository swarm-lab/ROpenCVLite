#' @title OpenCV version
#'
#' @description Determines the version of OpenCV installed within R.
#'
#' @return A character string with the version of OpenCV installed by
#'  \code{\link{ROpenCVLite}}.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'
#' @export
opencvVersion <- function() {
  pkgPath <- find.package("ROpenCVLite")

  if (.Platform$OS.type == "windows") {
    pcPath <- "/opencv/OpenCVConfig-version.cmake"
    pc <- read.table(paste0(pkgPath, pcPath), sep = "\t")[1, 1]
    paste0("Version ", gsub(")", "", gsub(".*VERSION ", "", pc)))
  } else {
    pcPath <- "/opencv/lib/pkgconfig/opencv.pc"
    pc <- read.table(paste0(pkgPath, pcPath), sep = "\t")$V1
    as.character(pc[grepl("Version", pc)])
  }
}


#' @title C/C++ configuration options
#'
#' @description Determines the configuration options for compiling C/C++-based
#'  packages against OpenCV installed by \code{\link{ROpenCVLite}}.
#'
#' @param output Either 'libs' for library configuration options or 'cflags' for
#'  C/C++ configuration flags.
#'
#' @param arch architecture relevant for Windows.  If \code{NULL},
#' then \code{R.version$arch} will be used.
#'
#' @return A concatenated character string (with \code{\link{cat}}) of the
#'  configuration options.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#' @importFrom utils read.table
#' @export
opencvConfig <- function(output = "libs", arch = NULL) {
  pkgPath <- find.package("ROpenCVLite")
  prefix <- paste0(pkgPath, "/opencv")

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
      libDir <- paste0(execPrefix, "/lib")
      pcPath <- "/opencv/lib/pkgconfig/opencv.pc"
      pc <- read.table(paste0(pkgPath, pcPath), sep = "\t")$V1
      libs <- gsub(".*\\/lib ", "", as.character(pc[grepl("Libs:", pc)]))
      libs <- c(libs, gsub(".*\\Libs.private: ", "", as.character(pc[grepl("Libs.private:", pc)])))
      if (Sys.info()[1] == "Darwin") {
        cat(paste0("-L", libDir, " ", paste0(libs, collapse = " ")))
      } else {
        cat(paste0("-Wl,-rpath=", libDir, " ", "-L", libDir, " ", paste0(libs, collapse = " ")))
      }
    }
  } else if (output == "cflags") {
    includedirOld <- paste0(prefix, "/include/opencv")
    includedirNew <- paste0(prefix, "/include")

    if (.Platform$OS.type == "windows") {
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
      cat(paste0("-I", includedirOld, " -I", includedirNew))
    }
  } else {
    stop("output should be either 'libs' or 'cflags'")
  }
}
