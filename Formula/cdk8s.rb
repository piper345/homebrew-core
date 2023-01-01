require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.92.tgz"
  sha256 "a3f76b31eb697fd018a713c05ffbe86af6da9161a184a331d137782d92b50dbc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0cd015ea9ba18a6994019b7c7fb520a7590b533a0fda5c90ff41cb008534aa71"
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
