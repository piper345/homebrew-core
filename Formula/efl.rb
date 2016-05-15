class Efl < Formula
  desc "Libraries for the Enlightenment window manager"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.14.2.tar.gz"
  sha256 "e5699d8183c1540fe45dddaf692254632f9131335e97a09cc313e866a150b42c"
  revision 2

  bottle do
    revision 1
    sha256 "9df8074eed73d609881428248b6b2f526b452b00a3ace10d075851d27b5da800" => :el_capitan
    sha256 "38b3823e2a61f2c7d9e80d8ab610ddfcfe78e8d60828437393a8c0cf96079472" => :yosemite
    sha256 "ebb1fbff2aae185f557fba2f8841f40944615f8f7e788ecc45a61a967349993b" => :mavericks
  end

  option "with-docs", "Install development libraries/headers and HTML docs"

  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "pkg-config" => :build
  depends_on :x11 => :optional
  depends_on "openssl"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "webp" => :optional
  depends_on "luajit"
  depends_on "fribidi"
  depends_on "giflib"
  depends_on "libtiff"
  depends_on "gstreamer"
  depends_on "gst-plugins-good"
  depends_on "dbus"
  depends_on "pulseaudio"
  depends_on "bullet"

  needs :cxx11

  def install
    ENV.cxx11
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--enable-cocoa",
            "--enable-i-really-know-what-i-am-doing-and-that-this-will-probably-break-things-and-i-will-fix-them-myself-and-send-patches-aba", # There's currently (1.14) no clean profile for Mac OS, so we need to force passing configure
            "--prefix=#{prefix}",
           ]
    args << "--with-x11=none" if build.without? "x11"

    system "./configure", *args
    system "make", "install"
    system "make", "install-doc" if build.with? "docs"
  end

  test do
    system "#{bin}/edje_cc", "-V"
  end
end
