# spec file for Monteverdi
%global uname Monteverdi
Name:  monteverdi
Version: 3.0.0
Release:  1%{?dist}
Summary:  %{uname} is the GUI interface built with OTB library and Qt
Group:    Applications/Engineering
License:  CeCILL
URL:	  http://www.orfeo-toolbox.org
Source0:  http://orfeo-toolbox.org/packages/%{uname}-%{version}.tar.gz
BuildRequires:  cmake
BuildRequires:  otb-devel >= 5.2.0
BuildRequires:  glfw-devel
BuildRequires:  glew-devel
BuildRequires:  freeglut-devel
BuildRequires:  libXmu-devel
BuildRequires:  gdal-devel >= 1.11.2
BuildRequires:  boost-devel
BuildRequires:  InsightToolkit-devel >= 4.7
BuildRequires: InsightToolkit-vtk  >= 4.7.1
BuildRequires:  ossim-devel >= 1.8.18
BuildRequires: libgeotiff-devel
BuildRequires: libpng-devel
BuildRequires: boost-devel
BuildRequires: expat-devel
BuildRequires: curl-devel
BuildRequires: tinyxml-devel
BuildRequires: muParser-devel
BuildRequires: OpenThreads-devel
BuildRequires: libjpeg-turbo-devel
### test package to install only jpeg plugin
###BuildRequires: gdal-openjpeg
#for generating man pages from help
BuildRequires: opencv-devel
BuildRequires:  zlib-devel
##build requires from itk
BuildRequires:  gdcm-devel
BuildRequires:  vxl-devel
BuildRequires:  python2-devel
BuildRequires:  otb-ice-devel >= 0.4.0
BuildRequires:  qwt5-qt4-devel

%description
%{uname} is the GUI interface built with OTB library and Qt

%prep
%setup -q -n %{uname}-%{version}

%build
mkdir -p %{_target_platform}
pushd %{_target_platform}
%cmake .. \
       -DCMAKE_INSTALL_PREFIX:PATH=%{_prefix} \
       -DBUILD_TESTING:BOOL=OFF \
       -DOTB_DIR:PATH=%{_libdir}/cmake/OTB-5.2 \
       -DQWT_LIBRARY:FILEPATH=%{_libdir}/libqwt5-qt4.so \
       -DQWT_INCLUDE_DIR:PATH=%{_includedir}/qwt5-qt4/ \
       -DMonteverdi2_INSTALL_LIB_DIR:PATH=%{_lib} \
       -DMONTEVERDI2_OUTPUT_NAME:STRING="monteverdi.bin" \
       -DMAPLA_OUTPUT_NAME:STRING="mapla.bin" 
       
popd
make %{?_smp_mflags} -C %{_target_platform}

%install
rm -rf %{buildroot}
%make_install -C %{_target_platform}

%post
cat > /usr/bin/monteverdi <<EOF
#!/bin/sh
export OTB_APPLICATION_PATH=%{_libdir}/otb/applications
/usr/bin/monteverdi.bin \$@
EOF

cat > /usr/bin/mapla <<EOF
#!/bin/sh
export OTB_APPLICATION_PATH=%{_libdir}/otb/applications
/usr/bin/mapla.bin \$@
EOF

chmod +x /usr/bin/mapla
chmod +x /usr/bin/monteverdi

/sbin/ldconfig

%postun
/sbin/ldconfig
rm -f /usr/bin/monteverdi
rm -f /usr/bin/mapla

%files
%{_libdir}/libMonteverdi2*
%{_bindir}/monteverdi.bin
%{_bindir}/mapla.bin
%{_datadir}/otb/*
%{_datadir}/icons/*
%{_datadir}/pixmaps/*
%{_datadir}/applications/*
%dir %{_datadir}/icons
%dir %{_datadir}/pixmaps
%dir %{_datadir}/applications
%dir %{_datadir}/icons/hicolor
#%dir %{_datadir}/icons/hicolor/16x16
#%dir %{_datadir}/icons/hicolor/32x32
#%dir %{_datadir}/icons/hicolor/48x48
#%dir %{_datadir}/icons/hicolor/128x128


%changelog
* Mon Dec 28 2015 Rashad Kanavath <rashad.kanavath@c-s.fr> - 3.0.0-1
- new upstream release 3.0.0

* Wed Apr 29 2015 Rashad Kanavath <rashad.kanavath@c-s.fr> - 0.9.0-1
- use _datadir/share instead of adding _sharedir variable

* Tue Apr 28 2015 Rashad Kanavath <rashad.kanavath@c-s.fr> - 0.9.0-1
- update for OTB-4.5.0

* Tue Dec 23 2014 Rashad Kanavath <rashad.kanavath@c-s.fr> - 0.8.0-1
- Initial package for Monteverdi2

* Wed Nov 19 2014 Rashad Kanavath <rashad.kanavath@c-s.fr> - 0.8.0-1
- add launcher script to set ITK_AUTOLOAD_PATH
