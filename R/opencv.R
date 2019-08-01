#' @title Check OpenCV Installation
#'
#' @description This functions checks that OpenCV is installed within the R
#'  library.
#'
#' @return A boolean indicating whether OpenCV was or not installed on the system.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'
#' @examples
#' isOpenCVInstalled()
#'
#' @export
isOpenCVInstalled <- function() {
  pkgPath <- find.package("ROpenCVLite")
  installPath <- gsub("ROpenCVLite", "", pkgPath)
  dir.exists(paste0(installPath, "/opencv/include/"))
}


#' @title Install OpenCV
#'
#' @description This function will attempt to download, compile and install
#'  OpenCV on the system. This process will take several minutes.
#'
#' @return A boolean indicating whether OpenCV was or not installed on the system.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'
#' @examples
#' \dontrun{
#'  installOpenCV()
#' }
#'
#' @export
installOpenCV <- function() {
  install <- 0

  if (interactive()) {
    if (isOpenCVInstalled()) {
      pkgVersion <- unlist(strsplit(as.character(utils::packageVersion("ROpenCVLite")), "\\."))[3]
      cvVersion <- gsub("\\D+", "", opencvVersion())

      if (pkgVersion == cvVersion) {
        install <- utils::menu(c("yes", "no"), title = "OpenCV is already installed on this system. Would you like to reinstall it now? This will take several minutes.")
      } else {
        install <- utils::menu(c("yes", "no"), title = "A new version of OpenCV is available. Would you like to install it now? This will take several minutes.")
      }
    } else {
      install <- utils::menu(c("yes", "no"), title = "OpenCV is not installed on this system. Would you like to install it now? This will take several minutes.")
    }
  } else {
    warning("OpenCV can only be installed in interactive mode.")
  }

  if (install == 1) {
    pkgPath <- find.package("ROpenCVLite")
    installPath <- gsub("ROpenCVLite", "", pkgPath)
    openCVPath <- paste0(installPath, "opencv")
    message(paste0("OpenCV will be installed in ", openCVPath))

    Sys.setenv(CXX_STD = "CXX11")

    if (.Platform$OS.type == "windows") {
      dir.create(openCVPath, showWarnings = FALSE)
      tmpDir <- base::tempdir()
      dir.create(tmpDir, showWarnings = FALSE)

      utils::download.file("https://github.com/opencv/opencv/archive/4.1.0.tar.gz",
                           paste0(tmpDir, "/opencv-4.1.0.tar.gz"))
      utils::untar(paste0(tmpDir, "/opencv-4.1.0.tar.gz"),
                   exdir = tmpDir)

      file.copy(paste0(pkgPath, "/OpenCVDetectDirectX.4.1.0.cmake"),
                paste0(tmpDir, "/opencv-4.1.0/cmake/OpenCVDetectDirectX.cmake"),
                overwrite = TRUE)
      file.copy(paste0(pkgPath, "/OpenCVDetectOpenCL.4.1.0.cmake"),
                paste0(tmpDir, "/opencv-4.1.0/cmake/OpenCVDetectOpenCL.cmake"),
                overwrite = TRUE)

      arch <- c("64", "32")
      archAvail <- c(dir.exists(paste0(R.home(), "/bin/x64")),
                     dir.exists(paste0(R.home(), "/bin/i386")))

      if (any(archAvail)) {
        pkgbuild::check_rtools()
        rtoolsPath <- gsub("/bin", "", pkgbuild::rtools_path())

        for (i in 1:2) {
          if (archAvail[i]) {
            sourceDir <- paste0(tmpDir, "/opencv-4.1.0/")
            buildDir <- paste0(sourceDir, "build", arch[i])
            dir.create(buildDir, showWarnings = FALSE)
            system(paste0('cmake -G "Unix Makefiles" -DCMAKE_C_COMPILER=', rtoolsPath, '/mingw_', arch[i], '/bin/gcc.exe -DCMAKE_CXX_COMPILER=', rtoolsPath, '/mingw_', arch[i], '/bin/g++.exe -DCMAKE_RC_COMPILER=', rtoolsPath, '/mingw_', arch[i], '/bin/windres.exe -DCMAKE_MAKE_PROGRAM=', rtoolsPath, '/mingw_', arch[i], '/bin/mingw32-make.exe -DENABLE_PRECOMPILED_HEADERS=OFF -DENABLE_CXX11=ON -DBUILD_ZLIB=ON -DBUILD_opencv_world=OFF -DBUILD_opencv_contrib_world=OFF -DBUILD_matlab=OFF -DBUILD_opencv_java=OFF -DBUILD_opencv_python2=OFF -DBUILD_opencv_python3=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DWITH_MSMF=OFF -DBUILD_PROTOBUF=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=', openCVPath, ' -B', buildDir, ' -H', sourceDir))
            system(paste0(rtoolsPath, "/mingw_", arch[i], "/bin/mingw32-make.exe -j",
                          parallel::detectCores(), " -C ", buildDir))
            system(paste0(rtoolsPath, "/mingw_", arch[i], "/bin/mingw32-make.exe -C",
                          buildDir, " install"))
          }
        }
      }
    } else {
      dir.create(openCVPath, showWarnings = FALSE)
      tmpDir <- base::tempdir()
      dir.create(tmpDir, showWarnings = FALSE)

      utils::download.file("https://github.com/opencv/opencv/archive/4.1.0.zip",
                           paste0(tmpDir, "/opencv-4.1.0.zip"))
      utils::unzip(paste0(tmpDir, "/opencv-4.1.0.zip"),
                   exdir = tmpDir)

      file.copy(paste0(pkgPath, "/OpenCVModule.4.1.0.cmake"),
                paste0(tmpDir, "/opencv-4.1.0/cmake/OpenCVModule.cmake"),
                overwrite = TRUE)

      sourceDir <- paste0(tmpDir, "/opencv-4.1.0/")
      buildDir <- paste0(sourceDir, "build")
      dir.create(buildDir, showWarnings = FALSE)
      system(paste0("cmake -DWITH_IPP=ON -DBUILD_opencv_world=OFF -DBUILD_opencv_contrib_world=OFF -DBUILD_opencv_matlab=OFF -DBUILD_opencv_java=OFF -DBUILD_opencv_python2=OFF -DBUILD_opencv_python3=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DINSTALL_CREATE_DISTRIB=ON -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=", openCVPath, " -B", buildDir, ' -H', sourceDir))
      system(paste0("make -j", parallel::detectCores(), " -C ", buildDir))
      system(paste0("make -C ", buildDir, " all install"))
    }
  } else {
    message("OpenCV was not installed at this time. You can install it at any time by using the installOpenCV() function in interactive mode.")
  }

  isOpenCVInstalled()
}


