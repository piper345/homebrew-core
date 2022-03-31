class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.19.0/structurizr-cli-1.19.0.zip"
  sha256 "aad505e9e48b89a30fe411990981205433bb650e4148ca2f5d877477c80fe42d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "590b1c5d3b6de4c3fe99a9c0fad5b26a7536c626b848a2e931cb68510a17a7b3"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    expected_output = <<~EOS.strip
      Structurizr CLI v#{version}
      Structurizr DSL v#{version}
      Usage: structurizr push|pull|lock|unlock|export|validate|list [options]
    EOS
    result = pipe_output("#{bin}/structurizr-cli").strip
    assert_equal result, expected_output
  end
end
