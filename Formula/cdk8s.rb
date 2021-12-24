require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.60.tgz"
  sha256 "5cba4261b917cade23ae145f48628a43d172cf8e8f287a1791c7ba33886aa5f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e594cff9875160b839cb7442bf17c748bc5e4593b27f7697fbdeac66e11c21ea"
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
