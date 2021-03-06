#Contact: arnaud.durand@sertit.u-strasbg.fr

#SERTIT - University of Strasbourg http://sertit.u-strasbg.fr

# otb_fetch_module(SertitObject
#   "This module provides 2 applications dedicated to object-oriented image analysis.

#    Aggregate application:

# The aim of this application is to merge the result of a segmentation with a
# pixel-based image classification in order to produce an object-oriented image
# classification. The input segmentation is a labeled image, typically the result
# provided by the OTB application LSMSSegmentation. The output is a vector dataset
# containing objects and the corresponding class in the attribute table. Connected
# regions belonging to the same class are merged. This application could be used
# at the last step of the LSMS pipeline in replacement of the application
# LSMSVectorization.

#    ObjectsRadiometricStatistics application:

# This application computes radiometric and shape attributes on a vector dataset,
# using an image. The results are stored in the attribute table. Shape attributes
# are : number of pixels, flatness, roundness, elongation, perimeter. Radiometric
# attributes are for each band of the input image : mean, standard-deviation,
# median, variance, kurtosis, skewness. The result could be use to perform futher
# object-oriented image analysis.
# "
#   GIT_REPOSITORY https://github.com/sertit/SertitObject.git
#   GIT_TAG 90c369e9a197b3f83cb18e1d7bc594313fef63d5
# )

set(dashboard_model Nightly)
set(CTEST_BUILD_CONFIGURATION Release)
set(dashboard_module "SertitObject")
# set(dashboard_module_url "https://github.com/sertit/SertitObject")
set(MXE_TARGET_ARCH "i686")

include(${CTEST_SCRIPT_DIRECTORY}/bumblebee_common.cmake)

include(${CTEST_SCRIPT_DIRECTORY}/../mxe_common.cmake)
set(dashboard_cache "${mxe_common_cache}")

include(${CTEST_SCRIPT_DIRECTORY}/../otb_common.cmake)
