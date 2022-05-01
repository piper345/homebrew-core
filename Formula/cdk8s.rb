require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.163.tgz"
  sha256 "53081ef89ca1b884b20b24d80e1204a83a4d2682668616a07f103c3bf2c9513c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "513df9dac436669b70b64da62283fd42838cd28db975c43adeb7d48d2e544a2d"
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
