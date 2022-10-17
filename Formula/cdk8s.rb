require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.17.tgz"
  sha256 "6e8fc4d45997dc7299701d3f06bf9ba3b02ed61460013fc95056b9d1f726ee97"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0bcb169311227c303c60a9d3ff02673b7e3aaa78dca59b93ed411a0d13a51bf"
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
