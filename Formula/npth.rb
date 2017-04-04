class Npth < Formula
  desc "New GNU portable threads library"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/npth/npth-1.3.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/npth/npth-1.3.tar.bz2"
  sha256 "bca81940436aed0734eb8d0ff8b179e04cc8c087f5625204419f5f45d736a82a"

  bottle do
    cellar :any
    sha256 "e7ea90bcf31139dbdbbb496039d19f733a27296a99a968bd2decd9e5500c8eb4" => :sierra
    sha256 "e0383072b47031a5ca5b129447fe7b0d90a161c78c0dcd91f3d398067262d469" => :el_capitan
    sha256 "ed46e1fed9a33a4961b32fe2de844d8bbeff8f44d4863a3f2da364bb292ffa59" => :yosemite
    sha256 "cc6148b47d88580a4d18efc4140ea423189333c564e11c61b8a4764a182ac766" => :mavericks
    sha256 "277c3d694bda25fa805241d6c6799aaede32bf56393e7f0912a0e1e05940a4e5" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/npth-config", "--version"
  end
end
