# TCL3D Build Instruction
tcl3d is an exceptionally old, yet still functional OpenGL interface for tcl. I encountered tcl3d while searching for an alternative to vtk (visualization toolkit). Looks like tcl3d is the barebone framework for 3D display using OpenGL in tcl/tk. This is probably the leanest library for 3D display, unless you really want to use tkcanvas and hand-write a bunch of geometric computations to plot and draw 3D objects on 2D canvas (please, don't).

20211208: tcl3d latest version is actually on bawt, 0.9.4:
http://www.bawt.tcl3d.org/preview.html
Simply download the installer and install it, if you don't want to rebuild it from scratch. However, if you still decide to build it yourself, continue reading.

The official website release version 0.5, and is very old. Better get the source code of tcl3d 0.9.4 from bawt site:
http://www.bawt.tcl3d.org/download.html

Look for "tcl3d FULL", version 0.9.4. Download and extract it.

This guide is to note any special things to take care of during build-from-source process on Windows's mingw64.
Please refer to my vtk_tcl_tk_build repo's README.md file for a more detailed instruction of how to use cmake and setup mingw64 for Windows. I wrote this guide after finishing the vtk build for tcl/tk.

1. Modify Common.cmake under C:\msys64\mingw64\tcl3d\tcl3d-0.9.4\CMakeModules:
Add a comment ('#') to ADD_DEFINITIONS( "-fpermissive" ). This definition is only valid for c++, but we're compiling C.
This will suppress a lot of warning messages. You can also download the fixed Common.cmake in this repo and replace it to tcl3d 0.9.4 source directory.

2. In cmake-gui, the first configure will cause an error saying swig_dir is missing. Tick "Advanced". Simply browse and specify:

SWIG_DIR:

C:/msys64/usr/share/swig/4.0.2

SWIG_EXECUTABLE:

C:/msys64/usr/bin/swig.exe

Make sure the path separator is "/", not "\". No wonder why it cause so much headache...
Then configure again

3. only check TCL3D_BUILD_OGL (uncheck other components). I only test opengl component of tcl3d for now.
Also, write "Release" in CMAKE_BUILD_TYPE, even though I don't think it's going to be used.

4. Very important: we need to specify tcl/tk include/lib similar to vtk:
DO NOT USE the default mingw64 tcl/tk path.
Use the one you build from source, or the bawt's one.



