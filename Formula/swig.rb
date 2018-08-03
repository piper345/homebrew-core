class Swig < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "http://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-3.0.12/swig-3.0.12.tar.gz"
  sha256 "7cf9f447ae7ed1c51722efc45e7f14418d15d7a1e143ac9f09a668999f4fc94d"

  bottle do
    rebuild 1
    sha256 "ca4ce8c94126c18c19fe278f9467a14aeb46bf1ab890084265a4607a8a07aa80" => :high_sierra
    sha256 "e87cdc5e57b5569683be22ff458fdaf0a6afb9da457e437a0579c8c6dd5d44c6" => :sierra
    sha256 "9adb2f46560253937f493bc40b2adb9047af322a4a090ee1edaea72ae24805f3" => :el_capitan
  end

  head do
    url "https://github.com/swig/swig.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "pcre"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int add(int x, int y)
      {
        return x + y;
      }
    EOS
    (testpath/"test.i").write <<~EOS
      %module test
      %inline %{
      extern int add(int x, int y);
      %}
    EOS
    (testpath/"run.rb").write <<~EOS
      require "./test"
      puts Test.add(1, 1)
    EOS
    system "#{bin}/swig", "-ruby", "test.i"
    system ENV.cc, "-c", "test.c"
    system ENV.cc, "-c", "test_wrap.c", "-I/System/Library/Frameworks/Ruby.framework/Headers/"
    system ENV.cc, "-bundle", "-undefined", "dynamic_lookup", "test.o", "test_wrap.o", "-o", "test.bundle"
    assert_equal "2", shell_output("/usr/bin/ruby run.rb").strip
  end
end
