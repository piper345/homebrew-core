class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.27/hledger-1.27.tar.gz"
  sha256 "f872a141918501cc8b36d9b4ab3299c009caefd91adc9152b831b52c94e4e46c"
  license "GPL-3.0-or-later"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/install.html"
    regex(%r{href=.*?/tag/(?:hledger[._-])?v?(\d+(?:\.\d+)+)(?:#[^"' >]+?)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c2c3ef744bf7a4068401082afcc7f516b95b04fefa5f112dd52c84316cf884d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42674338ee571f5596b600908a765aec0911ff737de12ba9842bbfd6523a5060"
    sha256 cellar: :any_skip_relocation, monterey:       "3b37e97b8c963a64fa459fc3b89b5dc989e9b7ae4d1e4a89ce48cdd9b560a6e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf6fd65c4fc31e0a048c285ac9186b265febdfb8ecbe3ad726d9d611743f5384"
    sha256 cellar: :any_skip_relocation, catalina:       "8830b28f1ad6b581e5d0093dd79226c4f01a8c42c922d16aacdbaafc990528de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87c5cedfe3a02b5bc598c33a64d89b947e769c0c48ce2df7c9709c9311f22fb9"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-lib" do
    url "https://hackage.haskell.org/package/hledger-lib-1.27/hledger-lib-1.27.tar.gz"
    sha256 "d7d72d021a89c618aa6e91d15e45954db08746c3b7454a5be05a6efa2e6ca250"
  end

  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.27/hledger-ui-1.27.tar.gz"
    sha256 "41b63e69fb8a5524b41907b9fd677e1fa6a8f74789c4adc12f780d3cd9fff319"
  end

  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.27/hledger-web-1.27.tar.gz"
    sha256 "84ef49007be19ad0077951be6b1bbf6a2836520fa80b4ede256fa00efb6d9d48"
  end

  def install
    (buildpath/"../hledger-lib").install resource("hledger-lib")
    (buildpath/"../hledger-ui").install resource("hledger-ui")
    (buildpath/"../hledger-web").install resource("hledger-web")
    cd ".." do
      system "stack", "update"
      (buildpath/"../stack.yaml").write <<~EOS
        resolver: lts-17.5
        compiler: ghc-#{Formula["ghc"].version}
        compiler-check: newer-minor
        packages:
        - hledger-#{version}
        - hledger-lib
        - hledger-ui
        - hledger-web
      EOS
      system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"

      man1.install Dir["hledger-*/*.1"]
      man5.install Dir["hledger-lib/*.5"]
      info.install Dir["hledger-*/*.info"]
    end
  end

  test do
    system "#{bin}/hledger", "test"
    system "#{bin}/hledger-ui", "--version"
    system "#{bin}/hledger-web", "--test"
  end
end
