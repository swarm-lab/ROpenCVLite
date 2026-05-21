test_that("removeOpenCV() emits a message and returns FALSE when OpenCV is not installed", {
  skip_if(isOpenCVInstalled(), "OpenCV is installed on this system")
  expect_message(
    result <- removeOpenCV(),
    "OpenCV is not installed on this system"
  )
  expect_identical(result, FALSE)
})

test_that("installOpenCV() rejects unknown module names", {
  expect_snapshot(
    installOpenCV(modules = "unknown_module"),
    error = TRUE
  )
})
