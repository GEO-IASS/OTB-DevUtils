Name:           ossim
Version:        1.8.20
Release:        4%{?dist}
Summary:        Open Source Software Image Map library and command line applications
Group:          System Environment/Libraries
License:        LGPLv2+
URL:            http://trac.osgeo.org/ossim/wiki
Source0:        http://download.osgeo.org/ossim/source/%{name}-%{version}/%{name}-%{version}-3.tar.gz
Patch0: ossim-1.8.18-runtimedir.patch

BuildRequires: cmake
BuildRequires: geos-devel
BuildRequires: libgeotiff-devel
BuildRequires: libjpeg-devel
BuildRequires: libpng-devel
BuildRequires: OpenThreads-devel
BuildRequires: help2man

#name of library in upper case for use in description
%global name_ucase OSSIM
%global ossim_source_dir %{name}-%{version}-3

%description
%{name_ucase} is a powerful suite of geospatial libraries and applications
used to process remote sensing imagery, maps, terrain, and vector data.

%package   devel
Requires:  %{name}%{?_isa} = %{version}-%{release}
Summary:   Development files for %{name_ucase}
Requires:  ossim

%description devel
This provides all includes and libraries required for
development of %{name_ucase} library

%package   apps
Requires:  %{name}%{?_isa} = %{version}-%{release}
Summary:   %{name_ucase} applications
%description apps
This package provides applications built with %{name_ucase} library

%package   doc
BuildArch: noarch
Requires:  %{name}%{?_isa} = %{version}-%{release}
Summary:   Documentation for %{name_ucase}

%description doc
This provides documentation for %{name_ucase} library

%package   data
BuildArch: noarch
Requires:  %{name}%{?_isa} = %{version}-%{release}
Summary:   Additional data files for %{name_ucase}

%description data
This provides some .kwl templates and csv used for ossim projection.


%prep
#---
# Notes for debugging:
# -D on setup = Do not delete the directory before unpacking.
# -T on setup = Disable the automatic unpacking of the archives.
#---
%setup -q -n %{ossim_source_dir}

%patch0 -p1

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

#remove these to silence rpmlint
rm -frv ossim/specs ossim/doc/*.spec ossim/ospr.spec ossim/ossim.spec*


%build
mkdir -p build
pushd build
%cmake \
    -DBUILD_OSSIM_MPI_SUPPORT=OFF \
    -DBUILD_OSSIM_TEST_APPS=OFF \
    -DSubversion_SVN_EXECUTABLE="" \
    -DBUILD_WMS=OFF \
    -DINSTALL_LIBRARY_DIR:PATH=%{_libdir} \
    -DINSTALL_RUNTIME_DIR:PATH=%{_bindir}/ossim-apps/ \
    -DINSTALL_ARCHIVE_DIR:PATH=%{_libdir} \
    -DCMAKE_MODULE_PATH=%{_builddir}/%{ossim_source_dir}/ossim_package_support/cmake/CMakeModules \
     %{_builddir}/%{ossim_source_dir}/%{name}
make %{?_smp_mflags}
popd

%install
# Exports for ossim build:
export OSSIM_DEV_HOME=%{_builddir}/%{name}-%{version}

pushd build
make install DESTDIR=%{buildroot}
popd

mkdir -p %{buildroot}%{_datadir}/ossim/templates/
install -p -m644 -D ossim/etc/templates/ossim_preferences_template %{buildroot}%{_datadir}/ossim/ossim_preferences
install -p -m644 -D ossim/etc/templates/* %{buildroot}%{_datadir}/ossim/templates/

%global ossim_cmakedir ossim_package_support/cmake/CMakeModules
mkdir -p %{buildroot}%{_libdir}/cmake/ossim/
for cmake_file in Findossim.cmake OssimQt4Macros.cmake OssimQt5Macros.cmake OssimUtilities.cmake OssimCommonVariables.cmake OssimVersion.cmake; do
    install -p -m644 %{ossim_cmakedir}/$cmake_file %{buildroot}%{_libdir}/cmake/ossim/$cmake_file;
done

%global help2man_opt "--no-discard-stderr"
%if 0%{?rhel} && 0%{?rhel} <= 7
  echo "skipping man pages"
  %global help2man_opt ""
%endif

echo "Generating man pages"
export PATH=%{buildroot}%{_bindir}/ossim-apps:$PATH
export LD_LIBRARY_PATH=%{buildroot}%{_libdir}
mkdir -p %{buildroot}%{_mandir}/man1
for app in `ls %{buildroot}%{_bindir}/ossim-apps/ossim-*` ; do
  if [[ $app == *space-imaging* || $app == *pixelflip* || $app == *image-synth* || $app == *create-cg* || $app == *adrg-dump* || $app == *swapbytes*  ]]; then
    help2man `basename $app` %{help2man_opt} --help-option=' ' --version-string=%{version} -o %{buildroot}%{_mandir}/man1/`basename $app`.1;
  else
    help2man `basename $app` %{help2man_opt} -o %{buildroot}%{_mandir}/man1/`basename $app`.1;
  fi

  cat <<EOF > "%{buildroot}%{_bindir}/`basename $app`"
#!/bin/bash
export OSSIM_PREFS_FILE=/usr/share/ossim/ossim_preferences
/usr/%{_bindir}/ossim-apps/`basename $app` "$@"
EOF

  chmod +x %{buildroot}%{_bindir}/`basename $app`
done

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig

%files
%{_libdir}/libossim.so.*
%license ossim/LICENSE.txt

%files devel
%{_libdir}/libossim.so
%{_includedir}/ossim*
%{_libdir}/cmake/ossim/Findossim.cmake
%{_libdir}/cmake/ossim/OssimQt4Macros.cmake
%{_libdir}/cmake/ossim/OssimQt5Macros.cmake
%{_libdir}/cmake/ossim/OssimUtilities.cmake
%{_libdir}/cmake/ossim/OssimCommonVariables.cmake
%{_libdir}/cmake/ossim/OssimVersion.cmake
# pkgconfig/ossim.pc

%files apps
%{_bindir}/ossim-*
%{_bindir}/ossim-apps/ossim-*
%{_mandir}/man1/ossim*

%files doc
%doc ossim/README.txt


%files data
%{_datadir}/ossim/


%changelog
* Wed Dec 23 2015 Rashad Kanavath <rashad.kanavath@c-s.fr> - 1.8.20-4
- Update to ossim 1.8.20-3

* Fri Oct 30 2015 Rashad Kanavath <rashad.kanavath@c-s.fr> - 1.8.20-3
- Update ossim 1.8.20 with correct upstream sources

* Sun Aug 9 2015 Rashad Kanavath <rashad.kanavath@c-s.fr> - 1.8.18-2
- review on bugzilla ID 1244353. comment 21

* Sun Aug 2 2015 Rashad Kanavath <rashad.kanavath@c-s.fr> - 1.8.18-2
- review on bugzilla ID 1244353. comment 6-13

* Sat Aug 1 2015 Rashad Kanavath <rashad.kanavath@c-s.fr> - 1.8.18-2
- update spec after review on bugzilla ID 1244353. comment 5

* Mon Jul 20 2015 Rashad Kanavath <rashad.kanavath@c-s.fr> - 1.8.18-2
- update spec after review on bugzilla ID 1244353

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
