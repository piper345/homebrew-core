require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.31.tgz"
  sha256 "d3d7ddce5a9e03dc227e606c37ab1a10887fb5ee481696828f7eae9160e3abd1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c7498c62950a292768375dfd2a6b79d71bdf994895d820b8945820a8d6cf21fd"
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