#' @title OpenCV version
#'
#' @description Determines the version of OpenCV installed within R.
#'
#' @return A character string with the version of OpenCV installed by
#'  \code{\link{ROpenCVLite}}.
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
    pkgPath <- find.package("ROpenCVLite")
    installPath <- gsub("ROpenCVLite", "", pkgPath)

    if (.Platform$OS.type == "windows") {
      pcPath <- "/opencv/OpenCVConfig-version.cmake"
      pc <- utils::read.table(paste0(installPath, pcPath), sep = "\t")[1, 1]
      paste0("Version ", gsub(")", "", gsub(".*VERSION ", "", pc)))
    } else {
      pcPath <- "/opencv/lib/cmake/opencv4/OpenCVConfig-version.cmake"
      pc <- utils::read.table(paste0(installPath, pcPath), sep = "\t")[1, 1]
      paste0("Version ", gsub(")", "", gsub(".*VERSION ", "", pc)))
    }
  } else {
    stop("OpenCV is not installed on this system. Please use installOpenCV() to install it.")
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
#'
#' @examples
#' if (isOpenCVInstalled()) {
#'   opencvConfig()
#'   opencvConfig(output = "cflags")
#'   opencvConfig(arch = R.version$arch)
#' }
#'
#' @export
opencvConfig <- function(output = "libs", arch = NULL) {
  if (!isOpenCVInstalled())
    stop("OpenCV is not installed on this system. Please use installOpenCV() to install it.")

  pkgPath <- find.package("ROpenCVLite")
  installPath <- gsub("ROpenCVLite", "", pkgPath)
  prefix <- paste0(installPath, "opencv")

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
