require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.146.tgz"
  sha256 "d5588de01261aaaeec107553376f9149e71103f22a41067e1e691db456a8b3ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f9f727eb00907059e75c2ea971b29e3d08431c36e2b0a3817616e0e5ace8268d"
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
