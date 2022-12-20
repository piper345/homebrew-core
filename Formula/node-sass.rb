class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.57.1.tgz"
  sha256 "7010f87f7fee870dd210680bce92c2068a26a0690c509cc7a439d761575fdc13"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc49506a62d119a2ae7fd46d63a3d6de4c9e8bf20d9ad9ad1494f12f2aaf3fc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc49506a62d119a2ae7fd46d63a3d6de4c9e8bf20d9ad9ad1494f12f2aaf3fc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc49506a62d119a2ae7fd46d63a3d6de4c9e8bf20d9ad9ad1494f12f2aaf3fc9"
    sha256 cellar: :any_skip_relocation, ventura:        "fc49506a62d119a2ae7fd46d63a3d6de4c9e8bf20d9ad9ad1494f12f2aaf3fc9"
    sha256 cellar: :any_skip_relocation, monterey:       "fc49506a62d119a2ae7fd46d63a3d6de4c9e8bf20d9ad9ad1494f12f2aaf3fc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc49506a62d119a2ae7fd46d63a3d6de4c9e8bf20d9ad9ad1494f12f2aaf3fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fcc46cdbe909882e6b8e10447d602f1f7e603012d81219beeb94726f5773599"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
