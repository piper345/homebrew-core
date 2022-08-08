require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.77.tgz"
  sha256 "6c860aca1d89d0718017b3b9481ac1adb6988c9add602e971a45cbba6542817e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fabd14df8c6c2d30d5a34997b0b1b81e5e7d8bf0f43f35a8ccc99363f03ca38c"
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
