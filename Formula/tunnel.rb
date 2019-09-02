class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.4.2.tar.gz"
  sha256 "3e29a4dac694e871bdbb852ccdad3d70dd3d09e050ae7e17aef90794eed029cf"

  bottle do
    cellar :any_skip_relocation
    sha256 "81b8c2c231b0cd3a06f836e4fba62e6e8341e7448431651290edceefb7d303fd" => :mojave
    sha256 "9634b95dc5f24f376578a55e840ad1649b2618991e13de3d9d4a8bb71c7fdc5e" => :high_sierra
    sha256 "0c3c314358b83b398433665eab7cdc05e11b4fc74c183fd2b9461c70f551f666" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tunnel", "./cmd/tunnel"
    prefix.install_metafiles
  end

  test do
    system bin/"tunnel", "ping"
  end
end
