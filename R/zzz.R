.onLoad <- function(lib, pkg) {
  if(.Platform$OS.type == "windows"){
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
}

.onAttach <- function(lib, pkg) {
  if(.Platform$OS.type == "windows"){
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
}
