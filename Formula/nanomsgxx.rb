class Nanomsgxx < Formula
  desc "Nanomsg binding for C++11"
  homepage "https://achille-roussel.github.io/nanomsgxx/doc/nanomsgxx.7.html"
  url "https://github.com/achille-roussel/nanomsgxx/archive/0.2.tar.gz"
  sha256 "116ad531b512d60ea75ef21f55fd9d31c00b172775548958e5e7d4edaeeedbaa"

  bottle do
    cellar :any
    sha256 "3b2fbdcef36e70978e0f36ee9dc17e9ea1fa00ec22f6816826e56d9774233fd5" => :sierra
    sha256 "c9d34cc7c7778a37ae44131402ddcf254cce8ab90833f9e8c142a1cf6d0ef399" => :el_capitan
    sha256 "e292690ef06a13951596aa574b2690269d8dac6d77f795390b29f4be7ccde972" => :yosemite
  end

  option "with-debug", "Compile with debug symbols"

  depends_on "pkg-config" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard

  if build.with? "debug"
    depends_on "nanomsg" => "with-debug"
  else
    depends_on "nanomsg"
  end

  def install
    args = %W[
      --static
      --shared
      --prefix=#{prefix}
    ]

    args << "--debug" if build.with? "debug"

    system "python", "./waf", "configure", *args
    system "python", "./waf", "build"
    system "python", "./waf", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      int main(int argc, char **argv) {
        std::cout << "Hello Nanomsgxx!" << std::endl;
      }
    EOS

    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lnnxx", "test.cpp"

    assert_equal "Hello Nanomsgxx!\n", shell_output("#{testpath}/a.out")
  end
end
