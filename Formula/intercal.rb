class Intercal < Formula
  desc "Esoteric, parody programming language"
  homepage "http://catb.org/~esr/intercal/"
  url "http://catb.org/~esr/intercal/intercal-0.30.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/i/intercal/intercal_0.30.orig.tar.gz"
  sha256 "b38b62a61a3cb5b0d3ce9f2d09c97bd74796979d532615073025a7fff6be1715"
  revision 1

  bottle do
    sha256 "af6d1cf8f71f0e2f820654511250d3691784eb5de0d5806674cb6c493e2fd71a" => :el_capitan
    sha256 "a3d94e36e6d2c3f5d8e8ba26ba5c9469801dd25ddd451f672904ffdc0a84d0ce" => :yosemite
    sha256 "26117079d6c5f42fc59e9f0c590ef5e8c94ab32abb606fd21b48dd307c5a1ca9" => :mavericks
    sha256 "11bef1430a773dcf00a205badaadbf60166bc31a241fdc826b9fd4002638c0ae" => :mountain_lion
  end

  head do
    url "git://thyrsus.com/repositories/intercal.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    if build.head?
      cd "buildaux" do
        system "./regenerate-build-system.sh"
      end
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    (etc/"intercal").install Dir["etc/*"]
    pkgshare.install "pit"
  end

  test do
    (testpath/"lib").mkpath
    (testpath/"test").mkpath
    cp pkgshare/"pit/beer.i", "test"
    cd "test" do
      system bin/"ick", "beer.i"
      system "./beer"
    end
  end
end
