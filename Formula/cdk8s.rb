require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.1.2.tgz"
  sha256 "4cd5ba3c4ff05c549bb8b504cedf4384835bbb7eb36ccae52871ae5606a03245"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5b4c6585ff06cdb792e9a7af9842571261f1f9372e49095fc233a98031453874"
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
