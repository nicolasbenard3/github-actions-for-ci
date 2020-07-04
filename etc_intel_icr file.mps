# Example RPM metapackage .spec file for
# Intel(R) Cluster Ready architecture specification version 1.4
# This is an example only and should be modified as needed for its intended purpose

# The following options are needed to support older RPM versions
%define _binary_payload w9.gzdio
%define _binary_filedigest_algorithm 1
%define _source_filedigest_algorithm 1
# Set minimum RPM version required on the node
%define _minrpm 4.4

# Match the version of the metapackage to the specification version
%define _version 1.4

# ---------------------------------------------------------------------------
# Metapackage Header
# This section produces the main package used on all cluster nodes

Name: cluster_ready-meta
Version: %{_version}
Release: 1
Summary: Intel(R) Cluster Ready Metapackage for Specification %{_version}
Group: System Environment/Base
URL: TBD
License: To be completed by implementer
BuildArch: x86_64
Provides: cluster_ready-meta = %{_version}
Requires: rpm >= %{_minrpm}

# Libraries and binaries required by the architecture specification are identified.
# in this example, requirements are grouped by section in the specification document
# Section 5.2.5
Requires: ld-linux-x86-64.so.2()(64bit)
Requires: libBrokenLocale.so.1()(64bit)
Requires: libSegFault.so()(64bit)
Requires: libacl.so.1()(64bit)
Requires: libanl.so.1()(64bit)
Requires: libattr.so.1()(64bit)
Requires: libbz2.so.1()(64bit)
Requires: libc.so.6()(64bit)
Requires: libcap.so.2()(64bit)
Requires: libcidn.so.1()(64bit)
Requires: libcrypt.so.1()(64bit)
Requires: libcrypto.so.6()(64bit)
Requires: libdl.so.2()(64bit)
Requires: libgcc_s.so.1()(64bit)
Requires: libjpeg.so.62()(64bit)
Requires: libm.so.6()(64bit)
Requires: libncurses.so.5()(64bit)
Requires: libncursesw.so.5()(64bit)
Requires: libnsl.so.1()(64bit)
Requires: libnss_compat.so.2()(64bit)
Requires: libnss_dns.so.2()(64bit)
Requires: libnss_files.so.2()(64bit)
Requires: libnss_hesiod.so.2()(64bit)
Requires: libnss_ldap.so.2()(64bit)
Requires: libnss_nis.so.2()(64bit)
Requires: libnss_nisplus.so.2()(64bit)
Requires: libnuma.so.1()(64bit)
Requires: libpam.so.0()(64bit)
Requires: libpanel.so.5()(64bit)
Requires: libpanelw.so.5()(64bit)
Requires: libpthread.so.0()(64bit)
Requires: libresolv.so.2()(64bit)
Requires: librt.so.1()(64bit)
Requires: libstdc++.so.5()(64bit)
Requires: libstdc++.so.6()(64bit)
Requires: libthread_db.so.1()(64bit)
Requires: libutil.so.1()(64bit)
Requires: libuuid.so.1()(64bit)
Requires: libz.so.1()(64bit)
# Section 5.2.8
Requires: libfontconfig.so.1()(64bit)
Requires: libfreetype.so.6()(64bit)
Requires: libGL.so.1()(64bit)
Requires: libGLU.so.1()(64bit)
Requires: libICE.so.6()(64bit)
Requires: libSM.so.6()(64bit)
Requires: libX11.so.6()(64bit)
Requires: libXau.so.6()(64bit)
Requires: libxcb.so.1()(64bit)
Requires: libXcursor.so.1()(64bit)
Requires: libXext.so.6()(64bit)
Requires: libXfixes.so.3()(64bit)
Requires: libXft.so.2()(64bit)
Requires: libXi.so.6()(64bit)
Requires: libXinerama.so.1()(64bit)
Requires: libXmu.so.6()(64bit)
Requires: libXp.so.6()(64bit)
Requires: libXrandr.so.2()(64bit)
Requires: libXrender.so.1()(64bit)
Requires: libXt.so.6()(64bit)
Requires: libXtst.so.6()(64bit)
Requires: libXxf86vm.so.1()(64bit)
# Section 5.3.2
Requires: perl >= 5.10
# Section 5.3.3
Requires: python >= 2.6
# Section 5.3.4
Requires: tcl >= 8.5
# Section 5.5
Requires: /usr/bin/ssh
Requires: /usr/sbin/sshd

%description
Metapackage for Intel(R) Cluster Ready. Requires RPM %{_minrpm} or later.
Installs RPM packages required to meet specification version %{_version}.

%clean

%prep
# Clean build space
rm -rf %{buildroot}/*

%install
#Create a file containing the specification version
mkdir -p %{buildroot}/etc/intel/clck
echo CLUSTER_READY_VERSION=%{_version} > %{buildroot}/etc/intel/icr
# Create a libcrypto softlink for the optional fix
mkdir -p %{buildroot}/usr/lib64
ln -s libcrypto.so.0.9.8 %{buildroot}/usr/lib64/libcrypto.so.6

%changelog
# Update this area as needed

%files
%defattr(-,root,root)
%dir /etc/intel/
%attr(644,root,root) /etc/intel/icr

# ---------------------------------------------------------------------------
# A separate RPM is created for additional head node requirements

%package head
Summary: Intel(R) Cluster Ready head node metapackage for specification %{_version}
Group: System Environment/Base
Provides: cluster_ready-meta-head = %{_version}
Requires: cluster_ready-meta = %{_version}
# Section 5.3.5
Requires: /usr/bin/xauth
Requires: /usr/bin/xterm

%description head
Intel(R) Cluster Ready metapackage for head nodes. 
Installs additional RPM packages required to meet specification version %{_version}.

%files head
# No files installed

# ---------------------------------------------------------------------------
# An RPM is created to resolve a missing libcrypto dependency.
# Vendors have implemented different version schemes for OpenSSL packages,
# but the architecture specification requires a specific version.
# This RPM is only installed on Linux* distributions that use the alternate scheme.

%package libcrypto_fix

Summary: Optional fix for missing libcrypto.so.6 dependency
Group: System Environment/Base
Provides: libcrypto.so.6()(64bit)
Requires: libcrypto.so.0.9.8()(64bit)

%description libcrypto_fix
Metapackage for Intel(R) Cluster Ready specification version %{_version} for Linux* distributions using alternate OpenSSL versioning scheme. Provides dependency fix for libcrypto.so.6 using libcrypto.so.0.9.8.
If used, install this before other Cluster Ready metapackages.

%files libcrypto_fix
%defattr(-,root,root)
%attr(-,root,root) /usr/lib64/libcrypto.so.6









































































































































































 