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
#' @return A concatenated character string (with \code{\link{cat}}) of the
#'  configuration options.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'
#' @export
opencvConfig <- function(output = "libs", arch = NULL) {
  pkgPath <- find.package("ROpenCVLite")
  prefix <- paste0(pkgPath, "/opencv")

  if (output == "libs") {
    if (.Platform$OS.type == "windows") {
      if (grepl("i386", arch)) {
        execPrefix <- paste0(prefix, "/x86/mingw")
      } else {
        execPrefix <- paste0(prefix, "/x64/mingw")
      }
      libDir <- paste0(execPrefix, "/lib")
      libs <- gsub("libopencv", "opencv", list.files(libDir, "lib*"))
      libs <- gsub("\\.a", "", libs)
      libs <- gsub("\\.dll", "", libs)
      libs <- paste0("-l", libs)
      cat(paste0('-L"', shortPathName(libDir), '"'), libs)
    } else {
      execPrefix <- prefix
      libDir <- paste0(execPrefix, "/lib")
      pcPath <- "/opencv/lib/pkgconfig/opencv.pc"
      pc <- read.table(paste0(pkgPath, pcPath), sep = "\t")$V1
      libs <- gsub(".*\\/lib ", "", as.character(pc[grepl("Libs:", pc)]))
      cat(paste0("-L", libDir, " ", libs))
    }
  } else if (output == "cflags") {
    includedirOld <- paste0(prefix, "/include/opencv")
    includedirNew <- paste0(prefix, "/include")

    if (.Platform$OS.type == "windows") {
      cat(paste0('-I"', shortPathName(includedirOld), '" -I"', shortPathName(includedirNew), '"'))
    } else {
      cat(paste0("-I", includedirOld, " -I", includedirNew))
    }
  } else {
    stop("output should be either 'libs' or 'cflags'")
  }
}
