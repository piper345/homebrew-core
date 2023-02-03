require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.125.tgz"
  sha256 "b4919f4b4b224b5a7cbbc94d6d51fd466d93c4148fb500f959c4767c985d482c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "79909d0d1428a85118c967a054fa64256465c8d882c680c69411a02464b7fd81"
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
