require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.97.tgz"
  sha256 "09e920bf2182c7462ec9c15cc1def39baaa7635391a7e7015ebff0656363d116"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ebec46767b3ae422c7fb0fbef85d3c9cbf2288997100b956aa9f4793091bca48"
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
