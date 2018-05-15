class Libhid < Formula
  desc "Library to access and interact with USB HID devices"
  homepage "https://libhid.alioth.debian.org/"
  url "http://distcache.freebsd.org/ports-distfiles/libhid-0.2.16.tar.gz"
  sha256 "f6809ab3b9c907cbb05ceba9ee6ca23a705f85fd71588518e14b3a7d9f2550e5"

  bottle do
    cellar :any
    rebuild 2
    sha256 "28232187a59559b480e28ef69ba803fdbd50ae4157be86dcde577450c28faad7" => :high_sierra
    sha256 "84983dc8938bcc76d2340d6bece34cc088134c9f9d948158387f804c1f8a4a09" => :sierra
    sha256 "987fc9ab6f4dc0678f025ac53bf752817c62788113d1a24b20e45c2d970b523f" => :el_capitan
  end

  depends_on "libusb"
  depends_on "libusb-compat"

  # Fix compilation error on 10.9
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-swig"

    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <hid.h>
      int main(void) {
        hid_init();
        return hid_cleanup();
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lhid", "-o", "test"
    system "./test"
  end
end

__END__
--- libhid-0.2.16/src/Makefile.am.org	2014-01-02 19:20:33.000000000 +0200
+++ libhid-0.2.16/src/Makefile.am	2014-01-02 19:21:15.000000000 +0200
@@ -17,7 +17,7 @@ else
 if OS_DARWIN
 OS_SUPPORT_SOURCE = darwin.c
 AM_CFLAGS += -no-cpp-precomp
-AM_LDFLAGS += -lIOKit -framework "CoreFoundation"
+AM_LDFLAGS += -framework IOKit -framework "CoreFoundation"
 else
 OS_SUPPORT =
 endif
--- libhid-0.2.16/src/Makefile.in.org	2014-01-02 19:20:35.000000000 +0200
+++ libhid-0.2.16/src/Makefile.in	2014-01-02 19:21:24.000000000 +0200
@@ -39,7 +39,7 @@ POST_UNINSTALL = :
 build_triplet = @build@
 host_triplet = @host@
 @OS_BSD_FALSE@@OS_DARWIN_TRUE@@OS_LINUX_FALSE@@OS_SOLARIS_FALSE@am__append_1 = -no-cpp-precomp
-@OS_BSD_FALSE@@OS_DARWIN_TRUE@@OS_LINUX_FALSE@@OS_SOLARIS_FALSE@am__append_2 = -lIOKit -framework "CoreFoundation"
+@OS_BSD_FALSE@@OS_DARWIN_TRUE@@OS_LINUX_FALSE@@OS_SOLARIS_FALSE@am__append_2 = -framework IOKit -framework "CoreFoundation"
 bin_PROGRAMS = libhid-detach-device$(EXEEXT)
 subdir = src
 DIST_COMMON = $(include_HEADERS) $(srcdir)/Makefile.am \
