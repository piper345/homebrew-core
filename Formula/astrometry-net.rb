class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://github.com/dstndstn/astrometry.net/releases/download/0.78/astrometry.net-0.78.tar.gz"
  sha256 "9eda1b6cab5269b0a0e5d610aec86866cb8b08fb8f56254dc12f1690d69bc649"
  revision 1

  bottle do
    cellar :any
    sha256 "e180e5050153333c06b4885a08b1306bbae4a8042b00bd8a25b0eac40d70744d" => :mojave
    sha256 "859a3cb7e79547c64226dc8209a68225d79424d33df245bd63bf1a3686382df7" => :high_sierra
    sha256 "54b84bafbee017699b6b702140f6e370219268fe963b07a366f3a648cc577d49" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "gsl"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "netpbm"
  depends_on "numpy"
  depends_on "python"
  depends_on "wcslib"

  resource "fitsio" do
    url "https://files.pythonhosted.org/packages/9c/cb/f52534b71f4d99916723af2994898904015b9a1bf0286a165182d0374bbf/fitsio-0.9.11.tar.gz"
    sha256 "a1196385ca7c42c93d9e53002d5ba574a8db452c3b53ef1189e2c150177d4266"
  end

  def install
    ENV["NETPBM_INC"] = "-I#{Formula["netpbm"].opt_include}/netpbm"
    ENV["NETPBM_LIB"] = "-L#{Formula["netpbm"].opt_lib} -lnetpbm"
    ENV["SYSTEM_GSL"] = "yes"
    ENV["PYTHON_SCRIPT"] = "#{libexec}/bin/python3"
    ENV["PYTHON"] = "python3"

    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    ENV["INSTALL_DIR"] = prefix
    xy = Language::Python.major_minor_version "python3"
    ENV["PY_BASE_INSTALL_DIR"] = "#{libexec}/lib/python#{xy}/site-packages/astrometry"

    system "make"
    system "make", "py"
    system "make", "install"

    # Work around for https://github.com/dstndstn/astrometry.net/issues/142
    # On the next release, remove the following two lines & add `ENV["PY_BASE_LINK_DIR"] = ...`
    rm "#{bin}/plotann.py"
    bin.install_symlink libexec/"lib/python#{xy}/site-packages/astrometry/blind/plotann.py"
  end

  test do
    system "#{bin}/build-astrometry-index", "-d", "3", "-o", "index-9918.fits",
                                            "-P", "18", "-S", "mag", "-B", "0.1",
                                            "-s", "0", "-r", "1", "-I", "9918", "-M",
                                            "-i", "#{prefix}/examples/tycho2-mag6.fits"
    (testpath/"99.cfg").write <<~EOS
      add_path .
      inparallel
      index index-9918.fits
    EOS
    system "#{bin}/solve-field", "--config", "99.cfg", "#{prefix}/examples/apod4.jpg",
                                 "--continue", "--dir", "."
    assert_predicate testpath/"apod4.solved", :exist?
    assert_predicate testpath/"apod4.wcs", :exist?
  end
end
