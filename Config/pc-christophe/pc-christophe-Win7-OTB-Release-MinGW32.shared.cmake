# Client maintainer: manuel.grizonnet@cnes.fr
# This build is not submitted daily or weekly and the cmake
# script is kept as a reference for enable daily submission 
# from Windows 7 machine in future.

set (CTEST_SOURCE_DIRECTORY "D:/sources/OTB")
set (CTEST_BINARY_DIRECTORY "D:/build/OTB-MinGW32-shared")

set (CTEST_CMAKE_GENERATOR  "MinGW Makefiles" )
set (CTEST_CMAKE_COMMAND "C:/Programmes/CMake28/bin/cmake.exe")
set (CTEST_BUILD_CONFIGURATION "Release")

set (CTEST_SITE "pc-christophe.cst.cnes.fr")
set(CTEST_BUILD_NAME "Win7-MinGW32-${CTEST_BUILD_CONFIGURATION}-Shared")

set (CTEST_HG_COMMAND "C:/Programmes/Mercurial/hg.exe")
#set (CTEST_HG_UPDATE_OPTIONS "-C")
#set(CTEST_TEST_ARGS PARALLEL_LEVEL 4)
set(CMAKE_MAKE_PROGRAM "C:/MinGW/bin/mingw32-make.exe")

set(INSTALLROOT "D:/install")

set (OTB_INITIAL_CACHE "
BUILDNAME:STRING=${CTEST_BUILD_NAME}
SITE:STRING=${CTEST_SITE}
CMAKE_INSTALL_PREFIX:PATH=${INSTALLROOT}/OTB-MinGW32

BUILD_APPLICATIONS:BOOL=ON
BUILD_EXAMPLES:BOOL=OFF
BUILD_SHARED_LIBS:BOOL=ON
BUILD_TESTING:BOOL=ON

OTB_DATA_ROOT:STRING=/d/sources/OTB-Data
OTB_DATA_USE_LARGEINPUT:BOOL=OFF

OTB_WRAP_JAVA:BOOL=OFF
OTB_WRAP_PYTHON:BOOL=OFF
OTB_WRAP_QT:BOOL=OFF

OTB_USE_JPEG2000:BOOL=ON
OTB_USE_CURL:BOOL=ON
OTB_USE_JPEG2000:BOOL=ON
OTB_USE_OPENCV:BOOL=OFF
OTB_USE_SIFTFAST:BOOL=OFF
OTB_USE_CPACK:BOOL=OFF

OTB_USE_EXTERNAL_EXPAT:BOOL=ON
OTB_USE_EXTERNAL_ITK:BOOL=ON
OTB_USE_EXTERNAL_OSSIM:BOOL=ON
OTB_USE_EXTERNAL_OPENTHREADS:BOOL=ON
OTB_USE_EXTERNAL_BOOST:BOOL=ON


CURL_INCLUDE_DIR:PATH=${INSTALLROOT}/curl/include
CURL_LIBRARY:FILEPATH=${INSTALLROOT}/lib/libcurl.dll.a

EXPAT_INCLUDE_DIR:PATH=${INSTALLROOT}/include
EXPAT_LIBRARY:FILEPATH=${INSTALLROOT}/bin/libexpat.dll

GDAL_INCLUDE_DIR:PATH=${INSTALLROOT}/include
GDAL_LIBRARY:FILEPATH=${INSTALLROOT}/lib/libgdal.dll.a

GEOTIFF_INCLUDE_DIRS:PATH=${INSTALLROOT}/include
GEOTIFF_LIBRARY:FILEPATH=D:/install/lib/libgeotiff.dll.a

JPEG_INCLUDE_DIRS:PATH=${INSTALLROOT}/include
JPEG_LIBRARY:FILEPATH=${INSTALLROOT}/lib/libjpeg.dll.a
OGR_INCLUDE_DIRS:PATH=${INSTALLROOT}/include

OPENTHREADS_INCLUDE_DIR:PATH=${INSTALLROOT}/include
OPENTHREADS_LIBRARY:FILEPATH=${INSTALLROOT}/lib/libOpenThreads.dll.a

OSSIM_INCLUDE_DIR:PATH=${INSTALLROOT}/include
OSSIM_LIBRARY:FILEPATH=${INSTALLROOT}/lib/libossim.dll.a

TIFF_INCLUDE_DIRS:PATH=${INSTALLROOT}/include
TIFF_LIBRARY:FILEPATH=${INSTALLROOT}/lib/libtiff.dll.a

ZLIB_INCLUDE_DIR:PATH=${INSTALLROOT}/include
ZLIB_INCLUDE_DIR:PATH=${INSTALLROOT}/include
ZLIB_LIBRARY:FILEPATH=${INSTALLROOT}/bin/libzlib.dll

ITK_DIR:PATH=${INSTALLROOT}/lib/cmake/ITK-4.5
##OpenCV_DIR:PATH=${INSTALLROOT}/share/OpenCV

Boost_DIR:PATH=${INSTALLROOT}/boost-bin
Boost_INCLUDE_DIR:PATH=${INSTALLROOT}/boost-bin

#Qt
QT_QMAKE_EXECUTABLE:FILEPATH=C:/Qt/bin/qmake.exe
QT_MKSPECS_DIR:PATH=C:/Qt/mkspecs
QT_MOC_EXECUTABLE:FILEPATH=C:/Qt/bin/moc.exe
  
CMAKE_USE_PTHREADS:BOOL=OFF
CMAKE_USE_WIN32_THREADS:BOOL=ON

")

ctest_empty_binary_directory (${CTEST_BINARY_DIRECTORY})

set (CTEST_NOTES_FILES
${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}
${CTEST_BINARY_DIRECTORY}/CMakeCache.txt
)

ctest_start(Nightly)
ctest_update(SOURCE "${CTEST_SOURCE_DIRECTORY}")
file(WRITE "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" ${OTB_INITIAL_CACHE})
ctest_configure (BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_read_custom_files(${CTEST_BINARY_DIRECTORY})
ctest_build (BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_test (BUILD "${CTEST_BINARY_DIRECTORY}" PARALLEL_LEVEL 2)
ctest_submit ()




