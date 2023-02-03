class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
    tag:      "v1.64.1",
    revision: "21216d18d5a2e63ed68b09bf8c3055b64efd1b65"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c3a12be53ff84747f300132cfc6c667e46bfa0938ff7f0e673758d81ffd7682"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fff89c8f065f8624b28f629cdfd48989510fcedf9251a23f45c192763797ccd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16901e9a1e6aba7cf82306aebade8a39ff546759e64c96e50f66de7e225a7725"
    sha256 cellar: :any_skip_relocation, ventura:        "a11aff4c641f3f626c1adb68dc8b666f00dadbd7db288f4b4f354cebfa33ee84"
    sha256 cellar: :any_skip_relocation, monterey:       "7e3811332c07ad32130000784932856c0289082920f9be5c037c0d707cadcf4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "029fffecdcecef253735964328d3f83dc9e2c9efd5aa2ece0818cb6f0d04247e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "550f2e0d6dda588fc727e5a73c347397bc5d15c78e68e04aa556c7bf76d61a96"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -s -w
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
