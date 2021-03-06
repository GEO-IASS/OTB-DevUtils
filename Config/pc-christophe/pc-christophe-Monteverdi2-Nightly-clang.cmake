# Client maintainer: manuel.grizonnet@cnes.fr
set(dashboard_model Nightly)
set(CTEST_BUILD_CONFIGURATION Release)
set (CTEST_BUILD_NAME "Fedora22-64bits-${CTEST_BUILD_CONFIGURATION}")
include(${CTEST_SCRIPT_DIRECTORY}/pc-christophe_common.cmake)

set(dashboard_root_name "tests")
set(dashboard_source_name "sources/orfeo/trunk/Monteverdi2")
set(dashboard_binary_name "build/orfeo/trunk/Monteverdi2-clang-ThirdPartyTrunk")

set(MVD2_INSTALL_PREFIX ${CTEST_DASHBOARD_ROOT}/install/orfeo/trunk/Monteverdi2-clang-ThirdPartyTrunk)

#set(dashboard_fresh_source_checkout OFF)
set(dashboard_git_url "https://git@git.orfeo-toolbox.org/git/monteverdi2.git")

set(dashboard_git_features_list "${CTEST_SCRIPT_DIRECTORY}/../mvd_branches.txt")

macro(dashboard_hook_init)
  set(dashboard_cache "${dashboard_cache}
CTEST_USE_LAUNCHERS:BOOL=ON

CMAKE_INSTALL_PREFIX:STRING=${MVD2_INSTALL_PREFIX}
CMAKE_BUILD_TYPE:STRING=${CTEST_BUILD_CONFIGURATION}
BUILD_TESTING:BOOL=ON

CMAKE_C_COMPILER=/usr/bin/clang
CMAKE_CXX_COMPILER=/usr/bin/clang++
CMAKE_C_FLAGS:STRING=-Wall
CMAKE_CXX_FLAGS:STRING=-Wall -Wno-gnu-static-float-init -Wno-\\\\#warnings -Wno-unknown-attributes

OTB_DATA_USE_LARGEINPUT:BOOL=ON
OTB_DATA_ROOT:STRING=${CTEST_DASHBOARD_ROOT}/sources/orfeo/OTB-Data
OTB_DATA_LARGEINPUT_ROOT:STRING=/media/TeraDisk2/LargeInput

OTB_DIR:PATH=${CTEST_DASHBOARD_ROOT}/build/orfeo/trunk/OTB-clang-ThirdPartyTrunk/${CTEST_BUILD_CONFIGURATION}
ITK_DIR:PATH=${CTEST_DASHBOARD_ROOT}/build/itk/trunk/${CTEST_BUILD_CONFIGURATION}

# Qwt
QWT_INCLUDE_DIR:PATH=/usr/include/qwt5-qt4
QWT_LIBRARY:FILEPATH=/usr/lib64/libqwt.so.5

")
endmacro()

execute_process(COMMAND ${CTEST_CMAKE_COMMAND} -E remove_directory ${MVD2_INSTALL_PREFIX})
execute_process(COMMAND ${CTEST_CMAKE_COMMAND} -E make_directory ${MVD2_INSTALL_PREFIX})

include(${CTEST_SCRIPT_DIRECTORY}/../otb_common.cmake)
