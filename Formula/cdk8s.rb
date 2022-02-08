require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.93.tgz"
  sha256 "82087bf3272c47344abe89c29dd1972ccbc3fb2c99d938024998a16863642223"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e56107d9991d54981b7bd64e6192cad55a1a3c55bdecfd98eca8b7bd76cb1e4"
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
