require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.64.0.tgz"
  sha256 "27551d8eb103727c0d9d6b2bf3d7893de7a767ea2c182832bb40cb0f9c96696c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2eee5251d237b3f93c09f9f566f9de855b69478d3dc2466289075e457f63a16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2eee5251d237b3f93c09f9f566f9de855b69478d3dc2466289075e457f63a16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2eee5251d237b3f93c09f9f566f9de855b69478d3dc2466289075e457f63a16"
    sha256 cellar: :any_skip_relocation, ventura:        "c0a9008b0877763054c1582f96635e6ad7a96a8f0217a64c90aff8e887232cac"
    sha256 cellar: :any_skip_relocation, monterey:       "c0a9008b0877763054c1582f96635e6ad7a96a8f0217a64c90aff8e887232cac"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0a9008b0877763054c1582f96635e6ad7a96a8f0217a64c90aff8e887232cac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90f17fc501f81cce89fda4bea8c03a34346654208e80078b9cccd501ecd1120f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
