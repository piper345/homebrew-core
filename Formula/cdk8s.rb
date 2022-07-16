require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.52.tgz"
  sha256 "17ef63d76c048665bf75fb1a9963b83dff577431a7519436ad1698ae166c18ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a18b2446af0d23ab024504156cff9fe0cff8546007449fef41aeadd9e1dc684"
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
