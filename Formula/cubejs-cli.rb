require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.5.tgz"
  sha256 "3a8a3ba1ca1af1fecd0e474bcb36792351c0e736aea68a16f64173dc3468232f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a919e184bf33687153ad26eb3e1f5078dc925aa067b58fc10a4da7023b1a830"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a919e184bf33687153ad26eb3e1f5078dc925aa067b58fc10a4da7023b1a830"
    sha256 cellar: :any_skip_relocation, monterey:       "7355bcf154bed38a916879a2f25576c66b20e7eb143ecee5813edb27501a527b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7355bcf154bed38a916879a2f25576c66b20e7eb143ecee5813edb27501a527b"
    sha256 cellar: :any_skip_relocation, catalina:       "7355bcf154bed38a916879a2f25576c66b20e7eb143ecee5813edb27501a527b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a919e184bf33687153ad26eb3e1f5078dc925aa067b58fc10a4da7023b1a830"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
