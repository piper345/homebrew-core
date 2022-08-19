require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.88.tgz"
  sha256 "2168f4c3bfac49f946e52d2e5c127e31960359726cd7a9c9b7b10b12ec148e72"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d8d9f556c273c13cf622d20915147906c21c9d7a2fdb55a1a4b28c634a50de8c"
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
