class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v5.1.0.tar.gz"
  sha256 "b3dbd2bbee9486999b81d1968545c5a6caa7b0f4726a7259939f1bda54fcf5ea"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39375e667ddca5e5d93f0c399d8969be3f0ca8015f8179c6dfc9ecfa1aa2222c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f743a933cca4e588c3f8ce883aa62944be19360e330b6d55f559eb1b72bb4f6"
    sha256 cellar: :any_skip_relocation, monterey:       "6ca8683200055af0e1d7895b44aad91ac1f47ad2abe42a73bf3da2a59db714e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "10ac146769d892d242d4bd2c15c1630653ad85e0ac6d36d111aa03517be3a5be"
    sha256 cellar: :any_skip_relocation, catalina:       "39ad8bcc96f63ca58873ec903c3974dcfdf5c6c9b38fc1f3cd1e787e2da57330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a9d347cd01bddb5e1a4c81c0374b4c6ca62b5ea3f1f4e353c1c68f59895089d"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202209010055/geoip.dat"
    sha256 "94c6f6935aa3fa81ec7d8fd7bcab8832a50216c78537a83fc2bd7c051374ba88"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202209010055/geoip-only-cn-private.dat"
    sha256 "529afb06295f3d1dcd3fa9a0d4ef5c07074ac2c3a8834edddc3a0ad22071bae1"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20220904120706/dlc.dat"
    sha256 "0484768bb454a860bd06e059adaf2167f2da68bcf767b991f13bf6670287f227"
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
