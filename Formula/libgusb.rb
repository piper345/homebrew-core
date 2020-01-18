class Libgusb < Formula
  desc "GObject wrappers for libusb1"
  homepage "https://github.com/hughsie/libgusb"
  url "https://people.freedesktop.org/~hughsient/releases/libgusb-0.3.2.tar.xz"
  sha256 "fda14755b96c5014d688e75f31b4262e8c65c29ce69642beb07da461d4a98e5e"

  bottle do
    sha256 "e4fc5e4836fe89261ee85ed5d35d5fc211b6a394e4a74e4a3c2cd6c04ecfdedf" => :catalina
    sha256 "dc50a7f2cda15ece3521a5cc6eff56abb1fccd346f5821ed87cc06f4022e05f5" => :mojave
    sha256 "09b8b3c1fc62d27b5505c18adc3556866e2221dd0e35216e8b5b0c10fcf0999f" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libusb"

  # The original usb.ids file can be found at http://www.linux-usb.org/usb.ids
  # It is updated over time and its checksum changes, we maintain a copy
  resource "usb.ids" do
    url "https://github.com/Homebrew/formula-patches/raw/7974b33541d9c284ebb98bdb04075e9ce462d0bd/libgusb/usb.ids"
    sha256 "1cdcceedf955feb8e3df72f41cb70e65691f979c5294127f040371756e617395"
  end

  def install
    (share/"hwdata/").install resource("usb.ids")
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Ddocs=false", "-Dusb_ids=#{share}/hwdata/usb.ids", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/gusbcmd", "-h"
    (testpath/"test.c").write <<~EOS
      #include <gusb.h>

      int main(int argc, char *argv[]) {
        GUsbContext *context = g_usb_context_new(NULL);
        g_assert_nonnull(context);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libusb = Formula["libusb"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{libusb.opt_include}/libusb-1.0
      -I#{include}/gusb-1
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libusb.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -lusb-1.0
      -lgusb
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
