#!/bin/sh
#
# Copyright (C) 2016, 2017 by Centre National d'Etudes Spatiales (CNES)
#
# Author: Sebastien DINOT <sebastien.dinot@c-s.fr>
#

TOPDIR=$(pwd)

WORKINGDIR=${TOPDIR}/otb-license-migration
if [ -d "${WORKINGDIR}" ] ; then
    echo "* "
    echo "* ERROR: The working directory already exists (${WORKINGDIR})" >&2
    echo "*        You must delete it first" >&2
    echo "* "
    exit 1
fi

# Clone the OTB repository, pointing to "develop" branch (this is the branch
# that will be checked out).
git clone -b develop ssh://git@git.orfeo-toolbox.org/otb.git ${WORKINGDIR}

# Initialize the contributor identity
cd ${WORKINGDIR}
git config user.name "Sebastien Dinot"
git config user.email "sebastien.dinot@c-s.fr"

# Create a branch dedicated to license migration stuff
git checkout -b apache-license-migration

# The "MegaWave driver" author was unresponsive to our messages. So, we
# decided to remove its contribution. It was done in "remove_mwimageio"
# branch.
git merge -m "LICENSE: Merge existing work in relation to the license migration" \
    origin/remove_mwimageio

# Remove obsolete Date, Revision and RCSfile CVS properties
# Space at first position of the pattern is required to exclude lines like:
# static const char OSSIM_ID[] = "$Id$";

grep -Erl ' \$(Id|Date|Revision|RCSfile).*\$' . | \
    grep -Ev '/(\.git|SuperBuild|Copyright)/' | \
    xargs sed -i -e '/ \$\(Id\|Date\|Revision\|RCSfile\).*\$/d'
git commit -a -m "LICENSE: Remove obsolete CVS properties (Id, Date, Revision, RCSfile)"

grep -Erl 'Module:[^:]' . | \
    grep -Ev '/(\.git|SuperBuild|Copyright)/' | \
    grep -E '\.([cht](xx|pp)|h)$' | \
    xargs sed -i -e '/^ *Module: /d'
git commit -a -m "LICENSE: Remove useless references to itkModule"

# Update embedded copyright notices
${TOPDIR}/replace_headers.py

chmod 755 Utilities/Maintenance/SuperbuildDownloadList.sh
chmod 755 Utilities/Maintenance/TravisBuild.sh
git commit -a -m "LICENSE: File headers now state that OTB is released under the Apache license"

cp -f ${TOPDIR}/APACHE-LICENSE-V2.0 LICENSE
cp -f ${TOPDIR}/APACHE-LICENSE-V2.0 SuperBuild/LICENSE
git rm Copyright/License_Apache2.txt
git rm Copyright/Licence_CeCILL_V2-fr.txt
git rm Copyright/Licence_CeCILL_V2-en.txt
git rm SuperBuild/Copyright/LICENSE
git add LICENSE SuperBuild/LICENSE
git commit -m "LICENSE: Updated license text (CeCILL v2.0 => Apache v2.0)"

cp -f ${TOPDIR}/hand-adjusted/NOTICE NOTICE
git add NOTICE
git rm Copyright/Copyright.txt
git rm Copyright/CodeOTB-ITKCopyright.txt
git rm Copyright/CrispCopyright.txt
git rm Copyright/CSCopyright.txt
git rm Copyright/CurlCopyright.txt
git rm Copyright/GDALCopyright.txt
git rm Copyright/GLFWCopyright.txt
git rm Copyright/GeoTIFFCopyright.txt
git rm Copyright/IMTCopyright.txt
git rm Copyright/ITKCopyright.txt
git rm Copyright/KMLCopyright.txt
git rm Copyright/LibBOOSTCopyright.txt
git rm Copyright/LibSVMCopyright.txt
git rm Copyright/MuParserCopyright.txt
git rm Copyright/MuParserXCopyright.txt
git rm Copyright/OSGCopyright.txt
git rm Copyright/OSSIMCopyright.txt
git rm Copyright/OTBCopyright.txt
git rm Copyright/OpenCVCopyright.txt
git rm Copyright/OpenJPEGCopyright.txt
git rm Copyright/OpenMPICopyright.txt
git rm Copyright/SPTWCopyright.txt
git rm Copyright/TinyXMLCopyright.txt
git rm Copyright/VXLCopyright.txt
git commit -m "LICENSE: Third party copyrights moved in NOTICE file"

cp -f ${TOPDIR}/headers/header_apache_cpp.01    Copyright/CodeCopyright.txt
cp -f ${TOPDIR}/hand-adjusted/Description.txt   CMake/Description.txt
cp -f ${TOPDIR}/hand-adjusted/README.md         README.md
cp -f ${TOPDIR}/hand-adjusted/fr_FR.ts          i18n/fr_FR.ts
cp -f ${TOPDIR}/hand-adjusted/mvdAboutDialog.ui Modules/Visualization/MonteverdiGui/src/mvdAboutDialog.ui
cp -f ${TOPDIR}/hand-adjusted/Abstract.tex      Documentation/SoftwareGuide/Latex/Abstract.tex
cp -f ${TOPDIR}/hand-adjusted/FAQ.tex           Documentation/SoftwareGuide/Latex/FAQ.tex
git commit -a -m "LICENSE: Documentation now state that OTB is released under the Apache license"

cp -f ${TOPDIR}/hand-adjusted/Findcppcheck.cpp CMake/Findcppcheck.cpp
cp -f ${TOPDIR}/hand-adjusted/PythonCompile.py CMake/PythonCompile.py
git commit -a -m "LICENSE: Removed undue copyright notices (trivial code)"

cp -f ${TOPDIR}/hand-adjusted/FindGLEW.cmake        CMake/FindGLEW.cmake
cp -f ${TOPDIR}/hand-adjusted/FindOpenThreads.cmake CMake/FindOpenThreads.cmake
git commit -a -m "LICENSE: Reworked embedded copyright notices"
