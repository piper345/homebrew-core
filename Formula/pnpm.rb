class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.26.1.tgz"
  sha256 "deab036ddd371299a9d8597fdf878cb4dcb9e3f9766e8dd34b9947e109f5f823"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9574cc8bb64d8623a1220e3805a9dd82bac0752d21855112055ac1692d41cb13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9574cc8bb64d8623a1220e3805a9dd82bac0752d21855112055ac1692d41cb13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9574cc8bb64d8623a1220e3805a9dd82bac0752d21855112055ac1692d41cb13"
    sha256 cellar: :any_skip_relocation, ventura:        "06f55dc71fdb50f06ad85259e82cf9511873702fac87b0342e43908bed79df05"
    sha256 cellar: :any_skip_relocation, monterey:       "06f55dc71fdb50f06ad85259e82cf9511873702fac87b0342e43908bed79df05"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c060d295b1806f8ee0f623782cf095436cb5b589546f882f122fc670cb19cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9574cc8bb64d8623a1220e3805a9dd82bac0752d21855112055ac1692d41cb13"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
