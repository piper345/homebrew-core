class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command line"
  homepage "http://nfdump.sourceforge.net"
  url "https://downloads.sourceforge.net/project/nfdump/stable/nfdump-1.6.13/nfdump-1.6.13.tar.gz"
  sha256 "251533c316c9fe595312f477cdb051e9c667517f49fb7ac5b432495730e45693"

  bottle do
    cellar :any_skip_relocation
    sha256 "4dabc32a43c7b2aef457e9f64f822a9a4f5ac1b816a97151824e7c961bd27975" => :el_capitan
    sha256 "2e0585426172efc2d436e3ab80574cbf048cfbcd7e9a5ca1fc072d90f763d748" => :yosemite
    sha256 "d0b6f686b1f95dda13cb282e818b288f29fd30bebfb1b8797093d707348d627f" => :mavericks
    sha256 "5bbd8ec9a51cde3c6ed0aaeb1b77a4f2ba59bea99d5304fa1415a7e2e0d5280b" => :mountain_lion
  end

  option "with-readpcap", "Enable reading netflow packets from pcap_file instead of network"

  def install
    args = %W[--prefix=#{prefix}]

    args << "--enable-readpcap" if build.with? "readpcap"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/nfdump", "-Z 'host 8.8.8.8'"
  end
end
