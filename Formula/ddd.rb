class Ddd < Formula
  desc "Graphical front-end for command-line debuggers"
  homepage "https://www.gnu.org/s/ddd/"
  url "https://ftp.gnu.org/gnu/ddd/ddd-3.3.12.tar.gz"
  mirror "https://ftpmirror.gnu.org/ddd/ddd-3.3.12.tar.gz"
  sha256 "3ad6cd67d7f4b1d6b2d38537261564a0d26aaed077bf25c51efc1474d0e8b65c"
  revision 1

  bottle do
    rebuild 1
    sha256 "daf048d07ff5784377a54cac9d141bc69aa517e18c6e492e0687ab63e8a1d6e5" => :el_capitan
  end

  depends_on "openmotif"
  depends_on :x11

  # Needed for OSX 10.9 DP6 build failure:
  # https://savannah.gnu.org/patch/?8178
  if MacOS.version >= :mavericks
    patch :p0 do
      url "https://savannah.gnu.org/patch/download.php?file_id=29114"
      sha256 "aaacae79ce27446ead3483123abef0f8222ebc13fd61627bfadad96016248af6"
    end
  end

  # https://savannah.gnu.org/bugs/?41997
  patch do
    url "https://savannah.gnu.org/patch/download.php?file_id=31132"
    sha256 "f3683f23c4b4ff89ba701660031d4b5ef27594076f6ef68814903ff3141f6714"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-builtin-app-defaults",
                          "--enable-builtin-manual",
                          "--prefix=#{prefix}"

    # From MacPorts: make will build the executable "ddd" and the X resource
    # file "Ddd" in the same directory, as HFS+ is case-insensitive by default
    # this will loosely FAIL
    system "make", "EXEEXT=exe"

    ENV.deparallelize
    system "make", "install", "EXEEXT=exe"
    mv bin/"dddexe", bin/"ddd"
  end

  test do
    output = shell_output("#{bin}/ddd --version")
    output.force_encoding("ASCII-8BIT") if output.respond_to?(:force_encoding)
    assert_match version.to_s, output
  end
end
