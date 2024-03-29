# Cleanup -----------------------------------------------------------------
tryCatch({
  remove.packages("Rvision")
}, error = function(e) cat("Rvision is not installed. Nothing to remove."))

tryCatch({
  remove.packages("ROpenCVLite")
}, error = function(e) cat("ROpenCVLite is not installed. Nothing to remove."))


# Dependencies ------------------------------------------------------------
if (!requireNamespace("utils", quietly = TRUE)) {
  install.packages("utils")
}

if (!requireNamespace("pkgbuild", quietly = TRUE)) {
  install.packages("pkgbuild")
}

if (!requireNamespace("parallel", quietly = TRUE)) {
  install.packages("parallel")
}

if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}


# Testing -----------------------------------------------------------------
old_timeout <- getOption("timeout")
options(timeout = 240)

tryCatch({
  install.packages(".",  type = "source", repos = NULL,
                   INSTALL_opts = c("--preclean", "--no-multiarch", "--with-keep.source"))

  ROpenCVLite::installOpenCV(batch = TRUE)

  remotes::install_github("swarm-lab/Rvision", force = TRUE, INSTALL_opts = "--no-multiarch")

  a <- Rvision::zeros(100, 100)
  Rvision::changeBitDepth(a, "32F", 1 / 255, target = "self")

  cat("Success")
}, error = function(e) cat("Failure"))


options(timeout = old_timeout)