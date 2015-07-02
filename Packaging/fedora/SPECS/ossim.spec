#name of library as it is
%define sname OSSIM
Name:           ossim
Version:        1.8.18
Release:        2%{?dist}
Summary:        Open Source Software Image Map library and command line applications
Group:          System Environment/Libraries
#TODO: Which version?
License:        LGPLv2+
URL:            http://trac.osgeo.org/ossim/wiki
#created from svn revision 23275
#svn export ossim ossim-1.8.19
#tar cvf ossim-1.8.19.tar.xz ossim-1.8.19
Source0:        http://download.osgeo.org/ossim/source/%{name}-%{version}-1/%{name}-%{version}-1.tar.gz
#BuildRequires: ant
BuildRequires: cmake
#BuildRequires: gdal-devel
BuildRequires: geos-devel
#BuildRequires: hdf-devel
#BuildRequires: hdf5-devel
#BuildRequires: java-devel
BuildRequires: libcurl-devel
BuildRequires: libgeotiff-devel
BuildRequires: libjpeg-devel
BuildRequires: libpng-devel
# BuildRequires: libraw-devel
#BuildRequires: minizip-devel
#BuildRequires: OpenSceneGraph-devel
BuildRequires: OpenThreads-devel
#BuildRequires: podofo-devel
#BuildRequires: qt4-devel
#BuildRequires: swig
BuildRequires: help2man

%description
%{sname} is a powerful suite of geospatial libraries and applications
used to process remote sensing imagery, maps, terrain, and vector data.

%package	    devel
Summary:        Development files for %{sname}
Group:          Development/Libraries
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description devel
This provides all includes and libraries required for
development of %{sname} library

%package 	apps
Summary:        %{sname} applications
Group:          System Environment/Libraries
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description apps
This package provides applications built with %{sname} library

%package	    doc
Summary:        Documentation for %{sname}
Group:          Documentation
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description doc
This provides documentation for %{sname} library

%package	    data
Summary:        Additional data files for %{sname}
Group:          Documentation
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description data
This provides data and configuration files for %{sname} library


%prep
#---
# Notes for debugging:
# -D on setup = Do not delete the directory before unpacking.
# -T on setup = Disable the automatic unpacking of the archives.
#---
# %setup -q -D -T
%setup -q -D

#csm_plugins  libwms  ossim     ossimjni               ossimPlanet    ossim_plugins  ossim_qt4       pqe
#csmApi  gsoc         oms     ossimGui  ossim_package_support  ossimPlanetQt  ossimPredator  planet_message  SVN-INFO.txt

#Keep only ossim library sources for now. Add each lib as we move on..
for tparty in csm* libwms ossimjni oms ossim_plugins ossim_q* ossimPlane* ossimGui gsoc planet_message ossimPredator pqe; do \
    rm -frv ${tparty}; \
done

#remove rpms to keep rpmlint away from those spec files
for tparty in windows_package rpms; do \
    rm -frv ossim_package_support/${tparty}; \
done

