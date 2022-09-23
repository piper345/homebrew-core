require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.118.tgz"
  sha256 "14a7a9172ad462c15cbbdda75d0a9436a179ad47ed8ee99d8010b47282478eb6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f8f1fb42cd1d10399dc3b90dfdf87fe08170d9ba54f934ff47568331f4eb7991"
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
