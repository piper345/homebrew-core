require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.16.tgz"
  sha256 "cad889b23dcce44cc148f8b314c214e87dd8b3841df4011d149f9bcb4685bedd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8261752b7503328d363561849d4344f303a7983734867c52af5bfec0e57fd3c7"
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
