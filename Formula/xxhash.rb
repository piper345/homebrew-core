class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/v0.7.3.tar.gz"
  sha256 "952ebbf5b11fbf59ae5d760a562d1e9112278f244340ad7714e8556cbe54f7f7"

  bottle do
    cellar :any
    sha256 "df3925a26d581a795c0460a21e649457a14512b6e3466848efdb19fea39b9ada" => :catalina
    sha256 "c297ef8402ba97f7888193d486a55e070310dc58cbbac7635c6ec625adab2402" => :mojave
    sha256 "baa0d6a0771c08bc5fd6e73b948b637468682cdb9d6e01095dc8eca976e9cd4d" => :high_sierra
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"leaflet.txt").write "No computer should be without one!"
    assert_match /^67bc7cc242ebc50a/, shell_output("#{bin}/xxhsum leaflet.txt")
  end
end
