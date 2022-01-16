# Use the non-standard CMake macro "CMAKE_DEPENDENT_OPTION". 
INCLUDE( CMakeDependentOption )

# Determine compiler name and version.
IF( MSVC )
    ADD_DEFINITIONS( "-DCOMPILER_NAME=MSVC" )
    IF( MSVC_VERSION )
        ADD_DEFINITIONS( "-DCOMPILER_VERSION=${MSVC_VERSION}" )
    ENDIF()
ELSEIF( CMAKE_COMPILER_IS_GNUCXX )
    ADD_DEFINITIONS( "-DCOMPILER_NAME=g++" )
    GET_GCC_VERSION( GCC_COMPILER_VERSION )
    ADD_DEFINITIONS( "-DCOMPILER_VERSION=${GCC_COMPILER_VERSION}" )
    #ADD_DEFINITIONS( "-fpermissive" )
ENDIF()

IF( MSVC )
    ADD_DEFINITIONS( "-D_CRT_SECURE_NO_WARNINGS -D_CRT_SECURE_NO_DEPRECATE" )
    ADD_DEFINITIONS( "-D_SCL_SECURE_NO_WARNINGS" )
    ADD_DEFINITIONS( "-MP" ) # use all "effective processors" for faster build times
    ADD_DEFINITIONS( "/EHsc" ) # Always enable C++ exceptions, even in C code.
    ADD_DEFINITIONS( "/bigobj" )
ENDIF()

# Get more target platform info (see http://www.vtk.org/Wiki/CMake_Cross_Compiling)
OPTION( TCL3D_SYSTEM_CHECK "Check target platform." ON )
IF( TCL3D_SYSTEM_CHECK )
    SET( TCL3D_SYSTEM_CHECK OFF CACHE BOOL "Check target platform." FORCE )

    SET( CMAKE_SYSTEM_NAME_DEFAULT ${CMAKE_SYSTEM_NAME} )
    SET( CMAKE_SYSTEM_NAME ${CMAKE_SYSTEM_NAME_DEFAULT} CACHE STRING "System name." )
    MESSAGE( STATUS "Check for system name:      ${CMAKE_SYSTEM_NAME}" )

    SET( CMAKE_SYSTEM_VERSION_DEFAULT ${CMAKE_SYSTEM_VERSION} )
    SET( CMAKE_SYSTEM_VERSION ${CMAKE_SYSTEM_VERSION_DEFAULT} CACHE STRING "System version." )
    MESSAGE( STATUS "Check for system version:   ${CMAKE_SYSTEM_VERSION}" )

    SET( CMAKE_SYSTEM_PROCESSOR_DEFAULT ${CMAKE_SYSTEM_PROCESSOR} )
    SET( CMAKE_SYSTEM_PROCESSOR ${CMAKE_SYSTEM_PROCESSOR_DEFAULT} CACHE STRING "System processor." )
    MESSAGE( STATUS "Check for system processor: ${CMAKE_SYSTEM_PROCESSOR}" )

    MESSAGE( STATUS "Size of void pointer: ${CMAKE_SIZEOF_VOID_P}" )
    IF( MSVC )
        MESSAGE( STATUS "Have 64-bit Visual Studio: ${CMAKE_CL_64}" )
    ENDIF()
ENDIF()

ADD_DEFINITIONS( "-DBUILD_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}" )
ADD_DEFINITIONS( "-DBUILD_SYSTEM_VERSION=${CMAKE_SYSTEM_VERSION}" )
ADD_DEFINITIONS( "-DBUILD_SYSTEM_PROCESSOR=${CMAKE_SYSTEM_PROCESSOR}" )

# Define target name postfixes for different build types.
SET( CMAKE_DEBUG_POSTFIX   "d" CACHE STRING "Specify a postfix, usually d.")
SET( CMAKE_RELEASE_POSTFIX ""  CACHE STRING "Specify a postfix, usually empty string.")

# Check whether we have to build 32- or 64-bit targets.
IF( CMAKE_SIZEOF_VOID_P EQUAL 8 )
  SET( PLATFORM_TYPE_STRING "64" )
  SET( PLATFORM_NUM_BITS     64 )
ELSE()
  SET( PLATFORM_TYPE_STRING "" )
  SET( PLATFORM_NUM_BITS    32 )
ENDIF()

# Define system libraries to be linked.
IF( UNIX )
    SET( SYS_LIBS
        -L/usr/lib${PLATFORM_TYPE_STRING}
        GL
        GLU
        m
        pthread
        stdc++
        -L/usr/X11/lib${PLATFORM_TYPE_STRING}
        X11
        Xext
        Xrandr
    )
ELSEIF( WIN32 )
    SET( SYS_LIBS
        glu32.lib
        opengl32.lib
        version.lib
        Imm32.lib
        ws2_32
        winmm
        Psapi
    )
    IF( MSVC )
        IF( ${MSVC_VERSION} GREATER_EQUAL 1900 )
            SET( SYS_LIBS
                ${SYS_LIBS}
                vcruntime.lib
                ucrt.lib
            )
        ENDIF()
    ENDIF()
ELSE()
    MESSAGE( FATAL_ERROR "Common.cmake: Unknown operating system specified" )
ENDIF()
