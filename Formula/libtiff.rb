class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://www.remotesensing.org/libtiff/"
  url "http://download.osgeo.org/libtiff/tiff-4.0.6.tar.gz"
  mirror "ftp://ftp.remotesensing.org/pub/libtiff/tiff-4.0.6.tar.gz"
  sha256 "4d57a50907b510e3049a4bba0d7888930fdfc16ce49f1bf693e5b6247370d68c"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "350164c2ff6eb04f79381171b813f46315bd6f3613a99af374f7652308a1def7" => :el_capitan
    sha256 "bc74f97be94af84f8c52f0795fe742b974aa52db84e145086401265fbdefcf2e" => :yosemite
    sha256 "df691be152a837f41013d21adcc0514881d9aa941697b9bb5e5b6bd839433a3a" => :mavericks
  end

  option :universal
  option :cxx11
  option "with-xz", "Include support for LZMA compression"

  depends_on "jpeg"
  depends_on "xz" => :optional

  # Backports of various security/potential security fixes from Debian.
  # Already applied upstream in CVS but no new release yet.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tiff/tiff_4.0.6-1.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/t/tiff/tiff_4.0.6-1.debian.tar.xz"
    sha256 "f663c483883b623a136c015d355626a7aedf790f2786d6c6a63e68b015e7c09d"
    apply "patches/01-CVE-2015-8665_and_CVE-2015-8683.patch",
          "patches/02-fix_potential_out-of-bound_writes_in_decode_functions.patch",
          "patches/03-fix_potential_out-of-bound_write_in_NeXTDecode.patch"
  end

  def install
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-x
      --with-jpeg-include-dir=#{Formula["jpeg"].opt_include}
      --with-jpeg-lib-dir=#{Formula["jpeg"].opt_lib}
    ]
    if build.with? "xz"
      args << "--with-lzma-include-dir=#{Formula["xz"].opt_include}"
      args << "--with-lzma-lib-dir=#{Formula["xz"].opt_lib}"
    else
      args << "--disable-lzma"
    end
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <tiffio.h>

      int main(int argc, char* argv[])
      {
        TIFF *out = TIFFOpen(argv[1], "w");
        TIFFSetField(out, TIFFTAG_IMAGEWIDTH, (uint32) 10);
        TIFFClose(out);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltiff", "-o", "test"
    system "./test", "test.tif"
    assert_match(/ImageWidth.*10/, shell_output("#{bin}/tiffdump test.tif"))
  end
end
