# Dependencies ------------------------------------------------------------
if (!requireNamespace("processx", quietly = TRUE)) {
  install.packages("processx")
}

if (!requireNamespace("progress", quietly = TRUE)) {
  install.packages("progress")
}


# Environment -------------------------------------------------------------
library(processx)
library(progress)

callback <- function(line, proc) {
  r <- regexpr("\\[(.*?)%\\]", line)

  if (r[1] == 1 & !pb$finished) {
    pb$update(as.numeric(gsub("\\[(.*?)%\\]", "\\1", regmatches(line, r))) / 100)
  }
}


# Script ------------------------------------------------------------------
res <- run("rig", c("list", "--plain"), echo_cmd = TRUE, stderr_to_stdout = TRUE,
           windows_verbatim_args = TRUE)
v <- strsplit(res$stdout, c("\n", "\r\n"))[[1]]

env_par <- NULL
if (.Platform$OS.type == "windows") {
  env_par <- ps::ps_environ(ps::ps_parent(ps::ps_handle()))
  attr(env_par, "class") <- NULL
  env_par <- env_par[nchar(names(env_par)) > 0]
}

for (r in v) {
  pb <- progress_bar$new(format = "  Compiling [:bar] :percent", clear = FALSE)

  res <- run("rig", c("run", paste0("-r", r), "-ftest_install/test_script.R"),
             echo_cmd = TRUE, spinner = TRUE, stderr_to_stdout = TRUE,
             windows_verbatim_args = TRUE, stdout_line_callback = callback,
             env = env_par)

  pb$terminate()

  stdout <- strsplit(res$stdout, c("\n", "\r\n"))[[1]]

  if (stdout[length(stdout)] != "Success") {
    con <- file(paste0("test_install/log_", r, ".txt"), "wb")
    writeBin(paste(stdout, collapse = "\n"), con)
    close(con)
  }

  cat(paste0("R ", r, ": ", stdout[length(stdout)], "\n\n"))
}
