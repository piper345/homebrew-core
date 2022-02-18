require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.101.tgz"
  sha256 "d7b23ef6661d6e19daa70494071cfc050e2f5bfa7eb4248819fb4b4225fd44b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b0bf573d3d0cb7ed5c878d4fcef6e869c0724e5859e6b72d5537729972ded33f"
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
