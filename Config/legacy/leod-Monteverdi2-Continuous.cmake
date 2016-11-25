SET (ENV{DISPLAY} ":0.0")

SET (dashboard_model Continuous)
string(TOLOWER ${dashboard_model} lcdashboard_model)

SET (CTEST_BUILD_CONFIGURATION Release)

SET (CTEST_SOURCE_DIRECTORY "$ENV{HOME}/Dashboard/${lcdashboard_model}/Monteverdi2/src")
SET (CTEST_BINARY_DIRECTORY "$ENV{HOME}/Dashboard/${lcdashboard_model}/Monteverdi2/build")

SET( CTEST_CMAKE_GENERATOR  "Unix Makefiles" )
SET (CTEST_CMAKE_COMMAND "cmake" )
SET (CTEST_BUILD_COMMAND "/usr/bin/make -j8 -i -k install" )
SET (CTEST_SITE "leod.c-s.fr")
SET (CTEST_BUILD_NAME "MacOSX10.8-${CTEST_BUILD_CONFIGURATION}")
SET(CTEST_GIT_COMMAND "/opt/local/bin/git")
SET(CTEST_GIT_UPDATE_CUSTOM ${CMAKE_COMMAND} -D GIT_COMMAND:PATH=${CTEST_GIT_COMMAND} -D TESTED_BRANCH:STRING=develop -P ${CTEST_SCRIPT_DIRECTORY}/../git_updater.cmake)
SET (CTEST_USE_LAUNCHERS ON)

SET (CTEST_INITIAL_CACHE "

BUILDNAME:STRING=${CTEST_BUILD_NAME}
SITE:STRING=${CTEST_SITE}
CTEST_USE_LAUNCHERS:BOOL=ON

CMAKE_LIBRARY_PATH:PATH=/opt/local/lib
CMAKE_INCLUDE_PATH:PATH=/opt/local/include

BUILD_SHARED_LIBS:BOOL=OFF
CMAKE_BUILD_TYPE:STRING=${CTEST_BUILD_CONFIGURATION}
BUILD_TESTING:BOOL=ON
CMAKE_INSTALL_PREFIX:STRING=$ENV{HOME}/Dashboard/${lcdashboard_model}/Monteverdi2/install

OTB_DATA_USE_LARGEINPUT:BOOL=ON
OTB_DATA_LARGEINPUT_ROOT:STRING=$ENV{HOME}/Data/OTB-LargeInput
OTB_DATA_ROOT:STRING=$ENV{HOME}/Data/OTB-Data

CMAKE_C_FLAGS:STRING= -Wall -Wextra
CMAKE_CXX_FLAGS:STRING= -Wall -Wextra -Wno-gnu -Wno-\\\\#warnings
#CMAKE_OSX_ARCHITECTURES:STRING=i386

OTB_DIR:STRING=$ENV{HOME}/Dashboard/${lcdashboard_model}/OTB/build

# ICE_INCLUDE_DIR:PATH=/Users/otbval/Dashboard/nightly/Ice-Release/src/Code
# ICE_LIBRARY:FILEPATH=/Users/otbval/Dashboard/nightly/Ice-Release/build/bin/libOTBIce.dylib

")


SET (CTEST_NOTES_FILES
${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}
${CTEST_BINARY_DIRECTORY}/CMakeCache.txt
)

ctest_empty_binary_directory (${CTEST_BINARY_DIRECTORY})
ctest_start(${dashboard_model})
ctest_update(SOURCE "${CTEST_SOURCE_DIRECTORY}")
file(WRITE "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" ${CTEST_INITIAL_CACHE})
ctest_configure (BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_read_custom_files(${CTEST_BINARY_DIRECTORY})
ctest_build (BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_test (BUILD "${CTEST_BINARY_DIRECTORY}" PARALLEL_LEVEL 4)
ctest_submit ()
