class Sd < Formula
  desc "Intuitive find & replace CLI"
  homepage "https://github.com/chmln/sd"
  url "https://github.com/chmln/sd/archive/v0.7.2.tar.gz"
  sha256 "8efd38c7641f94f0cf83f04ac4e6033c1794b93dbfdaca893c3403801afe7cc2"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bdd3186fb20a398f02a3d2b9dee49e7f60f91e9566cddfc81be0ba4ce72fff2a" => :catalina
    sha256 "29f6491b5f39d63482793ac52f703ed037c8f0759c9d18c5585ebdf3cab711bd" => :mojave
    sha256 "0beab832bb7d2570a61d7c01033de8d47c3543e98d1b3fe20dead77ef5f28f7d" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "after", pipe_output("#{bin}/sd before after", "before")
  end
end
