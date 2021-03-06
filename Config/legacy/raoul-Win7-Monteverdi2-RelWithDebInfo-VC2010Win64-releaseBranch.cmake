SET (dashboard_model Nightly)
SET (CTEST_DASHBOARD_ROOT "C:/Users/jmalik/Dashboard")

SET (OTB_PROJECT Monteverdi2) # OTB / Monteverdi / Monteverdi2
SET (OTB_ARCH amd64) # x86 / amd64

SET (CTEST_BUILD_CONFIGURATION RelWithDebInfo)

SET (CTEST_SOURCE_DIRECTORY "${CTEST_DASHBOARD_ROOT}/src/${OTB_PROJECT}")
SET (CTEST_BINARY_DIRECTORY "${CTEST_DASHBOARD_ROOT}/build/${OTB_PROJECT}-ReleaseBranch-vc10-${OTB_ARCH}-${CTEST_BUILD_CONFIGURATION}")

SET (CTEST_CMAKE_GENERATOR  "NMake Makefiles")
# avoid redefinition of build command to build target 'PACKAGE'
SET (CTEST_BUILD_COMMAND  "jom")
SET (CTEST_CMAKE_COMMAND "C:/Program Files (x86)/CMake 2.8/bin/cmake.exe")
SET (CTEST_SITE "raoul.c-s.fr" )
SET (CTEST_BUILD_NAME "Win7-vc10-${OTB_ARCH}-${CTEST_BUILD_CONFIGURATION}-Static-ReleaseBranch")
SET (CTEST_HG_COMMAND "C:/Program Files (x86)/Mercurial/hg.exe")
SET (CTEST_HG_UPDATE_OPTIONS "mvd2_release")

SET (OTB_INSTALL_PREFIX ${CTEST_DASHBOARD_ROOT}/install/${OTB_PROJECT}-ReleaseBranch-vc10-${OTB_ARCH}-${CTEST_BUILD_CONFIGURATION})

SET (OTB_INITIAL_CACHE "
BUILDNAME:STRING=${CTEST_BUILD_NAME}
SITE:STRING=${CTEST_SITE}

CMAKE_INSTALL_PREFIX:PATH=${OTB_INSTALL_PREFIX}

CMAKE_BUILD_TYPE:STRING=${CTEST_BUILD_CONFIGURATION}

CMAKE_INCLUDE_PATH:PATH=$ENV{OSGEO4W_ROOT}/include
CMAKE_LIBRARY_PATH:PATH=$ENV{OSGEO4W_ROOT}/lib

BUILD_TESTING:BOOL=ON
OTB_DATA_ROOT:STRING=${CTEST_DASHBOARD_ROOT}/src/OTB-Data
OTB_DATA_USE_LARGEINPUT:BOOL=ON
OTB_DATA_LARGEINPUT_ROOT:PATH=${CTEST_DASHBOARD_ROOT}/src/OTB-LargeInput

Monteverdi2_USE_CPACK:BOOL=ON

OTB_DIR:PATH=${CTEST_DASHBOARD_ROOT}/install/OTB-vc10-${OTB_ARCH}-${CTEST_BUILD_CONFIGURATION}/lib/cmake/OTB-5.0
ICE_INCLUDE_DIR:PATH=${CTEST_DASHBOARD_ROOT}/install/Ice-vc10-${OTB_ARCH}-${CTEST_BUILD_CONFIGURATION}/include
ICE_LIBRARY:PATH=${CTEST_DASHBOARD_ROOT}/install/Ice-vc10-${OTB_ARCH}-${CTEST_BUILD_CONFIGURATION}/lib/OTBIce.lib
")

#Remove install dir
execute_process(COMMAND ${CTEST_CMAKE_COMMAND} -E remove_directory ${OTB_INSTALL_PREFIX})
execute_process(COMMAND ${CTEST_CMAKE_COMMAND} -E make_directory ${OTB_INSTALL_PREFIX})

ctest_empty_binary_directory (${CTEST_BINARY_DIRECTORY})

SET (CTEST_NOTES_FILES
${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}
${CTEST_BINARY_DIRECTORY}/CMakeCache.txt
)

ctest_start(${dashboard_model})
ctest_update(SOURCE "${CTEST_SOURCE_DIRECTORY}")
file(WRITE "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt" ${OTB_INITIAL_CACHE})
ctest_configure (BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_read_custom_files(${CTEST_BINARY_DIRECTORY})
ctest_build (BUILD "${CTEST_BINARY_DIRECTORY}")
unset(CTEST_BUILD_COMMAND)
ctest_build (BUILD "${CTEST_BINARY_DIRECTORY}" TARGET PACKAGES)
ctest_test (BUILD "${CTEST_BINARY_DIRECTORY}")
ctest_submit ()
