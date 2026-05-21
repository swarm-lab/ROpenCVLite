test_that("defaultOpenCVPath() returns a non-empty character string ending in ROpenCV", {
  path <- defaultOpenCVPath()
  expect_type(path, "character")
  expect_gt(nchar(path), 0)
  expect_true(endsWith(path, "ROpenCV"))
})

test_that("isOpenCVInstalled() returns a logical scalar", {
  result <- isOpenCVInstalled()
  expect_type(result, "logical")
  expect_length(result, 1)
})

test_that("isCmakeInstalled() returns a logical scalar", {
  result <- suppressMessages(isCmakeInstalled())
  expect_type(result, "logical")
  expect_length(result, 1)
})

test_that("isCmakeInstalled() emits a message when cmake is absent", {
  skip_if(suppressMessages(isCmakeInstalled()), "cmake is installed on this system")
  expect_snapshot(isCmakeInstalled())
})

test_that("OpenCVPath() errors with expected message when OpenCV is not installed", {
  skip_if(isOpenCVInstalled(), "OpenCV is installed on this system")
  expect_snapshot(OpenCVPath(), error = TRUE)
})

test_that("opencvVersion() errors when OpenCV is not installed", {
  skip_if(isOpenCVInstalled(), "OpenCV is installed on this system")
  expect_snapshot(opencvVersion(), error = TRUE)
})

test_that("opencvConfig() errors when OpenCV is not installed", {
  skip_if(isOpenCVInstalled(), "OpenCV is installed on this system")
  expect_snapshot(opencvConfig(), error = TRUE)
})

test_that("opencvConfig() errors on invalid output argument", {
  skip_if(!isOpenCVInstalled(), "OpenCV not installed; cannot reach output validation")
  expect_snapshot(opencvConfig(output = "invalid"), error = TRUE)
})
