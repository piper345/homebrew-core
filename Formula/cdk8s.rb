require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.62.tgz"
  sha256 "f4d30d02339170a8cd7c8dc9451d4dd9a04e272c8fab75e4fecafc0bb40c5761"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2b5c1efada49c2d6ba402f9b6723ec2567e141abbe9bba02d3c5e8a0e3b0c1c0"
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
