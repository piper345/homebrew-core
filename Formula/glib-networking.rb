class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://launchpad.net/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.48/glib-networking-2.48.0.tar.xz"
  sha256 "7a1f3312e757b97af94e2db8a1f14eb9cc018c983931ecdf3b0c54acece39024"

  bottle do
    cellar :any
    sha256 "663503d7baf668cc3ceb9f0cb40630331b91c637cf6f5913503b5bec2b7c1cfe" => :el_capitan
    sha256 "3075c91a20bb2badc95c7ac25eaf1805f88df65a32be34db44967e102ba72e3f" => :yosemite
    sha256 "b10a6c6c03e8dea3052eed597a0c5abeadbbfddc72158f80645e98adf6f71018" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gsettings-desktop-schemas"

  link_overwrite "lib/gio/modules"

  def install
    # Install files to `lib` instead of `HOMEBREW_PREFIX/lib`.
    inreplace "configure", "$($PKG_CONFIG --variable giomoduledir gio-2.0)", lib/"gio/modules"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-ca-certificates=#{etc}/openssl/cert.pem",
                          # Remove when p11-kit >= 0.20.7 builds on OSX
                          # see https://github.com/Homebrew/homebrew/issues/36323
                          # and https://bugs.freedesktop.org/show_bug.cgi?id=91602
                          "--without-pkcs11"
    system "make", "install"

    # Delete the cache, will regenerate it in post_install
    rm lib/"gio/modules/giomodule.cache"
  end

  def post_install
    system Formula["glib"].opt_bin/"gio-querymodules", HOMEBREW_PREFIX/"lib/gio/modules"
  end

  test do
    (testpath/"gtls-test.c").write <<-EOS.undent
      #include <gio/gio.h>
      int main (int argc, char *argv[])
      {
        if (g_tls_backend_supports_tls (g_tls_backend_get_default()))
          return 0;
        else
          return 1;
      }
    EOS

    # From `pkg-config --cflags --libs gio-2.0`
    flags = [
      "-D_REENTRANT",
      "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
      "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
      "-I#{HOMEBREW_PREFIX}/opt/gettext/include",
      "-L#{HOMEBREW_PREFIX}/lib",
      "-L#{HOMEBREW_PREFIX}/opt/gettext/lib",
      "-lgio-2.0", "-lgobject-2.0", "-lglib-2.0", "-lintl"
    ]

    system ENV.cc, "gtls-test.c", "-o", "gtls-test", *flags
    system "./gtls-test"
  end
end
