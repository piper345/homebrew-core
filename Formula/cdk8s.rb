require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.53.tgz"
  sha256 "71aadb94f8c3a83918245ade12baa069fc14826e1bfbe5de2b570678b814e58a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f9fb6fda23dce4f314c979861706d9809057e035a3ba9685f57f55191f82ed96"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
