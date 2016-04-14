class Zzuf < Formula
  desc "Transparent application input fuzzer"
  homepage "http://caca.zoy.org/wiki/zzuf"
  sha256 "0842c548522028c3e0d9c9cf7d09f6320b661f33824bb6df19ca209851bdf627"
  revision 1

  stable do
    url "https://github.com/samhocevar/zzuf/releases/download/v0.14/zzuf-0.14.tar.gz"
    sha256 "291b41d53ae6df75d0d2b4a0faa333adfc4a02b9ca8706bee47ef7be657966ce"
    # Fix missing semi-colon so compile succeeds
    patch do
      url "https://github.com/x9prototype/zzuf/pull/1.patch"
      sha256 "b312b949ab773ad531880f5f3484e1163910711301f5dba397440f84bffb2ac8"
    end
    # libasan so just disable it https://github.com/samhocevar/zzuf/issues/5
    patch :DATA
  end
  bottle do
    sha256 "1a2dddf14f76e969617af40f94219c3c85027e788ddae03a541566ec4360914c" => :el_capitan
    sha256 "f716bc48c5f845f3fdbfd39f5d90bb228d6b33655d6989dccc3cff2afb5b0688" => :yosemite
    sha256 "16fc2c23e89bb59f90c5335ede797135dc52924640a8083b3cd5b435be787cd8" => :mavericks
  end


  head do
    url "https://github.com/samhocevar/zzuf.git"

    depends_on "autoconf"   => :build
    depends_on "automake"   => :build
    depends_on "libtool"    => :build
    depends_on "pkg-config" => :build
  end

  conflicts_with "libzzip", :because => "both install `zzcat` binaries"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/zzuf", "hd", "-vn", "32", "/dev/zero"
  end
end

__END__
diff --git a/src/libzzuf/sys.c b/src/libzzuf/sys.c
index 93f941e..1cc4109 100644
--- a/src/libzzuf/sys.c
+++ b/src/libzzuf/sys.c
@@ -51,7 +51,7 @@ void *_zz_dl_lib = RTLD_NEXT;
 static void insert_funcs(void);
 #endif

-#if __GNUC__ || __clang__
+#if HAVE_DLFCN_H && HAVE_DLADDR && !__APPLE__ && (__GNUC__ || __clang__)
 extern void __asan_init_v3(void) __attribute__((weak));
 #endif

@@ -61,13 +61,13 @@ void _zz_sys_init(void)

     insert_funcs();

-#elif defined HAVE_DLFCN_H
+#elif HAVE_DLFCN_H && !__APPLE__
     /* If glibc is recent enough, we use dladdr() to get its address. This
      * way we are sure that the symbols we load are the most recent version,
      * or we may get weird problems. We choose fileno as a random symbol to
      * get, because we know we don't divert it. */

-#   if __GNUC__ || __clang__
+#if HAVE_DLADDR && (__GNUC__ || __clang__)
     /* XXX: for some reason we conflict with libasan. We would like to avoid
      * RTLD_NEXT because it causes problems with versioned symbols. However,
      * if we do that, libasan enters infinite recursion. So we just disable
diff --git a/test/bug-mmap.c b/test/bug-mmap.c
index af371dc..7e07af0 100644
--- a/test/bug-mmap.c
+++ b/test/bug-mmap.c
@@ -32,7 +32,7 @@

 int main(void)
 {
-#if defined _SC_PAGE_SIZE
+#if defined _SC_PAGE_SIZE && defined MAP_POPULATE
     int fd = open("/etc/hosts", O_RDONLY);
     mmap(0, sysconf(_SC_PAGE_SIZE) * 2, PROT_READ,
          MAP_PRIVATE | MAP_POPULATE, fd, 0);
