class LedgerAT26 < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v2.6.3.tar.gz"
  sha256 "d5c244343f054c413b129f14e7020b731f43afb8bdf92c6bdb702a17a2e2aa3a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6e95d470e579f63b316aa4df339df2afe8f89f58dedf9929bd6f27a27232bad2" => :high_sierra
    sha256 "06d09633c95ba8687f4261de21aa094631c996f5ecf4bc86e723b28b23604d40" => :sierra
    sha256 "ab1f08b793ca7f16c3c83084f028c1eed1e4e2e69086c0749caf1237f19993cd" => :el_capitan
  end

  keg_only :versioned_formula

  option "with-debug", "Build with debugging symbols enabled"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "gettext"
  depends_on "pcre"
  depends_on "boost"
  depends_on "gmp"
  depends_on "libofx" => :optional
  depends_on :python => :optional

  deprecated_option "debug" => "with-debug"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-lispdir=#{elisp}
    ]

    if build.with? "libofx"
      args << "--enable-ofx"
      # the libofx.h appears to have moved to a subdirectory
      ENV.append "CXXFLAGS", "-I#{Formula["libofx"].opt_include}/libofx"
    end

    args << "--enable-python" if build.with? "python"
    args << "--enable-debug" if build.with? "debug"

    system "./autogen.sh"
    system "./configure", *args
    system "make"

    ENV.deparallelize
    system "make", "install"
    (share+"ledger/examples").install "sample.dat", "scripts"
  end

  test do
    balance = testpath/"output"
    system bin/"ledger",
      "--file", share/"ledger/examples/sample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
    assert_equal 0, $CHILD_STATUS.exitstatus

    system "python", "#{share}/ledger/demo.py" if build.with? "python"
  end
end