#remove this to silence rpmlint
rm -frv ossim/specs ossim/doc/*.spec ossim/ospr.spec ossim/ossim.spec*


%build
# Exports for ossim build:
export OSSIM_DEV_HOME=%{_builddir}/%{name}-%{version}

mkdir -p build
pushd build
%cmake \
    -DBUILD_CSMAPI=OFF \
    -DBUILD_OMS=OFF \
    -DBUILD_OSSIMGUI=ON \
    -DBUILD_OSSIM_MPI_SUPPORT=OFF \
    -DBUILD_OSSIMPLANET=OFF \
    -DBUILD_OSSIMPLANETQT=OFF \
    -DBUILD_OSSIMPREDATOR=OFF \
    -DBUILD_OSSIMQT4=OFF \
    -DBUILD_OSSIM_TEST_APPS=OFF \
    -DSubversion_SVN_EXECUTABLE="" \
    -DBUILD_WMS=OFF \
    -DINSTALL_LIBRARY_DIR:PATH=%{_libdir} \
    -DINSTALL_ARCHIVE_DIR:PATH=%{_libdir} \
    -DCMAKE_MODULE_PATH=$OSSIM_DEV_HOME/ossim_package_support/cmake/CMakeModules \
     $OSSIM_DEV_HOME/%{name}
make %{?_smp_mflags}
popd

%install
# Exports for ossim build:
export OSSIM_DEV_HOME=%{_builddir}/%{name}-%{version}

pushd build
make install DESTDIR=%{buildroot}
popd

install -p -m644 -D ossim/etc/linux/profile.d/ossim.sh %{buildroot}%{_sysconfdir}/profile.d/ossim.sh
install -p -m644 -D ossim/etc/linux/profile.d/ossim.csh %{buildroot}%{_sysconfdir}/profile.d/ossim.csh
install -p -m644 -D ossim/etc/templates/ossim_preferences_template %{buildroot}%{_datadir}/ossim/ossim_preferences

%global ossim_cmakedir ossim_package_support/cmake/CMakeModules
mkdir -p %{buildroot}%{_libdir}/cmake/ossim/
for file in Findossim.cmake OssimQt4Macros.cmake OssimQt5Macros.cmake OssimUtilities.cmake OssimCommonVariables.cmake OssimVersion.cmake; do
    install -p -m644 %{ossim_cmakedir}/$file %{buildroot}%{_libdir}/cmake/ossim/$file;
done

%global help2man_opt "--no-discard-stderr"
%if 0%{?rhel} && 0%{?rhel} <= 7
echo "skipping man pages"
%global help2man_opt ""
%endif

echo "Generating man pages"
export PATH=$PATH:%{buildroot}%{_bindir}
export LD_LIBRARY_PATH=%{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_mandir}/man1
for file in `ls %{buildroot}%{_bindir}/ossim-*` ; do
    if [[ $file == *space-imaging* || $file == *swapbytes*  ]]; then
	help2man `basename $file` %{help2man_opt} --help-option=' ' --version-string=%{version} -o %{buildroot}%{_mandir}/man1/`basename $file`.1;
    else
	help2man `basename $file` %{help2man_opt} -o %{buildroot}%{_mandir}/man1/`basename $file`.1;
    fi
done

%post -n ossim -p /sbin/ldconfig

%postun -n ossim -p /sbin/ldconfig

%files
%{_libdir}/libossim.so.*

%files devel
%{_includedir}/ossim*
%{_libdir}/*.so*
%{_libdir}/cmake/ossim/Findossim.cmake
%{_libdir}/cmake/ossim/OssimQt4Macros.cmake
%{_libdir}/cmake/ossim/OssimQt5Macros.cmake
%{_libdir}/cmake/ossim/OssimUtilities.cmake
%{_libdir}/cmake/ossim/OssimCommonVariables.cmake
%{_libdir}/cmake/ossim/OssimVersion.cmake
# pkgconfig/ossim.pc

%files apps
%{_bindir}/ossim-*
%{_mandir}/man1/ossim*

%files doc
%doc ossim/LICENSE.txt

%files data
%{_datadir}/ossim/
%{_sysconfdir}/profile.d/ossim.sh
%{_sysconfdir}/profile.d/ossim.csh


%changelog
* Fri Apr 24 2015 Rashad Kanavath <rashad.kanavath@c-s.fr> - 1.8.18-2
- revert back to 1.8.18

* Fri Apr 24 2015 Rashad Kanavath <rashad.kanavath@c-s.fr> - 1.8.19-1
- update to ossim 1.8.19 svn revision 23275
- update cmake_source_dir


* Wed Nov 26 2014 Rashad Kanavath <rashad.kanavath@c-s.fr> - 1.8.18-1
- packaging just ossim and removing everything else
- adding doc, apps, data sub-packages
- included all applications generated man pages via help2man
- included Findossim.cmake and additional cmake files in devel

* Fri Jan 10 2014 David Burken <dburken@comcast.net> - 1.8.18-1
- Somewhat working version.
* Sun Dec 29 2013 Volker Fröhlich <volker27@gmx.at> - 1.8.18-1
- Initial package