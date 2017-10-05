.onLoad <- function(lib, pkg) {
  if (.Platform$OS.type == "windows") {
    pkgPath <- find.package("ROpenCVLite")
    opath <- Sys.getenv("PATH")
    if (.Platform$r_arch == "i386") {
      binPath <- "/opencv/x86/mingw/bin"
    } else {
      binPath <- "/opencv/x64/mingw/bin"
    }
    binPath <- shortPathName(paste0(pkgPath, binPath))
    Sys.setenv(PATH = paste(binPath, opath, sep=";"))
  }

  # are you sure not want to check .Platform$OS.type == "unix"?
  if (Sys.info()[["sysname"]] == "Linux") {
    pkgPath <- find.package("ROpenCVLite")
    libPath <- paste0(pkgPath, "/opencv/lib")
    Sys.setenv(LD_LIBRARY_PATH = paste0(Sys.getenv("LD_LIBRARY_PATH"), ":", libPath))
  }
}

.onAttach <- function(lib, pkg) {
  if (.Platform$OS.type == "windows") {
    pkgPath <- find.package("ROpenCVLite")
    opath <- Sys.getenv("PATH")
    if (.Platform$r_arch == "i386") {
      binPath <- "/opencv/x86/mingw/bin"
    } else {
      binPath <- "/opencv/x64/mingw/bin"
    }
    binPath <- shortPathName(paste0(pkgPath, binPath))
    Sys.setenv(PATH = paste(binPath, opath, sep=";"))
  }

  # are you sure not want to check .Platform$OS.type == "unix"?
  if (Sys.info()[["sysname"]] == "Linux") {
    pkgPath <- find.package("ROpenCVLite")
    libPath <- paste0(pkgPath, "/opencv/lib")
    Sys.setenv(LD_LIBRARY_PATH = paste0(Sys.getenv("LD_LIBRARY_PATH"), ":", libPath))
  }
}
