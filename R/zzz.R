.onLoad <- function(lib, pkg) {
  cvPath <- tryCatch(OpenCVPath(), error = function(e) NULL)
  if (is.null(cvPath)) return(invisible(NULL))

  if (.Platform$OS.type == "windows") {
    opath <- Sys.getenv("PATH")
    binPath <- if (.Platform$r_arch == "i386") {
      file.path(cvPath, "x86", "mingw", "bin")
    } else {
      file.path(cvPath, "x64", "mingw", "bin")
    }
    binPath <- utils::shortPathName(binPath)
    Sys.setenv(PATH = paste(binPath, opath, sep = ";"))
  }

  if (Sys.info()[["sysname"]] == "Linux") {
    libPath <- file.path(cvPath, "lib")
    Sys.setenv(LD_LIBRARY_PATH = paste0(Sys.getenv("LD_LIBRARY_PATH"), ":", libPath))
  }
}

.onAttach <- function(lib, pkg) {
  pkg_cv_version <- package_version(.opencv_version)

  needs_install <- if (!ROpenCVLite::isOpenCVInstalled()) {
    TRUE
  } else {
    installed_version <- tryCatch(
      package_version(gsub("Version ", "", ROpenCVLite::opencvVersion())),
      error = function(e) NULL
    )
    is.null(installed_version) ||
      installed_version$major != pkg_cv_version$major ||
      installed_version$minor != pkg_cv_version$minor
  }

  if (needs_install) {
    packageStartupMessage(
      "OpenCV is not installed or needs updating. ",
      "Run installOpenCV() to install it."
    )
  }
}
