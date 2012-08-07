SET (CTEST_SOURCE_DIRECTORY "C:/Users/jmalik/Dashboard/src/Monteverdi")
SET (CTEST_BINARY_DIRECTORY "C:/Users/jmalik/Dashboard/build/Monteverdi-Release-VC2008")

SET (CTEST_CMAKE_GENERATOR  "Visual Studio 9 2008" )
SET (CTEST_CMAKE_COMMAND "C:/Program Files (x86)/CMake 2.8/bin/cmake.exe")
SET (CTEST_SITE "raoul.c-s.fr" )
SET (CTEST_BUILD_NAME "Win7-Visual2008-Release-Static")
SET (CTEST_BUILD_CONFIGURATION "Release")
SET (CTEST_HG_COMMAND "C:/Program Files (x86)/Mercurial/hg.exe")
SET (CTEST_HG_UPDATE_OPTIONS "-C")

SET (OTB_INITIAL_CACHE "
BUILDNAME:STRING=${CTEST_BUILD_NAME}
SITE:STRING=${CTEST_SITE}
CMAKE_INSTALL_PREFIX:PATH=C:/Users/jmalik/Dashboard/install/Monteverdi-Release-VC2008

BUILD_TESTING:BOOL=ON
OTB_USE_CPACK:BOOL=ON

OTB_DATA_ROOT:STRING=C:/Users/jmalik/Dashboard/src/OTB-Data
OTB_DATA_USE_LARGEINPUT:BOOL=ON
OTB_DATA_LARGEINPUT_ROOT:PATH=C:/Users/jmalik/Dashboard/src/OTB-LargeInput

GDAL_INCLUDE_DIR:PATH=C:/OSGeo4W/include
GDAL_LIBRARY:FILEPATH=C:/OSGeo4W/lib/gdal_i.lib

OTB_DIR:PATH=C:/Users/jmalik/Dashboard/build/OTB-Release-VC2008-ExternalOssim
OTB_USE_CPACK:BOOL=ON

EXPAT_INCLUDE_DIR:PATH=C:/OSGeo4W/include
EXPAT_LIBRARY:FILEPATH=C:/OSGeo4W/lib/libexpat.lib

LIBLAS_INCLUDE_DIR:PATH=C:/OSGeo4W/include
LIBLAS_LIBRARY:FILEPATH=C:/OSGeo4W/lib/liblas_c.lib

MAPNIK_INCLUDE_DIR:PATH=C:/OSGeo4W/include/mapnik
MAPNIK_LIBRARY:FILEPATH=C:/OSGeo4W/lib/mapnik.lib
FREETYPE2_INCLUDE_DIR:PATH=C:/OSGeo4W/include/freetype
ICUUC_INCLUDE_DIR:PATH=C:/Program Files (x86)/icu4c-4_2_1-Win32-msvc9/icu/include
ICUUC_LIBRARY:FILEPATH=C:/Program Files (x86)/icu4c-4_2_1-Win32-msvc9/icu/lib/icuuc.lib
LTDL_INCLUDE_DIR:PATH=C:/Program Files (x86)/GnuWin32/include
LTDL_LIBRARY:FILEPATH=C:/Program Files (x86)/GnuWin32/lib/ltdl.lib
")

#Remove install dir
execute_process(COMMAND ${CTEST_CMAKE_COMMAND} -E remove_directory C:/Users/jmalik/Dashboard/install/Monteverdi-Release-VC2008)
execute_process(COMMAND ${CTEST_CMAKE_COMMAND} -E make_directory C:/Users/jmalik/Dashboard/install/Monteverdi-Release-VC2008)

#Remove build dir
ctest_empty_binary_directory (${CTEST_BINARY_DIRECTORY})

SET (CTEST_NOTES_FILES
${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}
${CTEST_BINARY_DIRECTORY}/CMakeCache.txt
)

ctest_start(Nightly)
ctest_update(SOURCE "${CTEST_SOURCE_DIRECTORY}")
file(WRITE "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" ${OTB_INITIAL_CACHE})
ctest_configure (BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_read_custom_files(${CTEST_BINARY_DIRECTORY})
ctest_submit (PARTS Start Update Configure)
ctest_build (BUILD "${CTEST_BINARY_DIRECTORY}"
             TARGET INSTALL)
ctest_submit (PARTS Start Update Configure Build)
ctest_test (BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_submit ()
