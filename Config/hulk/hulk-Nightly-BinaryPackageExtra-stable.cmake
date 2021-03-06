set(dashboard_model Nightly)
set(CTEST_BUILD_CONFIGURATION Release)
set(dashboard_build_command "/usr/bin/make -k -j1 PACKAGE-OTB" )
include(${CTEST_SCRIPT_DIRECTORY}/hulk_common.cmake)
include(${CTEST_SCRIPT_DIRECTORY}/../config_stable.cmake)
include(${CTEST_SCRIPT_DIRECTORY}/../macro_common.cmake)

#-------------------------------------------------------------------------------
# First, compile & install the external modules in current SuperBuild
set(CTEST_BINARY_DIRECTORY "${CTEST_DASHBOARD_ROOT}/build/OTB-SuperBuild-stable/OTB/build")
set(CTEST_SOURCE_DIRECTORY "${CTEST_DASHBOARD_ROOT}/src/OTB")
set(CTEST_BUILD_NAME "Ubuntu14.04-64bits-SuperBuild-contrib-${dashboard_git_branch}")
set(CTEST_BUILD_FLAGS -j8)
set(CTEST_GIT_UPDATE_CUSTOM  ${CMAKE_COMMAND} -D GIT_COMMAND:PATH=git -D TESTED_BRANCH:STRING=${dashboard_git_branch} -P ${CTEST_SCRIPT_DIRECTORY}/../git_updater.cmake)

ctest_start(Nightly TRACK SuperBuild)
ctest_update()
ctest_build(TARGET uninstall)
# 3 official remote modules are not packages because of missing GSL dependency
# get_cache_for_remote_modules(${CTEST_SOURCE_DIRECTORY} cache_remote_modules)
ctest_configure(OPTIONS "-DModule_Mosaic:BOOL=ON;-DModule_otbGRM:BOOL=ON;-DModule_SertitObject:BOOL=ON;-DModule_OTBFFSforGMM:BOOL=ON")
ctest_build(TARGET install)
ctest_submit()

unset(CTEST_BINARY_DIRECTORY)
unset(CTEST_SOURCE_DIRECTORY)
unset(CTEST_GIT_UPDATE_CUSTOM)
unset(CTEST_BUILD_FLAGS)
#-------------------------------------------------------------------------------

set(CTEST_BUILD_NAME "Package-Linux-gcc-4.8.5-x86_64-contrib-${dashboard_git_branch}")

set(CTEST_TEST_ARGS PARALLEL_LEVEL 1)
set(dashboard_source_name "src/OTB/SuperBuild/Packaging")
set(dashboard_binary_name "build/pkg-otb-contrib-stable")
set(dashboard_update_dir ${CTEST_DASHBOARD_ROOT}/src/OTB/)

set(SUPERBUILD_BINARY_DIR ${CTEST_DASHBOARD_ROOT}/build/OTB-SuperBuild-stable)
set(SUPERBUILD_INSTALL_DIR ${CTEST_DASHBOARD_ROOT}/install/OTB-SuperBuild-stable)

macro(dashboard_hook_init)
set(dashboard_cache "
CMAKE_INSTALL_PREFIX:PATH=/tmp/install-pkg-otb
CMAKE_BUILD_TYPE:STRING=${CTEST_BUILD_CONFIGURATION}
CMAKE_VERBOSE_MAKEFILE:BOOL=OFF
CMAKE_C_COMPILER:PATH=/usr/bin/gcc-4.8
CMAKE_CXX_COMPILER:PATH=/usr/bin/g++-4.8
BUILD_TESTING:BOOL=ON
CTEST_USE_LAUNCHERS:BOOL=${CTEST_USE_LAUNCHERS}
OTB_DATA_ROOT:PATH=/media/otbnas/otb/DataForTests/OTB-Data
DOWNLOAD_LOCATION:PATH=/media/otbnas/otb/DataForTests/SuperBuild-archives
SUPERBUILD_BINARY_DIR:PATH=${SUPERBUILD_BINARY_DIR}
SUPERBUILD_INSTALL_DIR:PATH=${SUPERBUILD_INSTALL_DIR}
GENERATE_PACKAGE:BOOL=ON
OTB_WRAP_PYTHON:BOOL=ON
NAME_SUFFIX:STRING=-contrib
")
endmacro()

macro(dashboard_hook_submit)
  dashboard_copy_packages()
endmacro() 

include(${CTEST_SCRIPT_DIRECTORY}/../otb_common.cmake)
