class Plzip < Formula
  desc "Data compressor"
  homepage "http://www.nongnu.org/lzip/plzip.html"
  url "http://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.5.tar.lz"
  sha256 "0e2e8644b0ec2c4319d0fab470eeb1bc41f36bdd612882beec332149a7aa564b"

  bottle do
    cellar :any_skip_relocation
    sha256 "23e72d690f7e1984510c109a1076450df7604d012253c32d4cb028204d5455eb" => :el_capitan
    sha256 "d6034ff78f2a1e85f7794450bdd06bc95b1a07e30ee99c1227bf642d5be09ad4" => :yosemite
    sha256 "8cd3d1ac2c5b8c04a172188efdbc89dd1a7cfe936057d047d728484691e67adb" => :mavericks
    sha256 "7e8f6bbcb52876b808fc247a46e9f189b1e8a04f829717dc27979d1393f7a15a" => :mountain_lion
  end

  depends_on "lzlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    text = "Hello Homebrew!"
    compressed = pipe_output("#{bin}/plzip -c", text)
    assert_equal text, pipe_output("#{bin}/plzip -d", compressed)
  end
end
