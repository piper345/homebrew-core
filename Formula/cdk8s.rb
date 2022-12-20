require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.81.tgz"
  sha256 "bf8ac8d9db0bf42ad634058ddbe24692d23361b9c93ec8266bd873b49ffcb665"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cdec0b8d38b595c04137126a75cd8df9b4e97bab99e92e351f3af76d425fd1ee"
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
