import sys
import os
import platform
import socket
#import subprocess

if __name__ == "__main__":
        sys.path.append(os.getcwd()+"/OTB-DevUtils/Scripts")
        try:
                import Validation
        except:
                print 'Impossible to find Validation module (import Validation abort!!)'
                exit(1)

        #os.chdir("..")
        x=Validation.TestProcessing()
        x.SetRunDir("D:\\")
        x.SetOutilsDir("D:\\")
        x.SetOtbDataLargeInputDir("X:\\OTB-Data-LargeInput")
        x.EnableUseOtbDataLargeInput()
        x.SetSourcesDir("D:\\")
        x.EnableUpdateSources()

        x.EnableGenerateMakefiles()

        # List of platform must been tested
	x.Run("visual7-static-debug-itk-internal-fltk-internal")

