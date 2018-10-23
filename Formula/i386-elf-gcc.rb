class I386ElfGcc < Formula
  desc "The GNU compiler collection for i386-elf"
  homepage "https://gcc.gnu.org"
  url "https://mirrors.nju.edu.cn/gnu/gcc/gcc-8.2.0/gcc-8.2.0.tar.xz"
  sha256 "196c3c04ba2613f893283977e6011b2345d1cd1af9abeac58e916b1aab3e0080"
  depends_on "gmp"
  depends_on "i386-elf-binutils"
  depends_on "libmpc"
  depends_on "mpfr"
  def install
    mkdir "i386-elfgcc-build" do
      system "../configure", "--target=i386-elf",
                             "--prefix=#{prefix}",
                             "--without-isl",
                             "--disable-multilib",
                             "--disable-nls",
                             "--disable-werror",
                             "--without-headers",
                             "--enable-languages=c, c++"
      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"
      binutils = Formulary.factory "i386-elf-binutils"
      ln_sf binutils.prefix/"i386-elf", prefix/"i386-elf"
    end
  end
  test do
    (testpath/"test-c.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/i386-elf-gcc", "-E", "-o", "test-c.i", "test-c.c"
    assert_not_empty "test-c.i"
  end
end
