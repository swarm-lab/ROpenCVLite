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
#' \dontrun{
#'  defaultOpenCVPath()
#' }
#'
#' @export
defaultOpenCVPath <- function() {
  pkgPath <- find.package("ROpenCVLite")
  paste0(gsub("ROpenCVLite", "", pkgPath), "ROpenCV")
}


.configure <- function(install_path = defaultOpenCVPath(), version) {
  config <- list()

  config$arch <- unname(Sys.info()["machine"])
  if (!grepl("64", config$arch))
    stop("Unsupported CPU architecture.")

  config$os_type <- .Platform$OS.type

  if (config$os_type == "windows") {
    config$install_path <- utils::shortPathName(install_path)
    config$pkg_path <- utils::shortPathName(find.package("ROpenCVLite"))
    config$os <- gsub("\r", "", gsub("Caption=", "", system('wmic os get Caption,CSDVersion /value', intern = TRUE)[3]))
    config$core <- paste0("https://github.com/opencv/opencv/archive/", version, ".tar.gz")
    config$contrib <- paste0("https://github.com/opencv/opencv_contrib/archive/", version, ".tar.gz")
    rtools <- .findRtools()
    config$rtools_path <- rtools$path
    config$rtools_version <- rtools$version

    if (config$rtools_version < "4.2") {
      config$cmake_path <- utils::shortPathName(system("where cmake.exe", intern = TRUE))

      if (length(config$cmake_path) > 1) {
        v <- sapply(config$cmake_path, function(cmake) gsub("cmake version ", "", system(paste0(cmake, " --version"), intern = TRUE)[1]))
        config$cmake_path <- config$cmake_path[which(v == max(v))]
      }

      config$gcc_path <- paste0(config$rtools_path, "\\mingw64\\bin\\gcc.exe")
      config$gpp_path <- paste0(config$rtools_path, "\\mingw64\\bin\\g++.exe")
      config$windres_path <- paste0(config$rtools_path, "\\mingw64\\bin\\windres.exe")
      config$make_path <- paste0(config$rtools_path, "\\usr\\bin\\make.exe")
    } else {
      config$cmake_path <- paste0(config$rtools_path, "\\x86_64-w64-mingw32.static.posix\\bin\\cmake.exe")
      config$gcc_path <- paste0(config$rtools_path, "\\x86_64-w64-mingw32.static.posix\\bin\\gcc.exe")
      config$gpp_path <- paste0(config$rtools_path, "\\x86_64-w64-mingw32.static.posix\\bin\\g++.exe")
      config$windres_path <- paste0(config$rtools_path, "\\x86_64-w64-mingw32.static.posix\\bin\\windres.exe")
      config$make_path <- paste0(config$rtools_path, "\\usr\\bin\\make.exe")
    }

    config$tmp_dir <- base::tempdir()
    config$source_dir <- paste0(config$tmp_dir, "\\opencv-", version, "\\")
    config$contrib_dir <- paste0(config$tmp_dir, "\\opencv_contrib-", version, "\\modules")
    config$build_dir <- paste0(config$source_dir, "build")

    ix <- grepl("path", names(config)) | grepl("dir", names(config))
    config[ix] <- lapply(config[ix], function(st) gsub("\\\\", "/", utils::shortPathName(st)))
  } else if (config$os_type == "unix") {
    config$install_path <- install_path
    config$pkg_path <- find.package("ROpenCVLite")
    config$os <- unname(Sys.info()["sysname"])
    config$core <- paste0("https://github.com/opencv/opencv/archive/", version, ".zip")
    config$contrib <- paste0("https://github.com/opencv/opencv_contrib/archive/", version, ".zip")
    config$cmake_path <- system("which cmake", intern = TRUE)
    config$gcc_path <- system("which gcc", intern = TRUE)
    config$gpp_path <- system("which g++", intern = TRUE)
    config$make_path <- system("which make", intern = TRUE)
    config$tmp_dir <- base::tempdir()
    config$source_dir <- paste0(config$tmp_dir, "/opencv-", version, "/")
    config$contrib_dir <- paste0(config$tmp_dir, "/opencv_contrib-", version, "/modules")
    config$build_dir <- paste0(config$source_dir, "build")

    ix <- grepl("path", names(config)) | grepl("dir", names(config))
    config[ix] <- lapply(config[ix], normalizePath, mustWork = FALSE, winslash = "/")
  } else {
    stop("Unsupported OS type.")
  }

  config
}


