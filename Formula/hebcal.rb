class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.16.tar.gz"
  sha256 "78c212f34b4aaf3f683b0c961d9d9f0a42bdd5666dece58f9029e3908c2f1c0f"

  bottle do
    cellar :any_skip_relocation
    sha256 "cecca73f00edd516755b430ada05ad5f640055deb09506ba2bf3db445d7f5c47" => :mojave
    sha256 "e7aadcef74ea7d159f778e9a9c5026f7cdaa2657719b46b14ef15c9bdac48385" => :high_sierra
    sha256 "91b330b5ce221fd20325d86130415505b5660649f787d1c7fbbb12d080c5a505" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    system "#{bin}/hebcal"
  end
end
