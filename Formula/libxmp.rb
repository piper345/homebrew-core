class Libxmp < Formula
  desc "C library for playback of module music (MOD, S3M, IT, etc)"
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.4.0/libxmp-4.4.0.tar.gz"
  sha256 "1488dd953fd30384fb946745111824ad14a5c2ed82d76af671ac9cd733ac5c82"

  bottle do
    cellar :any
    sha256 "191951654a31f81bfb55c8d71d8cd195fc379e433e824f6b9ce629a0dcb152a5" => :el_capitan
    sha256 "352f3989d9c9250f710c112d884cd1e37b2096296f279b1f0f0f025978026638" => :yosemite
    sha256 "8360a1b990f75a1d34525c2694517754167a36bb20577c22f7fdae36939b87f3" => :mavericks
  end

  head do
    url "git://git.code.sf.net/p/xmp/libxmp"
    depends_on "autoconf" => :build
  end

  # CC BY-NC-ND licensed set of five mods by Keith Baylis/Vim! for testing purposes
  # Mods from Mod Soul Brother: https://web.archive.org/web/20120215215707/http://www.mono211.com/modsoulbrother/vim.html
  resource "demo_mods" do
    url "https://files.scene.org/get:us-http/mirrors/modsoulbrother/vim/vim-best-of.zip"
    sha256 "df8fca29ba116b10485ad4908cea518e0f688850b2117b75355ed1f1db31f580"
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install resource("demo_mods")
  end

  test do
    (testpath/"libxmp_test.c").write <<-EOS.undent
      #include <stdio.h>
      #include "xmp.h"
      int main() {
          xmp_context context;
          struct xmp_module_info mi;
          context = xmp_create_context();
          if (xmp_load_module(context, "#{pkgshare}/give-me-an-om.mod") != 0)
              return 1;
          xmp_get_module_info(context, &mi);
          printf("%s", mi.mod->name);
      }
    EOS
    system ENV.cc, "libxmp_test.c", "-L#{lib}", "-lxmp", "-o", "libxmp_test"
    assert_equal "give me an om", shell_output("./libxmp_test")
  end
end
