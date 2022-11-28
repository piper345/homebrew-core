require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.60.tgz"
  sha256 "dbd0adaae34e05f87998686192122e194eaa50a42d02464b628d08c75fa0b4d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3dfbbccf95b2d99c5cabb7fe2b4ad691d59ed52f8514fc431cae09d64b0ed973"
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
