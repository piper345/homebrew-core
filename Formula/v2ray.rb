class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v5.2.1.tar.gz"
  sha256 "97bc872e798fed51c23c39f8f63ee25984658e2b252b0ec2c8ec469c00a4d77a"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "950f263eca43e38d68a850bcc97e1a2e3fa41487c74a983a176aee50c973649a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39375e667ddca5e5d93f0c399d8969be3f0ca8015f8179c6dfc9ecfa1aa2222c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f743a933cca4e588c3f8ce883aa62944be19360e330b6d55f559eb1b72bb4f6"
    sha256 cellar: :any_skip_relocation, ventura:        "1aaafc337a929402bc1ba5b10196da7ba5909151c188afbd328cd3927136cfe0"
    sha256 cellar: :any_skip_relocation, monterey:       "6ca8683200055af0e1d7895b44aad91ac1f47ad2abe42a73bf3da2a59db714e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "10ac146769d892d242d4bd2c15c1630653ad85e0ac6d36d111aa03517be3a5be"
    sha256 cellar: :any_skip_relocation, catalina:       "39ad8bcc96f63ca58873ec903c3974dcfdf5c6c9b38fc1f3cd1e787e2da57330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a9d347cd01bddb5e1a4c81c0374b4c6ca62b5ea3f1f4e353c1c68f59895089d"
  end

  depends_on "go@1.18" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202301120046/geoip.dat"
    sha256 "1af779bf9ba759be7590be3b3baf83d7e5c686b003f6f39dd3ab0e847eaedb72"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202301120046/geoip-only-cn-private.dat"
    sha256 "850ce49fc34abaab94fffcd7f9c45ce087cd873a793fb67c8fa850f3facf8afa"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20230117091624/dlc.dat"
    sha256 "603bc4be59858702858267a185aa4ee9e9a1d61604068511cd65907da5738d51"
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args, "-o", execpath,
                 "-ldflags", ldflags,
                 "./main"
    system "go", "build", *std_go_args,
                 "-ldflags", ldflags,
                 "-tags", "confonly",
                 "-o", bin/"v2ctl",
                 "./infra/control/main"
    (bin/"v2ray").write_env_script execpath,
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "release/config/config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geoip-only-cn-private").stage do
      pkgshare.install "geoip-only-cn-private.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  service do
    run [bin/"v2ray", "-config", etc/"v2ray/config.json"]
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~EOS
      {
        "log": {
          "access": "#{testpath}/log"
        },
        "outbounds": [
          {
            "protocol": "freedom",
            "tag": "direct"
          }
        ],
        "routing": {
          "rules": [
            {
              "ip": [
                "geoip:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            },
            {
              "domains": [
                "geosite:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            }
          ]
        }
      }
    EOS
    output = shell_output "#{bin}/v2ray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
