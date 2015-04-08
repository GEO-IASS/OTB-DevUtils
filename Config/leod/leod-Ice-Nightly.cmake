set (ENV{DISPLAY} ":0.0")

set (CTEST_BUILD_CONFIGURATION "Release")

set (CTEST_SOURCE_DIRECTORY "$ENV{HOME}/Dashboard/nightly/Ice-${CTEST_BUILD_CONFIGURATION}/src")
set (CTEST_BINARY_DIRECTORY "$ENV{HOME}/Dashboard/nightly/Ice-${CTEST_BUILD_CONFIGURATION}/build")
set (CTEST_CMAKE_GENERATOR  "Unix Makefiles")
set (CTEST_CMAKE_COMMAND "cmake" )
set (CTEST_BUILD_COMMAND "/usr/bin/make -j8 -i -k install" )
set (CTEST_SITE "leod.c-s.fr" )
set (CTEST_BUILD_NAME "MacOSX10.8-${CTEST_BUILD_CONFIGURATION}")
set (CTEST_HG_COMMAND "/opt/local/bin/hg")
set (CTEST_HG_UPDATE_OPTIONS "-C")


set (ICE_INSTALL_PREFIX "$ENV{HOME}/Dashboard/nightly/Ice-${CTEST_BUILD_CONFIGURATION}/install")

set (ICE_INITIAL_CACHE "
BUILDNAME:STRING=${CTEST_BUILD_NAME}
SITE:STRING=${CTEST_SITE}


CMAKE_C_FLAGS:STRING=-Wall
CMAKE_CXX_FLAGS:STRING=-Wall -Wno-\\\\#warnings

CMAKE_BUILD_TYPE:STRING=${CTEST_BUILD_CONFIGURATION}

ITK_DIR:PATH=/Users/otbval/Dashboard/itkv4/build
OTB_DIR:PATH=/Users/otbval/Dashboard/nightly/OTB-Release/build

#use glut from XQuartz - http://hg.orfeo-toolbox.org/Ice/rev/2686f7776582

GLUT_glut_LIBRARY=/usr/X11R6/lib/libglut.3.dylib
GLUT_INCLUDE_DIR=/usr/X11R6/include

BUILD_TESTING:BOOL=ON
CMAKE_INSTALL_PREFIX:STRING=${ICE_INSTALL_PREFIX}
BUILD_ICE_APPLICATION:BOOL=ON
")

set (CTEST_NOTES_FILES
${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}
${CTEST_BINARY_DIRECTORY}/CMakeCache.txt
)

execute_process (COMMAND ${CTEST_CMAKE_COMMAND} -E remove_directory ${ICE_INSTALL_PREFIX})
execute_process (COMMAND ${CTEST_CMAKE_COMMAND} -E make_directory ${ICE_INSTALL_PREFIX})
ctest_empty_binary_directory (${CTEST_BINARY_DIRECTORY})

ctest_start (Nightly)
ctest_update (SOURCE "${CTEST_SOURCE_DIRECTORY}")
file (WRITE "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" ${ICE_INITIAL_CACHE})
ctest_configure (BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_read_custom_files (${CTEST_BINARY_DIRECTORY})
ctest_build (BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_test (BUILD "${CTEST_BINARY_DIRECTORY}" PARALLEL_LEVEL 6)
ctest_submit ()
