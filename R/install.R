.opencv_version <- "4.13.0"

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
#' defaultOpenCVPath()
#' }
#'
#' @export
defaultOpenCVPath <- function() {
  pkgPath <- find.package("ROpenCVLite")
  file.path(dirname(pkgPath), "ROpenCV")
}


.configure <- function(install_path = defaultOpenCVPath(), version) {
  config <- list()

  config$arch <- unname(Sys.info()["machine"])
  if (!grepl("64", config$arch)) {
    stop("Unsupported CPU architecture.")
  }

  config$os_type <- .Platform$OS.type

  if (config$os_type == "windows") {
    config$install_path <- utils::shortPathName(install_path)
    config$pkg_path <- utils::shortPathName(find.package("ROpenCVLite"))
    config$os <- gsub("\r", "", gsub("Caption=", "", system("wmic os get Caption,CSDVersion /value", intern = TRUE)[3]))
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
    config$cache_dir <- gsub("\\\\", "/", utils::shortPathName(tools::R_user_dir("ROpenCVLite", "cache")))
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
    config$cache_dir <- tools::R_user_dir("ROpenCVLite", "cache")
  } else {
    stop("Unsupported OS type.")
  }

  config
}


.cmake <- function(config) {
  args <- c(
    "-G", "Unix Makefiles",
    "-Wno-dev",
    paste0("-DCMAKE_C_COMPILER=", config$gcc_path),
    paste0("-DCMAKE_CXX_COMPILER=", config$gpp_path)
  )

  if (config$os_type == "windows") {
    args <- c(args,
      paste0("-DCMAKE_RC_COMPILER=", config$windres_path),
      "-DOpenCV_ARCH=x64",
      "-DOpenCV_RUNTIME=mingw",
      "-DBUILD_SHARED_LIBS=ON",
      if (config$optimize_for_host) c("-DCPU_BASELINE=DETECT", "-DCPU_DISPATCH=DETECT")
      else "-DCPU_DISPATCH=SSE4_1,SSE4_2,FP16,AV"
    )
  }

  if (config$os == "Darwin" && grepl("arm", config$arch)) {
    args <- c(args, "-DCMAKE_OSX_ARCHITECTURES=arm64")
  }

  if (config$os_type != "windows" && config$optimize_for_host) {
    args <- c(args, "-DCPU_BASELINE=DETECT", "-DCPU_DISPATCH=DETECT")
  }

  if (nchar(config$ccache_launcher) > 0) {
    args <- c(args,
      paste0("-DCMAKE_C_COMPILER_LAUNCHER=", config$ccache_launcher),
      paste0("-DCMAKE_CXX_COMPILER_LAUNCHER=", config$ccache_launcher)
    )
  }

  args <- c(args,
    paste0("-DCMAKE_MAKE_PROGRAM=", config$make_path),
    "-DCMAKE_CXX_STANDARD=11",
    "-DENABLE_PRECOMPILED_HEADERS=OFF",
    paste0("-DOPENCV_EXTRA_MODULES_PATH=", config$contrib_dir),
    paste0("-DBUILD_LIST=", paste(config$modules, collapse = ",")),
    "-DOPENCV_GENERATE_PKGCONFIG=ON",
    "-DWITH_OPENMP=ON",
    "-DWITH_TBB=ON",
    "-DWITH_EIGEN=ON",
    "-DWITH_LAPACK=ON",
    "-DBUILD_opencv_world=OFF",
    "-DBUILD_opencv_contrib_world=OFF",
    "-DBUILD_PERF_TESTS=OFF",
    "-DBUILD_TESTS=OFF",
    "-DCMAKE_C_FLAGS_RELEASE=-fstack-protector-strong",
    "-DCMAKE_CXX_FLAGS_RELEASE=-fstack-protector-strong",
    "-DINSTALL_CREATE_DISTRIB=ON",
    "-DCMAKE_BUILD_TYPE=RELEASE",
    paste0("-DCMAKE_INSTALL_PREFIX=", config$install_path),
    paste0("-B", config$build_dir),
    paste0("-H", config$source_dir)
  )

  list(command = config$cmake_path, args = args)
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
#' @param use_ccache A boolean indicating whether to use \code{ccache}
#'  (\code{TRUE}) to speed up repeated compilations. Requires \code{ccache} to
#'  be installed and on the PATH. Defaults to \code{FALSE}.
#'
#' @param optimize_for_host A boolean indicating whether to let CMake detect
#'  and use the host CPU's full instruction set (\code{TRUE}) instead of the
#'  defaults (\code{FALSE}). On Windows the default is a conservative
#'  SSE4/AVX-limited build; on Unix/macOS CMake's own defaults apply. Setting
#'  this to \code{TRUE} produces a faster binary on the build machine but the
#'  result may not run on other hardware.
#'
#' @param modules A character vector of OpenCV modules to compile. Defaults to
#'  the full set supported by \code{ROpenCVLite}. Specify a subset to reduce
#'  compilation time when only specific functionality is needed.
#'
#' @return A boolean.
#'
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'
#' @examples
#' \dontrun{
#' installOpenCV()
#' }
#'
#' @export
installOpenCV <- function(install_path = defaultOpenCVPath(), batch = FALSE,
                          use_ccache = FALSE, optimize_for_host = FALSE,
                          modules = c("calib3d", "core", "dnn", "features2d",
                                      "flann", "gapi", "highgui", "imgcodecs",
                                      "imgproc", "ml", "objdetect", "photo",
                                      "stitching", "video", "videoio",
                                      "ximgproc", "wechat_qrcode")) {
  modules <- match.arg(modules, several.ok = TRUE)
  install <- 0
  pkg_version <- .opencv_version

  if (interactive()) {
    if (isOpenCVInstalled()) {
      cv_version <- gsub("Version ", "", opencvVersion())

      if (pkg_version == cv_version) {
        install <- utils::menu(
          c("yes", "no"),
          title = "OpenCV is already installed on this system. Would you like to reinstall it now? This will take several minutes."
        )
      } else {
        install <- utils::menu(
          c("yes", "no"),
          title = "A new version of OpenCV is available. Would you like to install it now? This will take several minutes."
        )
      }
    } else {
      install <- utils::menu(
        c("yes", "no"),
        title = "OpenCV is not installed on this system. Would you like to install it now? This will take several minutes."
      )
    }
  } else {
    if (batch) {
      message("OpenCV being installed in non-interactive mode!")
      install <- 1
    } else {
      message("OpenCV can only be installed in interactive mode. To override this in a non-interactive context, use installOpenCV(batch = TRUE).")
    }
  }

  if (!isCmakeInstalled()) {
    install <- 0
  }

  if (install == 1) {
    config <- .configure(normalizePath(install_path, mustWork = FALSE), pkg_version)

    config$optimize_for_host <- optimize_for_host
    config$modules <- modules

    if (use_ccache) {
      ccache <- Sys.which("ccache")
      if (nchar(ccache) == 0)
        warning("use_ccache = TRUE but ccache was not found on PATH; ignoring.")
      config$ccache_launcher <- ccache
    } else {
      config$ccache_launcher <- ""
    }

    message(paste0("OpenCV will be installed in ", config$install_path))
    old <- try(OpenCVPath(), silent = TRUE)

    if (dir.exists(config$install_path)) {
      message("Clearing install path.")
      unlink(config$install_path, recursive = TRUE)
    }

    if (!inherits(old, "try-error")) {
      if (dir.exists(old)) {
        message("Removing old OpenCV installation.")
        unlink(old, recursive = TRUE)
      }
    }

    dir.create(config$install_path, showWarnings = FALSE)
    dir.create(config$tmp_dir, showWarnings = FALSE)

    on.exit({
      unlink(paste0(config$tmp_dir, "/opencv-", pkg_version), recursive = TRUE, force = TRUE)
      unlink(paste0(config$tmp_dir, "/opencv_contrib-", pkg_version), recursive = TRUE, force = TRUE)
    }, add = TRUE)

    dir.create(config$cache_dir, showWarnings = FALSE, recursive = TRUE)

    if (config$os_type == "windows") {
      core_archive <- paste0(config$cache_dir, "/opencv-", pkg_version, ".tar.gz")
      contrib_archive <- paste0(config$cache_dir, "/opencv_contrib-", pkg_version, ".tar.gz")
      if (!file.exists(core_archive))
        utils::download.file(config$core, core_archive)
      if (!file.exists(contrib_archive))
        utils::download.file(config$contrib, contrib_archive)
      utils::untar(core_archive, exdir = config$tmp_dir)
      utils::untar(contrib_archive, exdir = config$tmp_dir)
    } else {
      core_archive <- paste0(config$cache_dir, "/opencv-", pkg_version, ".zip")
      contrib_archive <- paste0(config$cache_dir, "/opencv_contrib-", pkg_version, ".zip")
      if (!file.exists(core_archive))
        utils::download.file(config$core, core_archive)
      if (!file.exists(contrib_archive))
        utils::download.file(config$contrib, contrib_archive)
      utils::unzip(core_archive, exdir = config$tmp_dir)
      utils::unzip(contrib_archive, exdir = config$tmp_dir)

      tmp <- readLines(paste0(config$source_dir, "cmake/OpenCVModule.cmake"))
      if (!any(grepl("CMAKE_INSTALL_NAME_DIR", tmp))) {
        ix <- which(grepl("# adds dependencies to OpenCV module", tmp)) - 1
        insert <- c(
          '# set CMAKE_INSTALL_NAME_DIR if CMAKE_INSTALL_PREFIX isn\'t default value of "/usr/local"',
          'if(UNIX AND NOT ${CMAKE_INSTALL_PREFIX} STREQUAL "/usr/local")',
          "  set(CMAKE_INSTALL_NAME_DIR ${CMAKE_INSTALL_PREFIX}/lib)",
          '#  message ("setting CMAKE_INSTALL_NAME_DIR: ${CMAKE_INSTALL_NAME_DIR}")',
          "endif()",
          ""
        )
        writeLines(
          c(tmp[1:ix], insert, tmp[(ix + 1):length(tmp)]),
          paste0(config$source_dir, "cmake/OpenCVModule.cmake")
        )
      }
    }

    # To be removed once the CMake 4 issue is resolved in the next OpenCV release
    tmp <- readLines(paste0(config$source_dir, "cmake/OpenCVGenPkgconfig.cmake"))
    ix <- which(grepl("cmake_minimum_required", tmp))
    insert <- "cmake_minimum_required(VERSION 3.5)"
    writeLines(
      c(tmp[1:(ix - 1)], insert, tmp[(ix + 1):length(tmp)]),
      paste0(config$source_dir, "cmake/OpenCVGenPkgconfig.cmake")
    )

    dir.create(config$build_dir, showWarnings = FALSE)

    message("Configuring OpenCV build...")
    cmake <- .cmake(config)
    cmake_cmd <- paste(c(shQuote(cmake$command), shQuote(cmake$args)), collapse = " ")
    if (system(cmake_cmd) != 0)
      stop("CMake configuration failed. See output above for details.")

    message("Compiling OpenCV (this will take several minutes)...")
    n_cores <- max(1L, parallel::detectCores(logical = FALSE), na.rm = TRUE)
    if (system2(config$make_path, c(paste0("-j", n_cores), "-C", config$build_dir)) != 0)
      stop("OpenCV compilation failed. See output above for details.")

    message("Installing OpenCV...")
    if (system2(config$make_path, c("-C", config$build_dir, "install")) != 0)
      stop("OpenCV installation failed. See output above for details.")

    writeLines(config$install_path, con = paste0(config$pkg_path, "/path"))
  } else {
    message("OpenCV was not installed at this time. You can install it at any time by using the installOpenCV() function.")
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
#' installOpenCV()
#' }
#'
#' @export
removeOpenCV <- function() {
  if (isOpenCVInstalled()) {
    uninstall <- utils::menu(
      c("yes", "no"),
      title = "Would you like to completely remove OpenCV from your R installation? You can reinstall it at any time by using the installOpenCV() function."
    )

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
