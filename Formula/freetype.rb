class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.8.1/freetype-2.8.1.tar.bz2"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.8.1.tar.bz2"
  sha256 "e5435f02e02d2b87bb8e4efdcaa14b1f78c9cf3ab1ed80f94b6382fb6acc7d78"

  bottle do
    cellar :any
    sha256 "a967a0764efb895a4342ab158174f4dd1f12b1ee6475c44ff2c965cb84ab0e43" => :high_sierra
    sha256 "f22537dd3f8b5638a712c7a6231f0b57359c4adef0557b6e90b92e11d930640f" => :sierra
    sha256 "0a83ce9cb40656fd438a5475a09331c4bcc9a0e771af0d6049f002d14f02f576" => :el_capitan
    sha256 "37d29dac299114d75abfcc1a75c6e10e1ce602072da732298a2a64438a3cedc3" => :yosemite
  end

  keg_only :provided_pre_mountain_lion

  option "without-subpixel", "Disable sub-pixel rendering (a.k.a. LCD rendering, or ClearType)"

  depends_on "libpng"

  def install
    if build.with? "subpixel"
      inreplace "include/freetype/config/ftoption.h",
          "/* #define FT_CONFIG_OPTION_SUBPIXEL_RENDERING */",
          "#define FT_CONFIG_OPTION_SUBPIXEL_RENDERING"
    end

    system "./configure", "--prefix=#{prefix}", "--without-harfbuzz"
    system "make"
    system "make", "install"

    inreplace [bin/"freetype-config", lib/"pkgconfig/freetype2.pc"],
      prefix, opt_prefix
  end

  test do
    system bin/"freetype-config", "--cflags", "--libs", "--ftversion",
                                  "--exec-prefix", "--prefix"
  end
end
