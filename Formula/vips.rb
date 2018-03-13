class Vips < Formula
  desc "Image processing library"
  homepage "https://github.com/jcupitt/libvips"
  url "https://github.com/jcupitt/libvips/releases/download/v8.6.3/vips-8.6.3.tar.gz"
  sha256 "f85adbb9f5f0f66b34a40fd2d2e60d52f6e992831f54af706db446f582e10992"

  bottle do
    rebuild 1
    sha256 "90c710bf69be834a5837ca0b38d7cd5aa1d8ee57396ed4f4ef98af04d6cd5233" => :high_sierra
    sha256 "275cb4d11c7c30a0f058b15bead5aa2b69d48c6e21b2bc1da5865cd35ac50c9a" => :sierra
    sha256 "239363151ee7f8736346b018aecf08cafae60751c0f4c3e332e555ae8db36afe" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "jpeg"
  depends_on "libexif"
  depends_on "libgsf"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "orc"
  depends_on "pango"
  depends_on "pygobject3"
  depends_on "fftw" => :recommended
  depends_on "poppler" => :recommended
  depends_on "graphicsmagick" => :optional
  depends_on "imagemagick" => :optional
  depends_on "jpeg-turbo" => :optional
  depends_on "mozjpeg" => :optional
  depends_on "openexr" => :optional
  depends_on "openslide" => :optional
  depends_on "webp" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.with? "graphicsmagick"
      args << "--with-magick" << "--with-magickpackage=GraphicsMagick"
    end

    if build.with? "jpeg-turbo"
      ENV.prepend_path "PKG_CONFIG_PATH",
        Formula["jpeg-turbo"].opt_lib/"pkgconfig"
    end

    if build.with? "mozjpeg"
      ENV.prepend_path "PKG_CONFIG_PATH",
        Formula["mozjpeg"].opt_lib/"pkgconfig"
    end

    args << "--without-libwebp" if build.without? "webp"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/vips", "-l"
    cmd = "#{bin}/vipsheader -f width #{test_fixtures("test.png")}"
    assert_equal "8", shell_output(cmd).chomp
  end
end
