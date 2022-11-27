require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.59.tgz"
  sha256 "dbd90fff44601f8a27d16fdf427577131c32c9dbef31378b79d1ce5723cdc363"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a759391067c4f385413a5dc747b3ce450415e37bf67fcdd4d868c5b438d3c24b"
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
