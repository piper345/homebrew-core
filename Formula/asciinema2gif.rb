class Asciinema2gif < Formula
  desc "Generate animated GIFs from asciinema terminal recordings"
  homepage "https://github.com/tav/asciinema2gif"
  url "https://github.com/tav/asciinema2gif/archive/v0.4.1.tar.gz"
  sha256 "a5c78224235a3afb4011c990d5926ddc787d1970b47e7ab46df6fa6eff5d6d90"
  head "https://github.com/tav/asciinema2gif.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "26670adbfe2b8416f8fd82f93f56b8f0d4f38b4587f1e7f3f131d75e94eb1907" => :el_capitan
    sha256 "8ab3c567585c2e2a14a89c7e85dfaf76e4cc6ce102652bd94e603beacf4a427d" => :yosemite
    sha256 "f7d8dfbca402fbdb334a778bd94fb33cea1e432639b4e51280622baf9c3a1adb" => :mavericks
  end

  depends_on "gifsicle"
  depends_on "imagemagick"
  depends_on "phantomjs"

  def install
    (libexec/"bin").install %w[asciinema2gif render.js]
    bin.write_exec_script libexec/"bin/asciinema2gif"
  end

  test do
    system "#{bin}/asciinema2gif", "--help"
  end
end