.cmake <- function(config) {
  paste0(
    '"', config$cmake_path, '"',
    ' -G "Unix Makefiles"',
    ' -Wno-dev',
    ' -DCMAKE_C_COMPILER="', config$gcc_path, '"',
    ' -DCMAKE_CXX_COMPILER="', config$gpp_path, '"',
    switch(config$os_type,
           windows = paste0(' -DCMAKE_RC_COMPILER="', config$windres_path, '"',
                            ' -DOpenCV_ARCH=x64',
                            ' -DOpenCV_RUNTIME=mingw',
                            ' -DBUILD_SHARED_LIBS=ON',
                            ' -DCPU_DISPATCH=SSE4_1,SSE4_2,FP16,AV')
    ),
    ' -DCMAKE_MAKE_PROGRAM="', config$make_path, '"',
    ' -DCMAKE_CXX_STANDARD=11',
    ' -DENABLE_PRECOMPILED_HEADERS=OFF',
    ' -DOPENCV_EXTRA_MODULES_PATH=', config$contrib_dir,
    ' -DBUILD_LIST=calib3d,core,dnn,features2d,flann,gapi,highgui,imgcodecs,imgproc,ml,objdetect,photo,stitching,video,videoio,ximgproc,wechat_qrcode',
    ' -DOPENCV_GENERATE_PKGCONFIG=ON',
    ' -DWITH_OPENMP=ON',
    ' -DWITH_TBB=ON',
    ' -DWITH_EIGEN=ON',
    ' -DWITH_LAPACK=ON',
    ' -DBUILD_opencv_world=OFF',
    ' -DBUILD_opencv_contrib_world=OFF',
    ' -DBUILD_PERF_TESTS=OFF',
    ' -DBUILD_TESTS=OFF',
    ' -DCMAKE_C_FLAGS_RELEASE="-fstack-protector-strong"',
    ' -DCMAKE_CXX_FLAGS_RELEASE="-fstack-protector-strong"',
    ' -DINSTALL_CREATE_DISTRIB=ON',
    ' -DCMAKE_BUILD_TYPE=RELEASE',
    ' -DCMAKE_INSTALL_PREFIX="', config$install_path, '"',
    ' -B"', config$build_dir, '"',
    ' -H"', config$source_dir, '"'
  )
}


#' @title Install OpenCV
#'
#' @description This function attempts to download, compile and install OpenCV
#'  on the system. This process will take several minutes.
#'
#' @param install_path A character string indicating the location at which
#'  OpenCV should be installed. By default, it is the value returned by
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
installOpenCV <- function(install_path = defaultOpenCVPath(), batch = FALSE) {
  install <- 0
  pkg_version <- paste0(
    strsplit(as.character(utils::packageVersion("ROpenCVLite")), "")[[1]][c(1, 3, 4)],
    collapse = ".")

  if (interactive()) {
    if (isOpenCVInstalled()) {
      cv_version <- gsub("Version ", "", opencvVersion())

      if (pkg_version == cv_version) {
        install <- utils::menu(
          c("yes", "no"),
          title = "OpenCV is already installed on this system. Would you like to reinstall it now? This will take several minutes.")
      } else {
        install <- utils::menu(
          c("yes", "no"),
          title = "A new version of OpenCV is available. Would you like to install it now? This will take several minutes.")
      }
    } else {
      install <- utils::menu(
        c("yes", "no"),
        title = "OpenCV is not installed on this system. Would you like to install it now? This will take several minutes.")
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
    config <- .configure(normalizePath(install_path, mustWork = FALSE), pkg_version)
    message(paste0("OpenCV will be installed in ", config$install_path))
    old <- try(OpenCVPath(), silent = TRUE)

    if (dir.exists(config$install_path)) {
      message("Clearing install path.")
      unlink(config$install_path, recursive = TRUE)
    }

    if (inherits(config$install_path, "try-error")) {
      if (dir.exists(old)) {
        message("Removing old OpenCV installation.")
        unlink(old, recursive = TRUE)
      }
    }

    dir.create(config$install_path, showWarnings = FALSE)
    dir.create(config$tmp_dir, showWarnings = FALSE)

    if (config$os_type == "windows") {
      utils::download.file(config$core, paste0(config$tmp_dir, "/opencv.tar.gz"))
      utils::untar(paste0(config$tmp_dir, "/opencv.tar.gz"), exdir = config$tmp_dir)
      utils::download.file(config$contrib, paste0(config$tmp_dir, "/opencv_contrib.tar.gz"))
      utils::untar(paste0(config$tmp_dir, "/opencv_contrib.tar.gz"), exdir = config$tmp_dir)
    } else {
      utils::download.file(config$core, paste0(config$tmp_dir, "/opencv.zip"))
      utils::unzip(paste0(config$tmp_dir, "/opencv.zip"), exdir = config$tmp_dir)
      utils::download.file(config$contrib, paste0(config$tmp_dir, "/opencv_contrib.zip"))
      utils::unzip(paste0(config$tmp_dir, "/opencv_contrib.zip"), exdir = config$tmp_dir)

      tmp <- readLines(paste0(config$source_dir, "cmake/OpenCVModule.cmake"))
      ix <- which(grepl("# adds dependencies to OpenCV module", tmp)) - 1
      insert <- c(
        '# set CMAKE_INSTALL_NAME_DIR if CMAKE_INSTALL_PREFIX isn\'t default value of "/usr/local"',
        'if(UNIX AND NOT ${CMAKE_INSTALL_PREFIX} STREQUAL "/usr/local")',
        '  set(CMAKE_INSTALL_NAME_DIR ${CMAKE_INSTALL_PREFIX}/lib)',
        '#  message ("setting CMAKE_INSTALL_NAME_DIR: ${CMAKE_INSTALL_NAME_DIR}")',
        'endif()',
        ''
      )
      writeLines(c(tmp[1:ix], insert, tmp[(ix + 1):length(tmp)]),
                 paste0(config$source_dir, "cmake/OpenCVModule.cmake"))
    }

    dir.create(config$build_dir, showWarnings = FALSE)
    system(.cmake(config))
    system(paste0(config$make_path, " -j", parallel::detectCores(), " -C ", config$build_dir))
    system(paste0(config$make_path, " -C", config$build_dir, " install"))
    writeLines(config$install_path, con = paste0(config$pkg_path, "/path"))
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
    uninstall <- utils::menu(
      c("yes", "no"),
      title = "Would you like to completely remove OpenCV from your R installation? You can reinstall it at any time by using the installOpenCV() function.")
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
