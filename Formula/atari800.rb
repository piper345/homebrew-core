class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.github.io/"
  url "https://github.com/atari800/atari800/releases/download/ATARI800_4_2_0/atari800-4.2.0-src.tgz"
  sha256 "55cb5568229c415f1782130afd11df88c03bb6d81fa4aa60a4ac8a2f151f1359"

  bottle do
    cellar :any
    sha256 "d0dd5b6efe4714710e45e1d5954f4c29f2f41b778be76f67b965cb026e1a0019" => :catalina
    sha256 "b1d72401236140046396fb54e035816c5cc2ecc0883209cb3a7013b012c0c24f" => :mojave
    sha256 "ea68b68de889ad359bb747f5126f40bf1eb3238abd18d3fcd5c17fe571afbdb9" => :high_sierra
    sha256 "f055eb7567d37deb8b07ceaf7079fb73fca3e7c0ca0e703a5833cf76e1d8f8cb" => :sierra
  end

  depends_on "libpng"
  depends_on "sdl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-sdltest",
                          "--disable-riodevice"
    system "make", "install"
  end

  test do
    assert_equal "Atari 800 Emulator, Version #{version}",
                 shell_output("#{bin}/atari800 -v", 3).strip
  end
end
