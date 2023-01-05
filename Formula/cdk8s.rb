require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.96.tgz"
  sha256 "96d0b8b8c60c076369057e63fce0816529d086134fb7cf73586774069aa10325"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5af3c2052b4920915e507676acef0baf476924a7fe35c5acf232b10805e2d428"
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
