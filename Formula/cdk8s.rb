require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.33.tgz"
  sha256 "ab25ea50d2e378e87ea07713ce770d4fe15eac7e5e2e8459a9e30bee68e738df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae9eaa794f96119db6cb0bb67e10c6250b3966e0bf1e73dbfcba850f82e8751a"
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
