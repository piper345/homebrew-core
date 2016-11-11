class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-util-1.5.4.tar.bz2"
  sha256 "a6cf327189ca0df2fb9d5633d7326c460fe2b61684745fd7963e79a6dd0dc82e"
  revision 4

  bottle do
    rebuild 1
    sha256 "315f64f6b345302aaeb9eb6635b6679e7460757da0cb1555f3610387813a44c7" => :sierra
    sha256 "d305a48dad4a0ceb01cc9cc874fbac7b18a6d1721cc4e385f8614dd6d666cbdb" => :el_capitan
    sha256 "df0ccddb589927e907f83149156b274dfaaaf8f82067f901f38789728a3193dc" => :yosemite
  end

  keg_only :provided_by_osx, "Apple's CLT package contains apr."

  option :universal
  option "without-openssl@1.1", "Build with openssl instead of openssl@1.1"

  depends_on "apr"
  depends_on "postgresql" => :optional
  depends_on "mysql" => :optional
  depends_on "freetds" => :optional
  depends_on "unixodbc" => :optional
  depends_on "sqlite" => :optional
  depends_on "homebrew/dupes/openldap" => :optional

  depends_on "openssl@1.1" => :recommended

  if build.with? "openssl@1.1"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # backports openssl 1.1 support
    patch do
      url "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/apr-util/apr-util_1.5.4-2.debian.tar.xz"
      mirror "https://mirrors.kernel.org/debian/pool/main/a/apr-util/apr-util_1.5.4-2.debian.tar.xz"
      sha256 "e8f0fdf94482c43dff69a207ecbf98cec602ab45869561800ccf46a09988caff"
      apply "patches/openssl-1.1.patch"
    end
  else
    depends_on "openssl"
  end

  def install
    ENV.universal_binary if build.universal?

    # Stick it in libexec otherwise it pollutes lib with a .exp file.
    args = %W[
      --prefix=#{libexec}
      --with-apr=#{Formula["apr"].opt_prefix}
      --with-crypto
    ]

    args << "--with-pgsql=#{Formula["postgresql"].opt_prefix}" if build.with? "postgresql"
    args << "--with-mysql=#{Formula["mysql"].opt_prefix}" if build.with? "mysql"
    args << "--with-freetds=#{Formula["freetds"].opt_prefix}" if build.with? "freetds"
    args << "--with-odbc=#{Formula["unixodbc"].opt_prefix}" if build.with? "unixodbc"

    if build.with? "openldap"
      args << "--with-ldap"
      args << "--with-ldap-lib=#{Formula["openldap"].opt_lib}"
      args << "--with-ldap-include=#{Formula["openldap"].opt_include}"
    end

    if build.with? "openssl@1.1"
      args << "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
      system "autoreconf", "-fiv"
    else
      args << "--with-openssl=#{Formula["openssl"].opt_prefix}"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # No need for this to point to the versioned path.
    inreplace libexec/"bin/apu-1-config", libexec, opt_libexec
  end

  test do
    assert_match opt_libexec.to_s, shell_output("#{bin}/apu-1-config --prefix")
  end
end
