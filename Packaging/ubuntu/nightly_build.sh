#!/bin/bash
# Script to automate nightly build of the OTB Ubuntu packages.
#
# 1. Add the following command in your crontab:
#
#    # m h  dom mon dow   command
#    30 20 * * 1-5 /path/to/nightly_build.sh
#
# 2. Adapt environment variables defined below (USER, HOME, SRCDIR)
#
# 3. Create and fill in ~/.tsocks.conf and ~/.dput.cf configuration files.
#
# Copyright (C) 2011 CNES - Centre National d'Etudes Spatiales
# by Sebastien DINOT <sebastien.dinot@c-s.fr>
#
# The OTB is distributed under the CeCILL license version 2. See files
# Licence_CeCILL_V2-en.txt (english version) or Licence_CeCILL_V2-fr.txt
# (french version) in 'Copyright' directory for details. This licenses are
# also available online:
# http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
# http://www.cecill.info/licences/Licence_CeCILL_V2-fr.txt

set -e

export PATH=/bin:/sbin:/usr/bin:/usr/sbin
export USER=otbval
export HOME=/home/$USER
export TSOCKS_CONF_FILE=$HOME/.tsocks.conf

SRCDIR=$HOME/Dashboard/src
CMDDIR=$SRCDIR/OTB-DevUtils/Packaging/ubuntu

TSOCKS=$(which tsocks)
TODAY=$(date +%Y%m%d)

# Clean previous builds
rm -rf /tmp/otb* /tmp/monteverdi*

# For each project ("OTB" must be the first one)
for project in OTB Monteverdi OTB-Applications OTB-Wrapping ; do

    # Update working copy
    cd $SRCDIR/$project
    $TSOCKS hg pull -u

    # Extract last tagged version identifier
    full_version=$(hg tags | head -n 2 | tail -n 1 | cut -d ' ' -f 1)
    major_version=$(echo $full_version | cut -d '.' -f 1)
    minor_version=$(echo $full_version | sed -e 's/^[0-9]\+\.\([0-9]\+\)[.-].*$/\1/')
    patch_version=$(echo $full_version | sed -e 's/^.*[.-]\(.*\)$/\1/')

    # Calculate next version identifier
    # If last_version = x.y.z   then next_version = x.(y+1).0
    # If last_version = x.y-RCz then next_version = x.y.0
    if [ "$(echo $patch_version | sed -e 's/^[0-9]\+$/NOTRC/')" == 'NOTRC' ] ; then
        minor_version=$(($minor_version + 1))
    fi
    patch_version=$TODAY
    next_version="${major_version}.${minor_version}.${patch_version}"

    # Set package number
    last_changeset=$(hg identify | cut -d ' ' -f 1)
    pkg_version="0+${last_changeset}"

    # Build source packages
    if [ "$project" == "OTB" ] ; then
        otb_version=$next_version
        otb_pkg_version=$pkg_version
        $CMDDIR/$project/make_ubuntu_packages.sh -d $SRCDIR/$project -r tip -o $otb_version -p $pkg_version -c "Nightly build"
    else
        $CMDDIR/$project/make_ubuntu_packages.sh -d $SRCDIR/$project -r tip -o $otb_version -p $pkg_version -c "Nightly build" -m $next_version
    fi

    case $project in
        OTB)
            pkg_name=otb
            ;;
        Monteverdi)
            pkg_name=monteverdi
            ;;
        OTB-Applications)
            pkg_name=otbapp
            ;;
        OTB-Wrapping)
            pkg_name=otb-wrapping
            ;;
    esac

    # Unless for OTB, wait OTB packages availability
    if [ "$project" != "OTB" ] ; then
        otb_pkg_avail=0
        ppa_url="http://ppa.launchpad.net/otb/orfeotoolbox-nightly/ubuntu/pool/main/o/otb"
        while [ $otb_pkg_avail -eq 0 ] ; do
            n=$($TSOCKS GET $ppa_url | sed -ne "s/^.* href=\"\(libotb_${otb_version}-0ppa~.*${otb_pkg_version}_all\.deb\)\".*$/\1/p" | wc -l)
            if [ $n -eq 3 ] ; then
                otb_pkg_avail=1
            else
                echo $(date '+%F %T: ') "Waiting for OTB package availability. Next check in 5 minutes."
                sleep 300
            fi
        done
    fi

    # Push source packages on Launchpad (through tsocks proxy if necessary)
    $TSOCKS dput -P ppa-otb-nightly /tmp/${pkg_name}_${next_version}-0ppa~*${pkg_version}_source.changes

done