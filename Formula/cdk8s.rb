require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.112.tgz"
  sha256 "49e5599ca706b2b087275b0a3229ba7ee7e030c678cd6b00543ed0596da22abb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a78ba19bc0c1472a81a5fe93de7036f6e1acfabc8fa563515f08037d044c6838"
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
