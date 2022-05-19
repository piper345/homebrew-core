require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.1.1.tgz"
  sha256 "d12614ac860d91cafeaa1b00e71633e7456e96db5b0878d2feb9c95a4cf9607f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fcde8505be751f62a03e57f297825707693a905859d04e96c58667b59f6e0750"
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
