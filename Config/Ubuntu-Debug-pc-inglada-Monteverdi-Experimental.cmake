SET( SITE "pc-grizonnetm" CACHE STRING "ubuntuDebug" FORCE )
SET( CMAKE_BUILD_TYPE "Debug" CACHE STRING "ubuntuDebug" FORCE )
SET( OTB_DIR "/mnt/sdb1/OTB/OTB-Binary-Experimental" CACHE STRING "ubuntuDebug" FORCE )
SET( OTB_DATA_ROOT "/mnt/sdb1/OTB/trunk/OTB-Data" CACHE STRING "ubuntuDebug" FORCE )
SET( BUILD_TESTING "ON" CACHE STRING "ubuntuDebug" FORCE )
SET( OTB_USE_VTK "ON" CACHE STRING "ubuntuDebug" FORCE )
SET( CMAKE_C_FLAGS " -Wall  -Wno-uninitialized -Wno-unused-variable" CACHE STRING "ubuntuDebug" FORCE )
SET( CMAKE_CXX_FLAGS " -Wall -Wno-deprecated -Wno-uninitialized -Wno-unused-variable" CACHE STRING "ubuntuDebug" FORCE )
SET( CMAKE_EXE_LINKER " " CACHE STRING "ubuntuDebug" FORCE )
SET( MAKECOMMAND "/usr/bin/make -i -k -j 8" CACHE STRING "ubuntuDebug" FORCE )
SET( OTB_DATA_USE_LARGEINPUT ON CACHE BOOL "ubuntuDebug" FORCE )
SET( OTB_DATA_LARGEINPUT_ROOT "/mnt/sdb1/OTB/trunk/LargeInput" CACHE STRING "ubuntuDebug" FORCE )

SET( CMAKE_INSTALL_PREFIX "/mnt/sdb1/OTB/tmp" CACHE STRING "Used for package generation" FORCE )
SET( OTB_USE_CPACK ON CACHE BOOL "Use CPack" FORCE )
SET( CPACK_BINARY_DEB ON CACHE BOOL "Generate ubuntu package" FORCE )
SET( CPACK_ubuntu_PACKAGE_ARCHITECTURE "EM64T" CACHE STRING "ubuntu Architecture" FORCE)
