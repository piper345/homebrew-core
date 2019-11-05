class Rpm < Formula
  desc "Standard unix software packaging tool"
  homepage "https://rpm.org/"
  url "http://ftp.rpm.org/releases/rpm-4.15.x/rpm-4.15.0.tar.bz2"
  sha256 "1e06723b13591e57c99ebe2006fb8daddc4cf72efb366a64a34673ba5f61c201"
  version_scheme 1

  bottle do
    sha256 "78bbeca72764e18eab6b75fa8fe0c450e5f47aa2ea9a00a607ecd2727a816e1f" => :catalina
    sha256 "1a4da220ae37c016815055778b94e3395c9acb2a460c6c1df87b15e834ec0dfb" => :mojave
    sha256 "49be9aa93d8eb6e55a8b8e4e8214a70de9e4fe31bfbe68055ab7d19db1d3d467" => :high_sierra
    sha256 "dc328eff0beb50f5a08b1ac4f98153c4471c2f0a53b3e4db4c5eef380757ac53" => :sierra
  end

  depends_on "berkeley-db"
  depends_on "gettext"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "libomp"
  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "popt"
  depends_on "xz"
  depends_on "zstd"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["lua"].opt_libexec/"lib/pkgconfig"
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"
    ENV.append "LDFLAGS", "-lomp"

    # only rpm should go into HOMEBREW_CELLAR, not rpms built
    inreplace ["macros.in", "platform.in"], "@prefix@", HOMEBREW_PREFIX

    # ensure that pkg-config binary is found for dep generators
    inreplace "scripts/pkgconfigdeps.sh",
              "/usr/bin/pkg-config", Formula["pkg-config"].opt_bin/"pkg-config"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sharedstatedir=#{var}/lib",
                          "--sysconfdir=#{etc}",
                          "--with-path-magic=#{HOMEBREW_PREFIX}/share/misc/magic",
                          "--enable-nls",
                          "--disable-plugins",
                          "--with-external-db",
                          "--with-crypto=openssl",
                          "--without-apidocs",
                          "--with-vendor=homebrew"
    system "make", "install"
  end

  def post_install
    (var/"lib/rpm").mkpath

    # Attempt to fix expected location of GPG to a sane default.
    inreplace lib/"rpm/macros", "/usr/bin/gpg2", HOMEBREW_PREFIX/"bin/gpg"
  end

  def test_spec
    <<~EOS
      Summary:   Test package
      Name:      test
      Version:   1.0
      Release:   1
      License:   Public Domain
      Group:     Development/Tools
      BuildArch: noarch

      %description
      Trivial test package

      %prep
      %build
      %install
      mkdir -p $RPM_BUILD_ROOT/tmp
      touch $RPM_BUILD_ROOT/tmp/test

      %files
      /tmp/test

      %changelog

    EOS
  end

  def rpmdir(macro)
    Pathname.new(`#{bin}/rpm --eval #{macro}`.chomp)
  end

  test do
    (testpath/"rpmbuild").mkpath

    # Falsely flagged by RuboCop.
    # rubocop:disable Style/FormatStringToken
    (testpath/".rpmmacros").write <<~EOS
      %_topdir		#{testpath}/rpmbuild
      %_tmppath		%{_topdir}/tmp
    EOS
    # rubocop:enable Style/FormatStringToken

    system "#{bin}/rpm", "-vv", "-qa", "--dbpath=#{testpath}/var/lib/rpm"
    assert_predicate testpath/"var/lib/rpm/Packages", :exist?,
                     "Failed to create 'Packages' file!"
    rpmdir("%_builddir").mkpath
    specfile = rpmdir("%_specdir")+"test.spec"
    specfile.write(test_spec)
    system "#{bin}/rpmbuild", "-ba", specfile
    assert_predicate rpmdir("%_srcrpmdir")/"test-1.0-1.src.rpm", :exist?
    assert_predicate rpmdir("%_rpmdir")/"noarch/test-1.0-1.noarch.rpm", :exist?
    system "#{bin}/rpm", "-qpi", "--dbpath=#{testpath}/var/lib/rpm",
                         rpmdir("%_rpmdir")/"noarch/test-1.0-1.noarch.rpm"
  end
end
