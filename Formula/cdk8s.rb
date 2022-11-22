require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.54.tgz"
  sha256 "218e7898518baa937dc3f33cc5dfaee58f012d284c2d14f7e4a90aa7b57b3add"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3c6554f83c719cbe086c78e72e62f1a97823ad3e1f4ff6d3d7eeeb5a3a0039ed"
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
