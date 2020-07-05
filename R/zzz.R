.onLoad <- function(lib, pkg) {
  if (.Platform$OS.type == "windows") {
    pkgPath <- find.package("ROpenCVLite")
    installPath <- gsub("ROpenCVLite", "", pkgPath)
    opath <- Sys.getenv("PATH")
    if (.Platform$r_arch == "i386") {
      binPath <- "/opencv/x86/mingw/bin"
    } else {
      binPath <- "/opencv/x64/mingw/bin"
    }
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
  if (.Platform$OS.type == "windows") {
    pkgPath <- find.package("ROpenCVLite")
    installPath <- gsub("ROpenCVLite", "", pkgPath)
    opath <- Sys.getenv("PATH")
    if (.Platform$r_arch == "i386") {
      binPath <- "/opencv/x86/mingw/bin"
    } else {
      binPath <- "/opencv/x64/mingw/bin"
    }
    binPath <- utils::shortPathName(paste0(installPath, binPath))
    Sys.setenv(PATH = paste(binPath, opath, sep = ";"))
  }

  if (Sys.info()[["sysname"]] == "Linux") {
    pkgPath <- find.package("ROpenCVLite")
    installPath <- gsub("ROpenCVLite", "", pkgPath)
    libPath <- paste0(installPath, "/opencv/lib")
    Sys.setenv(LD_LIBRARY_PATH = paste0(Sys.getenv("LD_LIBRARY_PATH"), ":", libPath))
  }

  if (!ROpenCVLite::isOpenCVInstalled()) {
    installOpenCV()
  } else {
    pkgVersion <- paste0(strsplit(as.character(utils::packageVersion("ROpenCVLite")), "\\.")[[1]][1:2], collapse = "")
    cvVersion <- gsub("\\D+", "", ROpenCVLite::opencvVersion())

    if (!is.null(pkgVersion)) {
      if (pkgVersion != cvVersion) {
        installOpenCV()
      }
    }
  }
}
