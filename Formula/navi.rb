class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.0.0.tar.gz"
  sha256 "458493f1b50d0a5d8fffcc8656a1faedac51e23eb5f6cf86a0878ef9d6f2512d"

  bottle do
    cellar :any_skip_relocation
    sha256 "64b6dac7d4c689ab6aa5c88ef58369249af2d9a6ac44f56769685569a673dd56" => :catalina
    sha256 "64b6dac7d4c689ab6aa5c88ef58369249af2d9a6ac44f56769685569a673dd56" => :mojave
    sha256 "64b6dac7d4c689ab6aa5c88ef58369249af2d9a6ac44f56769685569a673dd56" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "fzf"

  def install
    libexec.install Dir["cheats/*"]
    libexec.install Dir["shell/*"]
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")
  end
end
