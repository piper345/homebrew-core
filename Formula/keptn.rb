class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.19.2.tar.gz"
  sha256 "70c5c3c89aa02a1e18dad60e08984fba2f99e289d001c70ef916d71620584791"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c8a251c7cd9da19fa07c374494dc80f7c8f03068fbf3f64f57b45fbc0d05628"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29f24b10940eb77343f6a8d93a2d18e6ee6dc38edeed965e793c6c368bb547a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d161b4c40ec3242e481d65521891970a1790dce1474701e73b4c20c2f1e78a9"
    sha256 cellar: :any_skip_relocation, monterey:       "111efa0602387aef47c976836d9f158714f89a5ec29345cfd880045ef30b883c"
    sha256 cellar: :any_skip_relocation, big_sur:        "19c46993aaa40cdaa3a5cbc85b9c2f8ec5d069aae36f9192efb85c776059ffc8"
    sha256 cellar: :any_skip_relocation, catalina:       "a46a7c07f8262142dc4e0e5ebc15b58766bdbf74e6a8dbd1492c8100589e4b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79e443ef26d399d69e47e66818e604653f2249a3f21a60ccbca3c8351bb64c56"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/keptn/keptn/cli/cmd.Version=#{version}
      -X main.KubeServerVersionConstraints=""
    ]

    cd buildpath/"cli" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    system bin/"keptn", "set", "config", "AutomaticVersionCheck", "false"
    system bin/"keptn", "set", "config", "kubeContextCheck", "false"

    assert_match "Keptn CLI version: #{version}", shell_output(bin/"keptn version 2>&1")

    output = shell_output(bin/"keptn status 2>&1", 1)
    if OS.mac?
      assert_match "Error: credentials not found in native keychain", output
    else
      assert_match ".keptn/.keptn____keptn: no such file or directory", output
    end
  end
end
