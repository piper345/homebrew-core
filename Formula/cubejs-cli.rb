require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.18.tgz"
  sha256 "cd7f784ac20ee9ae15a1b7e2d3099a75c76bc242dae3f5a7e3d3dc2b160e15da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4e15123cc0a4f751072f1b0080a69ff24c91dd7835757945cacd316a17e708c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4e15123cc0a4f751072f1b0080a69ff24c91dd7835757945cacd316a17e708c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4e15123cc0a4f751072f1b0080a69ff24c91dd7835757945cacd316a17e708c"
    sha256 cellar: :any_skip_relocation, monterey:       "ea13a97b43586ed2c59fca6e5c817a5309b117031b841f04dcc5be35f7991238"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea13a97b43586ed2c59fca6e5c817a5309b117031b841f04dcc5be35f7991238"
    sha256 cellar: :any_skip_relocation, catalina:       "ea13a97b43586ed2c59fca6e5c817a5309b117031b841f04dcc5be35f7991238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4e15123cc0a4f751072f1b0080a69ff24c91dd7835757945cacd316a17e708c"
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
