require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.73.tgz"
  sha256 "c6c15c72b3d3150cfae0c931e3608dd9bbcf694262f98727f221de277db38cbb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "45627a1382f9aa0607e08d8649c1e5a25c61d36d925b9a6e725cde46629cb10f"
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
