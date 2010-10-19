
SET (CTEST_SOURCE_DIRECTORY "$ENV{HOME}/WWW.ORFEO-TOOLBOX.ORG-CS-NIGHTLY/Monteverdi")
SET (CTEST_BINARY_DIRECTORY "$ENV{HOME}/OTB-NIGHTLY-VALIDATION/build/Monteverdi")

SET( CTEST_CMAKE_GENERATOR  "Unix Makefiles" )
SET (CTEST_CMAKE_COMMAND "cmake" )
SET (CTEST_BUILD_COMMAND "/usr/bin/make -j8 -i -k install" )
SET (CTEST_SITE "dora.c-s.fr" )
SET (CTEST_BUILD_NAME "Ubuntu8.04-64bits-Release")
SET (CTEST_BUILD_CONFIGURATION "Release")
SET (CTEST_HG_COMMAND "/usr/bin/hg")
SET (CTEST_HG_UPDATE_OPTIONS "-C")
SET (ENV{DISPLAY} ":0.0")

SET(OTB_GDAL_INSTALL_DIR "$ENV{HOME}/OTB-OUTILS/gdal/install-linux-gdal-1.7.2")

SET (OTB_INITIAL_CACHE "
BUILDNAME:STRING=${CTEST_BUILD_NAME}
SITE:STRING=${CTEST_SITE}

OTB_DATA_USE_LARGEINPUT:BOOL=ON
OTB_DATA_LARGEINPUT_ROOT:STRING=/DATA/OTB-Data-LargeInput
OTB_DATA_ROOT:STRING=$ENV{HOME}/WWW.ORFEO-TOOLBOX.ORG-CS-NIGHTLY/OTB-Data

CMAKE_C_FLAGS:STRING= -Wall -Wno-uninitialized -Wno-unused-variable
CMAKE_CXX_FLAGS:STRING= -Wall -Wno-deprecated -Wno-uninitialized -Wno-unused-variable

CMAKE_BUILD_TYPE:STRING=Release

OTB_DIR:STRING=$ENV{HOME}/OTB-NIGHTLY-VALIDATION/build/OTB
FLTK_DIR:PATH=$ENV{HOME}/OTB-OUTILS/fltk/binaries-linux-shared-release-fltk-1.1.9

BUILD_TESTING:BOOL=ON

CMAKE_INSTALL_PREFIX:STRING=$ENV{HOME}/OTB-NIGHTLY-VALIDATION/install/Monteverdi

MAPNIK_INCLUDE_DIR:PATH=/ORFEO/otbval/OTB-OUTILS/mapnik/install/include
MAPNIK_LIBRARY:FILEPATH=/ORFEO/otbval/OTB-OUTILS/mapnik/install/lib/libmapnik.so

GDALCONFIG_EXECUTABLE:FILEPATH=${OTB_GDAL_INSTALL_DIR}/bin/gdal-config
GDAL_CONFIG:FILEPATH=${OTB_GDAL_INSTALL_DIR}/bin/gdal-config
GDAL_INCLUDE_DIR:STRING=${OTB_GDAL_INSTALL_DIR}/include
GDAL_LIBRARY:FILEPATH=${OTB_GDAL_INSTALL_DIR}/lib/libgdal.so
OGR_INCLUDE_DIRS:STRING=${OTB_GDAL_INSTALL_DIR}/include
GEOTIFF_INCLUDE_DIRS:PATH=${OTB_GDAL_INSTALL_DIR}/include
TIFF_INCLUDE_DIRS:PATH=${OTB_GDAL_INSTALL_DIR}/include
JPEG_INCLUDE_DIRS:PATH=${OTB_GDAL_INSTALL_DIR}/include
JPEG_INCLUDE_DIR:PATH=${OTB_GDAL_INSTALL_DIR}/include

")

SET( OTB_PULL_RESULT_FILE "${CTEST_BINARY_DIRECTORY}/pull_result.txt" )

SET (CTEST_NOTES_FILES
${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}
${OTB_PULL_RESULT_FILE}
${CTEST_BINARY_DIRECTORY}/CMakeCache.txt
)

ctest_empty_binary_directory ($ENV{HOME}/OTB-NIGHTLY-VALIDATION/install/Monteverdi)
ctest_empty_binary_directory (${CTEST_BINARY_DIRECTORY})

execute_process( COMMAND ${CTEST_HG_COMMAND} pull http://hg.orfeo-toolbox.org/Monteverdi-Nightly
                 WORKING_DIRECTORY "${CTEST_SOURCE_DIRECTORY}"
                 OUTPUT_VARIABLE   OTB_PULL_RESULT
                 ERROR_VARIABLE    OTB_PULL_RESULT )
file(WRITE ${OTB_PULL_RESULT_FILE} ${OTB_PULL_RESULT} )

ctest_start(Nightly)
ctest_update(SOURCE "${CTEST_SOURCE_DIRECTORY}")
file(WRITE "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" ${OTB_INITIAL_CACHE})
ctest_configure (BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_build (BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_test (BUILD "${CTEST_BINARY_DIRECTORY}" PARALLEL_LEVEL 6)
ctest_submit ()

