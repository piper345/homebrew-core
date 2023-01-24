require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.115.tgz"
  sha256 "7a173b100724da9c39954a0f2177ab492676ce14fa36dd8de16ad1f8222191ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "06e7a233f825cdf04f7ee3f2f0c6947676283162207d065eea726bccacadc861"
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
