class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.54/glibmm-2.54.1.tar.xz"
  sha256 "7cc28c732b04d70ed34f0c923543129083cfb90580ea4a2b4be5b38802bf6a4a"

  bottle do
    cellar :any
    sha256 "c2aea4a4b8a1523f37ac33084e7cd1628197456c0f0ed29eb3e2a34e7d827a0a" => :high_sierra
    sha256 "dea843cb8f9ee9b9345bd71571eb96fb8a84ed91e296a3792753bbbe7b5affdf" => :sierra
    sha256 "f4ae5ec159874f0b8cb1293b63d62703c24fcaa443ecdddfdf65b277d4c075d5" => :el_capitan
    sha256 "5ba4d3b82f35ab7bffe3d8bb392151073fad6d8561ba3fe893f626174726777b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libsigc++"
  depends_on "glib"

  needs :cxx11

  def install
    ENV.cxx11

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libsigcxx = Formula["libsigc++"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/glibmm-2.4
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/glibmm-2.4/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lintl
      -lsigc-2.0
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
