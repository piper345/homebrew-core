class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/axel-download-accelerator/axel/archive/v2.14.tar.gz"
  sha256 "a2bf0859380347bcfbdec1d34322f609f0b883e107d3bf5c06001bcc6a8136ad"
  head "https://github.com/eribertomota/axel.git"

  bottle do
    sha256 "fb06640f70ea6f9dfc3d5935596126f6d3031e25a90afcb246af0665bff0ad54" => :sierra
    sha256 "11c8764fddbb32606433c89962526093f8190a7c164f8400a019e62b88e32d58" => :el_capitan
    sha256 "171fa4afa09b33cce375c8bdcd45e929be1aff234ec15e48ba2dcfad314f9a43" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "openssl"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert File.exist?("axel.tar.gz")
  end
end
