class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.25.0/structurizr-cli-1.25.0.zip"
  sha256 "1a9ca6684a7711d6613458de158788f4350d975f5eb112a220c74eb9f9a7a899"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a7296bc90f7a8806963ac02b6cf8bb4cac114071bc7906725ae0de2d13d3564f"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    result = pipe_output("#{bin}/structurizr-cli").strip
    # not checking `Structurizr DSL` version as it is different binary
    assert_match "structurizr-cli: #{version}", result
    assert_match "Usage: structurizr push|pull|lock|unlock|export|validate|list|help [options]", result
  end
end
