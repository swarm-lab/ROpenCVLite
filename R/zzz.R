.onLoad <- function(lib, pkg) {
  if (.Platform$OS.type == "windows") {
    pkgPath <- find.package("ROpenCVLite")
    installPath <- gsub("ROpenCVLite", "", pkgPath)
    opath <- Sys.getenv("PATH")
    binPath <- if (.Platform$r_arch == "i386") "/opencv/x86/mingw/bin" else "/opencv/x64/mingw/bin"
    binPath <- utils::shortPathName(paste0(installPath, binPath))
    Sys.setenv(PATH = paste(binPath, opath, sep = ";"))
  }

  if (Sys.info()[["sysname"]] == "Linux") {
    pkgPath <- find.package("ROpenCVLite")
    installPath <- gsub("ROpenCVLite", "", pkgPath)
    libPath <- paste0(installPath, "/opencv/lib")
    Sys.setenv(LD_LIBRARY_PATH = paste0(Sys.getenv("LD_LIBRARY_PATH"), ":", libPath))
  }
}

.onAttach <- function(lib, pkg) {
  pkg_cv_version <- package_version("4.11.0")

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
