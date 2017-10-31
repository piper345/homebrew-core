class Ftgl < Formula
  desc "Freetype / OpenGL bridge"
  homepage "https://sourceforge.net/projects/ftgl/"
  url "https://downloads.sourceforge.net/project/ftgl/FTGL%20Source/2.1.3~rc5/ftgl-2.1.3-rc5.tar.gz"
  sha256 "5458d62122454869572d39f8aa85745fc05d5518001bcefa63bd6cbb8d26565b"
  revision 1

  bottle do
    cellar :any
    sha256 "f6da52f5e9f06f984aad457058876e88b5b7053288f40c87a17d7d5749936cd6" => :high_sierra
    sha256 "946a9530f7eae5c8f2bc71dfc91b3a8138ae2228cd441fd7cf39f047b957ce47" => :sierra
    sha256 "6462eb0b97ab120639f1a191f6e3a39419bbb813abd71f5c741303dbf0aed7fb" => :el_capitan
    sha256 "26db05485600adfb7ead23d04fae9b1ee1d1a4b7ac304e1453ad83b4b2c39f64" => :yosemite
    sha256 "50a41f3c95a363b52bc367abf4b5b9dc272d71c8b35fe8e63f058c7cf7162225" => :mavericks
  end

  option "with-freeglut", "Builud with freeglut instead of GLUT.frameworks"

  depends_on "freetype"
  depends_on "freeglut" => :optional

  def install
    # If doxygen is installed, the docs may still fail to build.
    # So we disable building docs.
    inreplace "configure", "set dummy doxygen;", "set dummy no_doxygen;"

    args = ["--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}", "--disable-freetypetest"]

    if build.with?("freeglut")
      args << "--with-glut-inc=#{Formula["freeglut"].opt_include}" << "--with-glut-lib=#{Formula["freeglut"].opt_lib}"
    else
      args << "--with-glut-lib=-frameworks GLUT"
    end

    system "./configure", *args
    inreplace "demo/Makefile", "$(FT2_LIBS) $(GLUT_LIBS)", "$(FT2_LIBS) $(GL_LIBS) $(GLUT_LIBS)"
    system "make", "install"
  end
end
