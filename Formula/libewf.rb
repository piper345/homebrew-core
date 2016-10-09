class Libewf < Formula
  desc "Library for support of the Expert Witness Compression Format"
  homepage "https://github.com/libyal/libewf"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libe/libewf/libewf_20140608.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libe/libewf/libewf_20140608.orig.tar.gz"
  version "20140608"
  sha256 "d14030ce6122727935fbd676d0876808da1e112721f3cb108564a4d9bf73da71"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "c6b408459c31d2dba3b891a1f581edbb2199ad184b845c27cdb143708e3d2d2f" => :el_capitan
    sha256 "61d33dfa9e389012a784ec6dd8f5704827539d8502719c13319b9b3835d41f8e" => :yosemite
    sha256 "8acaab1187c45a9bd493b1f49579c8d813ce2978ccff2d85161b3561346e0b13" => :mavericks
    sha256 "69b9412398fd45616d47b132dca1ee158bf5f05655f9875ba9592c5e6e639817" => :mountain_lion
  end

  devel do
    url "https://github.com/libyal/libewf/releases/download/20160424/libewf-experimental-20160424.tar.gz"
    sha256 "613467112f52fe960ce0121dd1ade8eb7887d3fcfc761aa728d2f1aa9f135116"
  end

  head do
    url "https://github.com/libyal/libewf.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    if build.head?
      system "./synclibs.sh"
      system "./autogen.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ewfinfo -V")
  end
end
