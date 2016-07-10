# ROpenCV

**Not ready for production. Try at your own risks. Mac and Linux only.**

## Package description

`ROpenCV` is a utility package that installs OpenCV within R for use by other 
packages. This package does not provide access to OpenCV functions, but compiles
and installs OpenCV within your R installation so that other packages can easily
find it and compile against it. 

---

## I can't use OpenCV functions? What's the point of this package then?

Installing OpenCV is a pain in the *xxx*! Most people won't know how to do it or 
have the patience to compile it. This package is meant to facilitate this 
process by automating it and making sure that OpenCV is conveniently located 
somewhere where R package developers can easily find it. 

It is also meant to simplify the work of developers wanting to provide 
OpenCV-based computer vision packages for R. No need to worry about where each
user might have installed OpenCV on her/his computer or even if she/he has even 
installed OpenCV in the first place. Simply set this package as a dependence and
use its configuration function to easily find where OpenCV has been installed. 
Also no need to include OpenCV with your package, eliminating long compilation
times every time you update your package. Once ROpenCV is installed inside a 
user's R installation, no need to recompile it again unnecessarily.  

---

