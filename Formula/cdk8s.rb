require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.93.tgz"
  sha256 "97a1239013371658b1b3546ca733cdc0f3777af4a3871cf1b0078a3af6aa79a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "15506e96a73049911afd0d506c40e5bbecb1041068b8b9c38fef04b77809165e"
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
