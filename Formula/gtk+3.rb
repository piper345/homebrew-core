class Gtkx3 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/3.24/gtk+-3.24.10.tar.xz"
  sha256 "35a8f107e2b90fda217f014c0c15cb20a6a66678f6fd7e36556d469372c01b03"
  revision 1

  bottle do
    sha256 "dc8c9676ce9cd2402af362425dd03d20c400058098d3f77d61420b4510d5d788" => :mojave
    sha256 "1ccb1e4e084b885eaf4421703851f8cd976f15ffb859b6411c14976057482d68" => :high_sierra
    sha256 "bf91ae621743ae3219fc3fad195a798252a8bc9b6346655ab7c483ee27d38f77" => :sierra
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gsettings-desktop-schemas"
  depends_on "hicolor-icon-theme"
  depends_on "libepoxy"
  depends_on "pango"

  # submitted upstream as https://gitlab.gnome.org/GNOME/gtk/merge_requests/983
  patch do
    url "https://gitlab.gnome.org/GNOME/gtk/commit/7331a764.diff"
    sha256 "0ae9d4c08938ff28f99a0b432337d5966dea4f98e91356af88ddce6de63dde79"
  end

  # submitted upstream as https://gitlab.gnome.org/GNOME/gtk/merge_requests/1004
  patch do
    url "https://gitlab.gnome.org/GNOME/gtk/commit/fdcd0ec0.diff"
    sha256 "9089a6dc047306eeb9162d532fb9f92b41aaa265040a3604457e99bd18a364be"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      -Dx11_backend=false
      -Dquartz_backend=true
      -Dgtk_doc=false
      -Dman=true
      -Dintrospection=true
    ]

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    # Prevent a conflict between this and Gtk+2
    mv bin/"gtk-update-icon-cache", bin/"gtk3-update-icon-cache"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system bin/"gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}
      -I#{include}/gtk-3.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
