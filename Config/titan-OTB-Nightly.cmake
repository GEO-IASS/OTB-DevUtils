
SET (CTEST_SOURCE_DIRECTORY "$ENV{HOME}/OTB/trunk/OTB-Nightly/")
SET (CTEST_BINARY_DIRECTORY "$ENV{HOME}/OTB/OTB-Binary-Nightly/")


# which ctest command to use for running the dashboard
SET (CTEST_COMMAND 
  "ctest -j6 -D Nightly -A ${CTEST_BINARY_DIRECTORY}/CMakeCache.txt -V"
  )

# what cmake command to use for configuring this dashboard
SET (CTEST_CMAKE_COMMAND 
  "cmake"
  )

# should ctest wipe the binary tree before running
SET (CTEST_START_WITH_EMPTY_BINARY_DIRECTORY TRUE)

# this is the initial cache to use for the binary tree, be careful to escape
# any quotes inside of this string if you use it
SET (CTEST_INITIAL_CACHE "
//Command used to build entire project from the command line.
MAKECOMMAND:STRING=/usr/bin/make -i -k -j5
//Name of the build
BUILDNAME:STRING=Deb50-64bits-Release
//Name of the computer/site where compile is being run
SITE:STRING=titan
//Data root
OTB_DATA_ROOT:STRING=/home/christop/OTB/trunk/OTB-Data
//Compilation options
CMAKE_C_FLAGS:STRING= -Wall -Wno-uninitialized -Wno-unused-variable
CMAKE_CXX_FLAGS:STRING= -Wall -Wno-deprecated -Wno-uninitialized -Wno-unused-variable
//Set up the build options
CMAKE_BUILD_TYPE:STRING=Release
BUILD_TESTING:BOOL=ON
BUILD_EXAMPLES:BOOL=ON
OTB_USE_VISU_GUI:BOOL=OFF
OTB_USE_CURL:BOOL=ON
OTB_USE_EXTERNAL_BOOST:BOOL=ON
OTB_USE_EXTERNAL_EXPAT:BOOL=ON
ITK_USE_PATENTED:BOOL=ON
OTB_USE_PATENTED:BOOL=ON
USE_FFTWD:BOOL=ON
USE_FFTWF:BOOL=ON
OTB_GL_USE_ACCEL:BOOL=ON 
ITK_USE_REVIEW:BOOL=ON 
ITK_USE_OPTIMIZED_REGISTRATION_METHODS:BOOL=ON 
")

# set any extra envionment varibles here
SET (CTEST_ENVIRONMENT
 "DISPLAY=:0"
)

