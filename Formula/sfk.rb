class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.8.8/sfk-1.8.8.tar.gz"
  sha256 "b139998e3aca294fe74ad2a6f0527e81cbd11eddfb5e8a81f6067a79d26c97ed"

  bottle do
    cellar :any_skip_relocation
    sha256 "488668e8facb4c96ef56bb43a9a89c8dbd02e832625be5f0bb6a50cbf087ac42" => :sierra
    sha256 "4bb2ac089b26993d8fd7f6118cf15805945d141977152db4b696d543d526ae3f" => :el_capitan
    sha256 "93ac8468fd3211682b1bb92bc28fcad631a22beeeb58f1ec86a2d7816b57932a" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
