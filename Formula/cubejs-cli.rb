require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.10.tgz"
  sha256 "1645315e1597cb6ce24d202471a6db374ea59187b9731f2cb2a500b32cfcbd03"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40a0803c280fa424c062727c09e16b15219f69ce590e45aec6370ade73e96c2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40a0803c280fa424c062727c09e16b15219f69ce590e45aec6370ade73e96c2a"
    sha256 cellar: :any_skip_relocation, monterey:       "52fab6176116fce50bddceef3fd36168347059e0379c940439059b7e01efd316"
    sha256 cellar: :any_skip_relocation, big_sur:        "52fab6176116fce50bddceef3fd36168347059e0379c940439059b7e01efd316"
    sha256 cellar: :any_skip_relocation, catalina:       "52fab6176116fce50bddceef3fd36168347059e0379c940439059b7e01efd316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40a0803c280fa424c062727c09e16b15219f69ce590e45aec6370ade73e96c2a"
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
