#!/bin/bash
# Script to automate the Orfeo Toolbox library packaging for Ubuntu.
#
# Copyright (C) 2010, 2011 CNES - Centre National d'Etudes Spatiales
# by Sebastien DINOT <sebastien.dinot@c-s.fr>
#
# The OTB is distributed under the CeCILL license version 2. See files
# Licence_CeCILL_V2-en.txt (english version) or Licence_CeCILL_V2-fr.txt
# (french version) in 'Copyright' directory for details. This licenses are
# also available online:
# http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
# http://www.cecill.info/licences/Licence_CeCILL_V2-fr.txt


SCRIPT_VERSION="1.0"

if [ -z "$DEBFULLNAME" ]; then
  DEBFULLNAME="OTB Team"
fi

if [ -z "$DEBEMAIL" ]; then
  DEBEMAIL="contact@orfeo-toolbox.org"
fi

export DEBFULLNAME
export DEBEMAIL

TMPDIR="/tmp"
DIRNAME=$(dirname $0)
if [ "${DIRNAME:0:1}" == "/" ] ; then
    CMDDIR=$DIRNAME
elif [ "${DIRNAME:0:1}" == "." ] ; then
    CMDDIR=$(pwd)/${DIRNAME:2}
else
    CMDDIR=$(pwd)/$DIRNAME
fi
DEBDIR=$CMDDIR/debian
DEFAULT_GPGKEYID=0xAEB3D22F


display_version ()
{
    cat <<EOF

make_ubuntu_packages.sh, version ${SCRIPT_VERSION}
Copyright (C) 2010, 2011 CNES (Centre National d'Etudes Spatiales)
by Sebastien DINOT <sebastien.dinot@c-s.fr>

EOF
}


display_help ()
{
    cat <<EOF

This script is used to automate the OTB Python and Java bindings packaging for
Ubuntu. Source packages are created in ${TMPDIR} directory.

Usage:
  ./make_ubuntu_packages.sh [options]

Options:
  -h            Display this short help message.

  -v            Display version and copyright informations.

  -d directory  Top directory of the local repository clone

  -r tag        Revision to extract.

  -m version    External version of the OTB bindings (ex. 1.4.0)

  -o version    External version of the OTB library (ex. 3.8.0)

  -p version    Version of the package (ex. 2)

  -c message    Changelog message

  -g id         GnuPG key id used for signing (default ${DEFAULT_GPGKEYID})

Example:
  ./make_ubuntu_packages.sh -d ~/otb/src/OTB-Wrapping -r 1551 -o 3.8-RC1 -m 1.6-RC1 -p 2

EOF
}


check_src_top_dir ()
{
    if [ -z "$topdir" ] ; then
        echo "*** ERROR: missing top directory of the Mercurial working copy (option -d)"
        echo "*** Use ./make_ubuntu_packages.sh -h to show command line syntax"
        exit 3
    fi
    if [ ! -d "$topdir" ] ; then
        echo "*** ERRROR: directory '$topdir' doesn't exist"
        exit 2
    fi
    if [ ! -d "$topdir/.hg" ] ; then
        echo "*** ERRROR: No Mercurial working copy found in '$topdir' directory"
        exit 2
    fi
    if [ "$(hg identify $topdir)" == "000000000000 tip" ] ; then
        echo "*** ERROR: Mercurial failed to identify a valid repository in '$topdir'"
        exit 2
    fi
    topdir=$( cd $topdir ; pwd )
}


check_src_revision ()
{
    if [ -z "$revision" ] ; then
        echo "*** ERROR: missing revision identifier of the repository (option -r)"
        echo "*** Use ./make_ubuntu_packages.sh -h to show command line syntax"
        exit 3
    fi
    olddir=$(pwd)
    cd "$topdir"
    if ! hg log -r "$revision" &>/dev/null ; then
        echo "*** ERROR: Revision $revision unknown"
        exit 2
    fi
    cd "$olddir"
}


check_external_version ()
{
    if [ -z "$src_version_full" ] ; then
        echo "*** ERROR: missing version number of OTB bindings (option -m)"
        echo "*** Use ./make_ubuntu_packages.sh -h to show command line syntax"
        exit 3
    fi
    if [ "`echo $src_version_full | sed -e 's/^[0-9]\+\.[0-9]\+\(\.[0-9]\+\|-RC[0-9]\+\)$/OK/'`" != "OK" ] ; then
        echo "*** ERROR: OTB bindings full version ($src_version_full) has an unexpected format"
        exit 3
    fi
    if [ -z "$otb_version_full" ] ; then
        echo "*** ERROR: missing version number of OTB (option -o)"
        echo "*** Use ./make_ubuntu_packages.sh -h to show command line syntax"
        exit 3
    fi
    if [ "`echo $otb_version_full | sed -e 's/^[0-9]\+\.[0-9]\+\(\.[0-9]\+\|-RC[0-9]\+\)$/OK/'`" != "OK" ] ; then
        echo "*** ERROR: OTB full version ($otb_version_full) has an unexpected format"
        exit 3
    fi

    src_version_major=`echo $src_version_full | sed -e 's/^\([0-9]\+\)\..*$/\1/'`
    src_version_minor=`echo $src_version_full | sed -e 's/^[^\.]\+\.\([0-9]\+\)[\.-].*$/\1/'`
    src_version_patch=`echo $src_version_full | sed -e 's/^.*[\.-]\(\(RC\)\?[0-9]\+\)$/\1/'`

    otb_version_major=`echo $otb_version_full | sed -e 's/^\([0-9]\+\)\..*$/\1/'`
    otb_version_minor=`echo $otb_version_full | sed -e 's/^[^\.]\+\.\([0-9]\+\)[\.-].*$/\1/'`
    otb_version_patch=`echo $otb_version_full | sed -e 's/^.*[\.-]\(\(RC\)\?[0-9]\+\)$/\1/'`
    otb_version_soname="${otb_version_major}.${otb_version_minor}"
}


check_gpgkeyid ()
{
    if [ -z "$gpgkeyid" ] ; then
        gpgkeyid=$DEFAULT_GPGKEYID
    fi
    gpg --list-secret-keys $gpgkeyid &>/dev/null
    if [ "$?" -ne 0 ] ; then
        echo "*** ERROR: Secret part of the GnuPG key $gpgkeyid is unavailable, packages can't be signed"
        exit 4
    fi
}


set_ubuntu_code_name ()
{
    case "$1" in
        "raring" )
            ubuntu_codename="Raring"
            ubuntu_version="13.04"
            ;;
        "quantal" )
            ubuntu_codename="Quantal Quetzal"
            ubuntu_version="12.10"
            ;;
        "precise" )
            ubuntu_codename="Precise Pangolin"
            ubuntu_version="12.04"
            ;;
        "oneiric" )
            ubuntu_codename="Oneiric Ocelot"
            ubuntu_version="11.10"
            ;;
        "natty" )
            ubuntu_codename="Natty Narwhal"
            ubuntu_version="11.04"
            ;;
        "maverick" )
            ubuntu_codename="Maverick Meerkat"
            ubuntu_version="10.10"
            ;;
        "lucid" )
            ubuntu_codename="Lucid Lynx"
            ubuntu_version="10.04 LTS"
            ;;
        "karmic" )
            ubuntu_codename="Karmic Koala"
            ubuntu_version="9.10"
            ;;
        "hardy" )
            ubuntu_codename="Hardy Heron"
            ubuntu_version="08.04 LTS"
            ;;
        * )
            echo "*** ERROR: Unknown Ubuntu version name"
            exit 4
            ;;
    esac
}


