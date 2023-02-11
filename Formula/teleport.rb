class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v12.0.2.tar.gz"
  sha256 "67ef1e7b6e6733c5d6a877a91cdc2091d140246804da75e9cc1e5998195f80d0"
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
    sha256 cellar: :any,                 arm64_ventura:  "65dd8a3bc7f23e99e3b1d2049314df9b53fa6c0ed3754c8ba494a4d4fbe924cd"
    sha256 cellar: :any,                 arm64_monterey: "5d3c7f144f554e4990d0f64344904d5ee9218be00a3265241a43b3bb7ce2463d"
    sha256 cellar: :any,                 arm64_big_sur:  "8ac4e4a6b11caac45c498da6a93cb7d69a695736cbbdb8c126a99c55bf5c0b5f"
    sha256 cellar: :any,                 ventura:        "80ca927bb70eb347933228d1648c9db02cbafb197d95f943f10c33b26cbbf940"
    sha256 cellar: :any,                 monterey:       "6c1bed878b479abca284a61dc35d992ff4c8e96b20956795e1a4eea65387b15a"
    sha256 cellar: :any,                 big_sur:        "082df4fb2d917c2d96957b8dc626cb8b3e93e3e485bb5f6de64f16d66d0ef312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2db57967b824db213c5dbff9121d5970eba703381c74c9a21f5b65b330b7fe11"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "yarn" => :build
  depends_on "libfido2"
  depends_on "node"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  def install
    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build/*"]
  end

  test do
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
