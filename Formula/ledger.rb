class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "http://ledger-cli.org"
  url "https://github.com/ledger/ledger/archive/v3.1.1.tar.gz"
  sha256 "90f06561ab692b192d46d67bc106158da9c6c6813cc3848b503243a9dfd8548a"
  revision 3

  head "https://github.com/ledger/ledger.git"

  bottle do
    sha256 "d1107fdd36bb83f7aed5b1a586a039d40598226004c78ac271bb8f798a720931" => :sierra
    sha256 "620979f59497e45493a966d4d6b9a9f6187590972e7c80700552fa1dfbd40fa2" => :el_capitan
    sha256 "2863f25ee92fd832529c080ee5d4953618079a38a8ef059eab4b49f0ed0dfa07" => :yosemite
  end

  deprecated_option "debug" => "with-debug"

  option "with-debug", "Build with debugging symbols enabled"
  option "with-docs", "Build HTML documentation"
  option "without-python", "Build without python support"

  depends_on "cmake" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  boost_opts = []
  boost_opts << "c++11" if MacOS.version < "10.9"
  depends_on "boost@1.61" => boost_opts
  depends_on "boost-python" => boost_opts if build.with? "python"

  needs :cxx11

  def install
    ENV.cxx11

    flavor = (build.with? "debug") ? "debug" : "opt"

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{Formula["boost"].opt_prefix}
    ]
    args << "--python" if build.with? "python"
    args += %w[-- -DBUILD_DOCS=1]
    args << "-DBUILD_WEB_DOCS=1" if build.with? "docs"
    system "./acprep", flavor, "make", *args
    system "./acprep", flavor, "make", "doc", *args
    system "./acprep", flavor, "make", "install", *args

    (pkgshare/"examples").install Dir["test/input/*.dat"]
    pkgshare.install "contrib"
    pkgshare.install "python/demo.py" if build.with? "python"
    elisp.install Dir["lisp/*.el", "lisp/*.elc"]
  end

  test do
    balance = testpath/"output"
    system bin/"ledger",
      "--args-only",
      "--file", "#{pkgshare}/examples/sample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
    assert_equal 0, $?.exitstatus

    system "python", pkgshare/"demo.py" if build.with? "python"
  end
end
