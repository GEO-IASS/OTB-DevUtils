import sys
import os
import platform
import socket

if __name__ == "__main__":
        sys.path.append(os.getcwd()+"/OTB-DevUtils/Scripts")
        try:
                import Validation
        except:
                print 'Impossible to find Validation module (import Validation abort!!)'
                exit(1)

        if len(sys.argv) != 2:
                print "Error  -->   Usage: ", sys.argv[0], " WEEK/WEEKEND/DAY_TESTING/DAY_COMPILATION/LOCAL_TESTING"
                exit(1)

        x=Validation.TestProcessing()
        x.SetRunDir("D:\\")
        x.SetOutilsDir("D:\\")
        x.SetOtbDataLargeInputDir("D:\\OTB-CNES\\OTB-LargeInput")
        x.EnableUseOtbDataLargeInput()
        x.SetSourcesDir("D:\\")
        x.EnableUpdateNightlySources()

#        x.SetGeotiffIncludeDirs("D:\\OTB-OUTILS\\gdal\\sources\\gdal-1.6.0\\frmts\\gtiff\\libgeotiff")
#        x.SetTiffIncludeDirs("D:\\OTB-OUTILS\\gdal\\sources\\gdal-1.6.0\\frmts\\gtiff\\libtiff")
#        x.SetJpegIncludeDirs("D:\\OTB-OUTILS\\gdal\\sources\\gdal-1.6.0\\frmts\\jpeg\\libjpeg")
        x.SetGeotiffIncludeDirs("D:\\OTB-OUTILS\\gdal\\install-visual7\\include")
        x.SetTiffIncludeDirs("D:\\OTB-OUTILS\\gdal\\install-visual7\\include")
        x.SetJpegIncludeDirs("D:\\OTB-OUTILS\\gdal\\install-visual7\\include")

        reference_configuration = "visual7-static-release-itk-internal-fltk-internal"
        reference_configuration2 = "visual7-static-debug-itk-internal-fltk-external"

        # =========    DAY TESTING   ============ 
        if sys.argv[1] == "DAY_TESTING":
                x.EnableUpdateCurrentSources()
                x.DisableGenerateMakefiles()
                x.SetContinuousTesting()
                x.EnableTuTesting() 
                x.EnableTvTesting() 
                x.DisableTlTesting() 
                x.DisableTeTesting() 
                x.Run(reference_configuration)
 
        # =========    DAY COMPILATION   ============ 
        elif sys.argv[1] == "DAY_COMPILATION":
                x.EnableUpdateCurrentSources()
                x.DisableGenerateMakefiles()
                x.SetContinuousTesting()
                x.EnableTuTesting() 
                x.DisableTvTesting() 
                x.DisableTlTesting() 
                x.DisableTeTesting() 
                x.Run(reference_configuration)
 
        # =========    WEEK    ============ 
        elif sys.argv[1] == "WEEK":
                x.EnableUpdateNightlySources()
                x.DisableGenerateMakefiles()
                x.SetNightlyTesting()
                x.EnableTuTesting() 
                x.EnableTvTesting() 
                x.DisableTlTesting() 
                x.DisableTeTesting() 
                x.Run(reference_configuration)

        # =========    WEEKEND    ============ 
        elif sys.argv[1] == "WEEKEND":
                x.EnableUpdateNightlySources()
                x.EnableGenerateMakefiles()
                x.SetNightlyTesting()
                x.EnableTuTesting() 
                x.EnableTvTesting() 
                x.EnableTlTesting() 
                x.EnableTeTesting() 
                x.Run(reference_configuration)

        # =========    LOCAL TESTING   ============ 
        elif sys.argv[1] == "LOCAL_TESTING":
                x.EnableUpdateCurrentSources()
                x.EnableGenerateMakefiles()
                x.SetContinuousTesting()
                x.EnableTuTesting() 
                x.DisableTvTesting() 
                x.DisableTlTesting() 
                x.DisableTeTesting() 
                x.DisableCTest()
#                x.ForceExecution()
                x.Run(reference_configuration)
#                x.Run("visual7-static-debug-itk-internal-fltk-internal")
