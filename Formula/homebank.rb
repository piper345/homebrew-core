class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.0.9.tar.gz"
  sha256 "d0bc763e94da0cba544495b07070e79faecf1d5de0cfb092d126482525e062b7"

  bottle do
    sha256 "e1ec320fac03c45443d853d0d6b360bee7429a43d3497526618de125724d2b93" => :el_capitan
    sha256 "1586a2f0586da8686fa2d7e550f3bb472c2c0db805f5e24b588e39aa1cd06742" => :yosemite
    sha256 "888a7385dbcd2a53c4df9db772b8d132024a76dba15c5f134b31e36e0b4d693e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "gnome-icon-theme"
  depends_on "hicolor-icon-theme"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "libofx" => :optional
  depends_on "atk" => :linked
  depends_on "cairo" => :linked
  depends_on "gdk-pixbuf" => :linked
  depends_on "glib" => :linked
  depends_on "pango" => :linked

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--with-ofx" if build.with? "libofx"

    system "./configure", *args
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    system "#{bin}/homebank", "--version"
  end
end
