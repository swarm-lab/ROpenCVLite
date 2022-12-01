#' @title Default Install Location of OpenCV
#'
#' @description This function returns the location at which OpenCV should be
#'  installed by default.
#'
#' @return A character string.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'
#' @examples
#' defaultOpenCVPath()
#'
#' @export
defaultOpenCVPath <- function() {
  pkgPath <- find.package("ROpenCVLite")
  paste0(gsub("ROpenCVLite", "", pkgPath), "ROpenCV")
}


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


#' @title Install OpenCV
#'
#' @description This function attempts to download, compile and install OpenCV
#'  on the system. This process will take several minutes.
#'
#' @param path A character string indicating the location at which OpenCV should
#'  be installed. By default, it is the value returned by
#'  \code{\link{defaultOpenCVPath}}.
#'
#' @param batch A boolean indicating whether to skip (\code{TRUE}) or not
#'  (\code{FALSE}, the default) the interactive installation dialog. This is
#'  useful when OpenCV needs to be installed in a non-interactive environment
#'  (e.g., during a batch installation on a server).
#'
#' @return A boolean.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'
#' @examples
#' \dontrun{
#'  installOpenCV()
#' }
#'
#' @export
installOpenCV <- function(path = defaultOpenCVPath(), batch = FALSE) {
  install <- 0
  path <- normalizePath(path, mustWork = FALSE)

  if (interactive()) {
    if (isOpenCVInstalled()) {
      pkgVersion <- paste0(strsplit(as.character(utils::packageVersion("ROpenCVLite")), "\\.")[[1]][1:2], collapse = "")
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
    if (batch) {
      packageStartupMessage("OpenCV being installed in non-interactive mode!")
      install <- 1
    } else {
      packageStartupMessage("OpenCV can only be installed in interactive mode. To override this in a non-interactive context, use installOpenCV(batch = TRUE).")
    }
  }

  if (!isCmakeInstalled())
    install <- 0

  if (install == 1) {
    pkgPath <- find.package("ROpenCVLite")
    message(paste0("OpenCV will be installed in ", path))
    old <- try(OpenCVPath(), silent = TRUE)

    if (dir.exists(path)) {
      message("Clearing install path.")
      unlink(path, recursive = TRUE)
    }

    if (inherits(path, "try-error")) {
      if (dir.exists(old)) {
        message("Removing old OpenCV installation.")
        unlink(old, recursive = TRUE)
      }
    }

    Sys.setenv(CXX_STD = "CXX11")

    if (.Platform$OS.type == "windows") {
      dir.create(path, showWarnings = FALSE)
      tmpDir <- gsub("\\\\", "/", base::tempdir())
      dir.create(tmpDir, showWarnings = FALSE)

      utils::download.file("https://github.com/opencv/opencv/archive/4.6.0.tar.gz",
                           paste0(tmpDir, "/opencv-4.6.0.tar.gz"))
      utils::untar(paste0(tmpDir, "/opencv-4.6.0.tar.gz"),
                   exdir = tmpDir)

      utils::download.file("https://github.com/opencv/opencv_contrib/archive/4.6.0.tar.gz",
                           paste0(tmpDir, "/opencv_contrib-4.6.0.tar.gz"))
      utils::untar(paste0(tmpDir, "/opencv_contrib-4.6.0.tar.gz"),
                   exdir = tmpDir)

      arch <- c("64", "32")
      archAvail <- c(dir.exists(paste0(R.home(), "/bin/x64")),
                     dir.exists(paste0(R.home(), "/bin/i386")))

      if (any(archAvail)) {
        if (R.Version()$major >= "4") {
          rtools4 <- TRUE
          rtools4Path <- gsub("\\\\", "/", gsub("/usr/bin", "", pkgbuild::rtools_path()[1]))
        } else {
          rtools4 <- FALSE
          chk_rtools <- utils::capture.output(pkgbuild::check_rtools(debug = TRUE))
          rtoolsPath <- gsub(" ", "", gsub("install_path: ", "", chk_rtools[grepl("install_path", chk_rtools)]))
        }

        for (i in 1:2) {
          if (archAvail[i] == TRUE) {
            sourceDir <- paste0(tmpDir, "/opencv-4.6.0/")
            contribDir <- paste0(tmpDir, "/opencv_contrib-4.6.0/modules")
            buildDir <- paste0(sourceDir, "build", arch[i])
            dir.create(buildDir, showWarnings = FALSE)
            openCVArch <- if (arch[i] == 64) "x64" else "x86"

            if (rtools4) {
              if (!grepl("40", pkgbuild::rtools_path())) {
                if (openCVArch == "x64") {
                  gcc_path <- paste0(rtools4Path, "/x86_64-w64-mingw32.static.posix", "/bin/gcc.exe")
                  gpp_path <- paste0(rtools4Path, "/x86_64-w64-mingw32.static.posix", "/bin/g++.exe")
                  windres_path <- paste0(rtools4Path, "/x86_64-w64-mingw32.static.posix", "/bin/windres.exe")
                  make_path <- paste0(rtools4Path, "/usr/bin/make.exe")
                  system(paste0('cmake -G "Unix Makefiles" -DCMAKE_C_COMPILER=', gcc_path, ' -DCMAKE_CXX_COMPILER=', gpp_path, ' -DCMAKE_RC_COMPILER=', windres_path, ' -DCMAKE_MAKE_PROGRAM=', make_path, ' -DENABLE_PRECOMPILED_HEADERS=OFF -DOpenCV_ARCH=', openCVArch, ' -DOpenCV_RUNTIME=mingw -DENABLE_CXX11=ON -DBUILD_ZLIB=ON -DOPENCV_EXTRA_MODULES_PATH=', contribDir, ' -DBUILD_LIST=calib3d,core,dnn,features2d,flann,gapi,highgui,imgcodecs,imgproc,ml,objdetect,photo,stitching,video,videoio,ximgproc -DBUILD_opencv_world=OFF -DBUILD_opencv_contrib_world=OFF -DWITH_OPENMP=ON -DWITH_TBB=ON -DWITH_FFMPEG=ON -DWITH_OPENCL=ON -DWITH_EIGEN=ON -DWITH_OPENCLAMDFFT=ON -DWITH_OPENCLAMDBLAS=ON -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DWITH_DSHOW=ON -DBUILD_PROTOBUF=ON -DOPENCV_ENABLE_ALLOCATOR_STATS=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=', path, ' -B', buildDir, ' -H', sourceDir))
                  system(paste0(make_path, " -j", parallel::detectCores(), " -C ", buildDir))
                  system(paste0(make_path, " -C", buildDir, " install"))
                } else {
                  message("RTools >= 4.2 does not support 32bit builds. Skipping compilation for this architecture.")
                }
              } else {
                gcc_path <- paste0(rtools4Path, "/mingw", arch[i], "/bin/gcc.exe")
                gpp_path <- paste0(rtools4Path, "/mingw", arch[i], "/bin/g++.exe")
                windres_path <- paste0(rtools4Path, "/mingw", arch[i], "/bin/windres.exe")
                make_path <- paste0(rtools4Path, "/usr/bin/make.exe")
                system(paste0('cmake -G "Unix Makefiles" -DCMAKE_C_COMPILER=', gcc_path, ' -DCMAKE_CXX_COMPILER=', gpp_path, ' -DCMAKE_RC_COMPILER=', windres_path, ' -DCMAKE_MAKE_PROGRAM=', make_path, ' -DENABLE_PRECOMPILED_HEADERS=OFF -DOpenCV_ARCH=', openCVArch, ' -DOpenCV_RUNTIME=mingw -DENABLE_CXX11=ON -DBUILD_ZLIB=ON -DOPENCV_EXTRA_MODULES_PATH=', contribDir, ' -DBUILD_LIST=calib3d,core,dnn,features2d,flann,gapi,highgui,imgcodecs,imgproc,ml,objdetect,photo,stitching,video,videoio,ximgproc -DBUILD_opencv_world=OFF -DBUILD_opencv_contrib_world=OFF -DWITH_OPENMP=ON -DWITH_TBB=ON -DWITH_FFMPEG=ON -DWITH_OPENCL=ON -DWITH_EIGEN=ON -DWITH_OPENCLAMDFFT=ON -DWITH_OPENCLAMDBLAS=ON -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DWITH_DSHOW=ON -DBUILD_PROTOBUF=OFF -DOPENCV_ENABLE_ALLOCATOR_STATS=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=', path, ' -B', buildDir, ' -H', sourceDir))
                system(paste0(make_path, " -j", parallel::detectCores(), " -C ", buildDir))
                system(paste0(make_path, " -C", buildDir, " install"))
              }
            } else {
              gcc_path <- paste0(rtoolsPath, "/mingw_", arch[i], "/bin/gcc.exe")
              gpp_path <- paste0(rtoolsPath, "/mingw_", arch[i], "/bin/g++.exe")
              windres_path <- paste0(rtoolsPath, "/mingw_", arch[i], "/bin/windres.exe")
              make_path <- paste0(rtoolsPath, "/mingw_", arch[i], "/bin/mingw32-make.exe")
              system(paste0('cmake -G "Unix Makefiles" -DCMAKE_C_COMPILER=', gcc_path, ' -DCMAKE_CXX_COMPILER=', gpp_path, ' -DCMAKE_RC_COMPILER=', windres_path, ' -DCMAKE_MAKE_PROGRAM=', make_path, ' -DENABLE_PRECOMPILED_HEADERS=OFF  -DOpenCV_ARCH=', openCVArch, ' -DOpenCV_RUNTIME=mingw -DENABLE_CXX11=ON -DBUILD_ZLIB=ON -DOPENCV_EXTRA_MODULES_PATH=', contribDir, ' -DBUILD_LIST=calib3d,core,dnn,features2d,flann,highgui,imgcodecs,imgproc,ml,objdetect,photo,stitching,video,videoio,ximgproc -DBUILD_opencv_world=OFF -DBUILD_opencv_contrib_world=OFF -DWITH_OPENMP=ON -DWITH_TBB=ON -DWITH_FFMPEG=ON -DWITH_OPENCL=ON -DWITH_EIGEN=ON -DWITH_OPENCLAMDFFT=ON -DWITH_OPENCLAMDBLAS=ON -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DWITH_DSHOW=ON -DBUILD_PROTOBUF=OFF -DOPENCV_ENABLE_ALLOCATOR_STATS=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=', path, ' -B', buildDir, ' -H', sourceDir))
              system(paste0(make_path, " -j", parallel::detectCores(), " -C ", buildDir))
              system(paste0(make_path, " -C", buildDir, " install"))
            }
          }
        }
      }
    } else {
      dir.create(path, showWarnings = FALSE)
      tmpDir <- base::tempdir()
      dir.create(tmpDir, showWarnings = FALSE)

      utils::download.file("https://github.com/opencv/opencv/archive/4.6.0.zip",
                           paste0(tmpDir, "/opencv-4.6.0.zip"))
      utils::unzip(paste0(tmpDir, "/opencv-4.6.0.zip"),
                   exdir = tmpDir)

      utils::download.file("https://github.com/opencv/opencv_contrib/archive/4.6.0.zip",
                           paste0(tmpDir, "/opencv_contrib-4.6.0.zip"))
      utils::unzip(paste0(tmpDir, "/opencv_contrib-4.6.0.zip"),
                   exdir = tmpDir)

      file.copy(paste0(pkgPath, "/OpenCVModule.4.6.0.cmake"),
                paste0(tmpDir, "/opencv-4.6.0/cmake/OpenCVModule.cmake"),
                overwrite = TRUE)

      sourceDir <- paste0(tmpDir, "/opencv-4.6.0/")
      contribDir <- paste0(tmpDir, "/opencv_contrib-4.6.0/modules")
      buildDir <- paste0(sourceDir, "build")
      dir.create(buildDir, showWarnings = FALSE)

      if (grepl("Apple clang", system("c++ --version", intern = TRUE))[1]) {
        system(paste0("cmake -DOPENCV_EXTRA_MODULES_PATH=", contribDir, " -DBUILD_LIST=calib3d,core,dnn,features2d,flann,gapi,highgui,imgcodecs,imgproc,ml,objdetect,photo,stitching,video,videoio,ximgproc -DBUILD_opencv_world=OFF -DBUILD_opencv_contrib_world=OFF -DWITH_IPP=ON -DWITH_TBB=ON -DWITH_FFMPEG=ON -DWITH_AVFOUNDATION=ON -DWITH_OPENCL=ON -DWITH_EIGEN=ON -DWITH_OPENCLAMDFFT=ON -DWITH_OPENCLAMDBLAS=ON -D BUILD_ZLIB=OFF -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DINSTALL_CREATE_DISTRIB=ON -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=", path, " -B", buildDir, ' -H', sourceDir))
      } else {
        arch <- system("uname -m", intern = TRUE)
        if (grepl("aarch", arch) | grepl("arm", arch)) {
          system(paste0("cmake -DOPENCV_EXTRA_MODULES_PATH=", contribDir, " -DBUILD_LIST=calib3d,core,dnn,features2d,flann,gapi,highgui,imgcodecs,imgproc,ml,objdetect,photo,stitching,video,videoio,ximgproc -DBUILD_opencv_world=OFF -DBUILD_opencv_contrib_world=OFF -DWITH_IPP=OFF -DWITH_OPENMP=ON -DWITH_TBB=ON -DWITH_FFMPEG=ON -DWITH_V4L=ON -DWITH_OPENCL=ON -DWITH_EIGEN=ON -DWITH_OPENCLAMDFFT=ON -DWITH_OPENCLAMDBLAS=ON -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DINSTALL_CREATE_DISTRIB=ON -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=", path, " -B", buildDir, ' -H', sourceDir))
        } else {
          system(paste0("cmake cmake -DOPENCV_EXTRA_MODULES_PATH=", contribDir, " -DBUILD_LIST=calib3d,core,dnn,features2d,flann,gapi,highgui,imgcodecs,imgproc,ml,objdetect,photo,stitching,video,videoio,ximgproc -DBUILD_opencv_world=OFF -DBUILD_opencv_contrib_world=OFF -DWITH_IPP=ON -DWITH_OPENMP=ON -DWITH_TBB=ON -DWITH_FFMPEG=ON -DWITH_V4L=ON -DWITH_OPENCL=ON -DWITH_EIGEN=ON -DWITH_OPENCLAMDFFT=ON -DWITH_OPENCLAMDBLAS=ON -DBUILD_PERF_TESTS=OFF -DBUILD_TESTS=OFF -DINSTALL_CREATE_DISTRIB=ON -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=", path, " -B", buildDir, ' -H', sourceDir))
        }
      }

      system(paste0("make -j", parallel::detectCores(), " -C ", buildDir))
      system(paste0("make -C ", buildDir, " all install"))
    }

    writeLines(path, con = paste0(pkgPath, "/path"))
  } else {
    packageStartupMessage("OpenCV was not installed at this time. You can install it at any time by using the installOpenCV() function.")
  }

  isOpenCVInstalled()
}


#' @title Remove OpenCV
#'
#' @description This function removes OpenCV from the system.
#'
#' @return A boolean.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'
#' @examples
#' \dontrun{
#'  installOpenCV()
#' }
#'
#' @export
removeOpenCV <- function() {
  if (isOpenCVInstalled()) {
    uninstall <- utils::menu(c("yes", "no"), title = "Would you like to completely remove OpenCV from your R installation? You can reinstall it at any time by using the installOpenCV() function.")
    print(uninstall)

    if (uninstall == 1) {
      unlink(OpenCVPath(), recursive = TRUE)
      !isOpenCVInstalled()
    } else {
      !isOpenCVInstalled()
    }
  } else {
    message("OpenCV is not installed on this system. Nothing to be done.")
    !isOpenCVInstalled()
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
