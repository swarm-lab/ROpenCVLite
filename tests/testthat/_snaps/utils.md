# OpenCVPath() errors with expected message when OpenCV is not installed

    Code
      OpenCVPath()
    Condition
      Error in `OpenCVPath()`:
      ! OpenCV is not installed on this system. Please use installOpenCV() to install it.

# opencvVersion() errors when OpenCV is not installed

    Code
      opencvVersion()
    Condition
      Error in `opencvVersion()`:
      ! OpenCV is not installed on this system. Please use installOpenCV() to install it.

# opencvConfig() errors when OpenCV is not installed

    Code
      opencvConfig()
    Condition
      Error in `opencvConfig()`:
      ! OpenCV is not installed on this system. Please use installOpenCV() to install it.

# opencvConfig() errors on invalid output argument

    Code
      opencvConfig(output = "invalid")
    Condition
      Error in `opencvConfig()`:
      ! output should be either 'libs' or 'cflags'

