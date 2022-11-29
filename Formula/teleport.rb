class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v11.1.0.tar.gz"
  sha256 "c2d6de3349c88a82a489e361c55133fde911ebd3a89a9a1e83c6414d5825f960"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # We check the Git tags instead of using the `GithubLatest` strategy, as the
  # "latest" version can be incorrect. As of writing, two major versions of
  # `teleport` are being maintained side by side and the "latest" tag can point
  # to a release from the older major version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e1bf0dbab4172394cac54870a4d8fd60546bd517c6b882a8474f0b27e2fe190e"
    sha256 cellar: :any,                 arm64_monterey: "1b6b62eb52b5154348bf9eca7053674a57f82fb1bcdf72b1790cb1d2cd5434f1"
    sha256 cellar: :any,                 arm64_big_sur:  "a3bbd1cf06cdacfec409775c394e9d32c8312a7de9e3df26bde0d61a3c27d39d"
    sha256 cellar: :any,                 ventura:        "8f6d8328606b3f9a7fcf481ba0c1516d72aaaad36ada825bf7d2d015594393ed"
    sha256 cellar: :any,                 monterey:       "b7a0947faf1705de9dbd0b7bc2261f656040b531c8752ec6f07edf5b4df28e11"
    sha256 cellar: :any,                 big_sur:        "0eee261ec9a20e89b7114f79d3dc0bc8a4f2ae9898a9c9fc7ba6a80ace48c229"
    sha256 cellar: :any,                 catalina:       "c74e3367f4f2a88fa3d68418dfafd3d62937fc5df97652a2aeaf64413a41fbf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3486ccd55295a2c7fe6089589ee3774a20fe65740ee411493f943572308a167"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libfido2"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/b2910b3430edd76b69e76a896fe594cc6082a66c.tar.gz"
    sha256 "3f444a568e1ea1c1385b286d6647d4b6fb023c3ddd99ee277b8799757d3f20f1"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build/*"]
  end

  test do
    curl_output = shell_output("curl \"https://api.github.com/repos/gravitational/teleport/contents/webassets?ref=v#{version}\"")
    assert_match JSON.parse(curl_output)["sha"], resource("webassets").url
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~EOS
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    EOS

    fork do
      exec "#{bin}/teleport start --roles=proxy,node,auth --config=#{testpath}/config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl --config=#{testpath}/config.yml status")
    assert_match(/Cluster\s*testhost/, status)
    assert_match(/Version\s*#{version}/, status)
  end
end
