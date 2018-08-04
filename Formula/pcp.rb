class Pcp < Formula
  desc "Performance Co-Pilot is a system performance and analysis framework"
  homepage "https://pcp.io/"
  url "https://dl.bintray.com/pcp/source/pcp-4.1.1.src.tar.gz"
  sha256 "430c3ce05db5e475dc0d962ac584a61a91c69b791e66d5cc684a7aada3e21f52"
  depends_on "pkg-config" => :build
  depends_on "nss"
  depends_on "python"
  depends_on "qt"
  depends_on "readline"
  depends_on "xz"

  def install
    system "./configure", "--prefix=#{prefix}", "CC=clang", "CXX=clang", "--without-manager"
    system "make", "install"
    ln_sf "/usr/local/Cellar/pcp/4.1.1/etc/pcp.env", "/etc/pcp.env"
    ln_sf "/usr/local/Cellar/pcp/4.1.1/etc/pcp.conf", "/etc/pcp.conf"
  end

  test do
    system "#{bin}/pcp", "--version"
  end
end
