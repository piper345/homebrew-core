class Armor < Formula
  desc "Simple HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.1.1.tar.gz"
  sha256 "1772c99dd16cb4cc05c27f34382c33c5ff60aa0f4703ad25d7d6127f2d0b745d"
  head "https://github.com/labstack/armor.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    armorpath = buildpath/"src/github.com/labstack/armor"
    armorpath.install buildpath.children

    cd armorpath do
      system "go", "build", "-o", bin/"armor", "cmd/armor/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/armor -v")
  end
end