while getopts ":r:d:m:o:p:c:g:hv" option
do
    case $option in
        d ) topdir=$OPTARG
            ;;
        r ) revision=$OPTARG
            ;;
        m ) src_version_full=$OPTARG
            ;;
        o ) otb_version_full=$OPTARG
            ;;
        p ) pkg_version=$OPTARG
            ;;
        c ) changelog_message=$OPTARG
            ;;
        g ) gpgkeyid=$OPTARG
            ;;
        v ) display_version
            exit 0
            ;;
        h ) display_help
            exit 0
            ;;
        * ) echo "*** ERROR: Unknown option -$OPTARG (arg #"$(($OPTIND - 1))")"
            display_help
            exit 0
            ;;
    esac
done

if [ "$OPTIND" -eq 1 ] ; then
    display_help
    exit 1
fi

echo "Command line checking..."
check_src_top_dir
check_src_revision
check_external_version
check_gpgkeyid

echo "Archive export..."
cd "$topdir"
hg archive -r "$revision" -t tgz "$TMPDIR/otb-wrapping-$src_version_full.tar.gz"

echo "Archive extraction..."
cd "$TMPDIR"
tar xzf "otb-wrapping-$src_version_full.tar.gz"
mv "otb-wrapping-$src_version_full.tar.gz" "otb-wrapping_$src_version_full.orig.tar.gz"

echo "Debian scripts import..."
cd "$TMPDIR/otb-wrapping-$src_version_full"
cp -a "$DEBDIR" .
cd debian
for f in control rules ; do
    sed -e "s/@SRC_VERSION_MAJOR@/$src_version_major/g" \
        -e "s/@SRC_VERSION_MINOR@/$src_version_minor/g" \
        -e "s/@SRC_VERSION_PATCH@/$src_version_patch/g" \
        -e "s/@SRC_VERSION_FULL@/$src_version_full/g" \
        -e "s/@OTB_VERSION_MAJOR@/$otb_version_major/g" \
        -e "s/@OTB_VERSION_SONAME@/$otb_version_soname/g" \
        -e "s/@OTB_VERSION_FULL@/$otb_version_full/g" \
        < "$f.in" > "$f"
    rm -f "$f.in"
done

echo "Source package generation..."
cd "$TMPDIR/otb-wrapping-$src_version_full"
#for target in precise quantal raring ; do
for target in precise ; do
    set_ubuntu_code_name "$target"
    echo "Package for $ubuntu_codename ($ubuntu_version)"
    cp -f "$DEBDIR/changelog" debian
    if [ -n "$changelog_message" ] ; then
        dch_message="$changelog_message"
    else
        dch_message="Automated update for $ubuntu_codename ($ubuntu_version)."
    fi
    dch --force-distribution --distribution "$target" \
        -v "${src_version_full}-0ppa~${target}${pkg_version}" "$dch_message"
    debuild -k$gpgkeyid -S -sa --lintian-opts -i
done
