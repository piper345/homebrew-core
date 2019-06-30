class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.3.2.tar.gz"
  sha256 "f891c6cc6f651d0376fb7cde4cb402feaf2ecd59a78d7bfbf237d03e98e39920"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d6efecc205d31652ade02f5b9592d315f123404590bd750aba03899badc6876" => :mojave
    sha256 "6542ce62ca384dc07865b6c5c8c8246c1cb18e6f8bab35e49d93158ab062badd" => :high_sierra
    sha256 "352118f8541323b3fadb6137fbb874aaea727b3bc92aa28d9b91530111047f47" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/miguelmota/cointop"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"cointop"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"cointop", "-test"
  end
end
