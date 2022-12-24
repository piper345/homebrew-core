require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.85.tgz"
  sha256 "624737cd72f8dcdca0d56db8f1721ab74f75315d27a4e5ff5086e945d1899b4e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7ee5e85df7f5d161ca27baef1111995c54607923a6ec5c30994f3f2e52bc8434"
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
