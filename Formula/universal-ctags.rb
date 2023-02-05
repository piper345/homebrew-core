class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230205.0.tar.gz"
  version "p6.0.20230205.0"
  sha256 "191da166bf6a90a4144a4882275d78d9c1bc85cc181cb42165299481abf1c06e"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "139045cf8cdd92e62f32262bf33348910d12a81629dec3929b41f4b26ac54ee4"
    sha256 cellar: :any,                 arm64_monterey: "992a5f119f65922d1a5289d54b0ce450054dd2929b74ac6b7c419cd0e1de9700"
    sha256 cellar: :any,                 arm64_big_sur:  "304b171f988847e247758d2bfdc3baba8d0a63c9902c2a8f420dbff92817660a"
    sha256 cellar: :any,                 ventura:        "12f1085fadd555ea58ae7405e7bc271e4214d8c9023eeb5b0ad0da804a29ddd3"
    sha256 cellar: :any,                 monterey:       "bf949c4dde975c9a3925db76c50dfcd057602dbdc6d65c6bec046994616b9b31"
    sha256 cellar: :any,                 big_sur:        "0ced241e8a3966fd8164ca9379be21027689f0e8ea16ed28ff7de2c9a70df568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70f930d75ac1299d9bd28a65220f33427ec0306bccda4844a1f51628551fd816"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libyaml"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "this formula installs the same executable as the ctags formula"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>

      void func()
      {
        printf("Hello World!");
      }

      int main()
      {
        func();
        return 0;
      }
    EOS
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end
