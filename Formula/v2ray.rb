class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v5.3.0.tar.gz"
  sha256 "8e97e2647cb1dee8aa7e71df276c56d74258b2d97bb490a362afa84bdf1b9e25"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7d93d08240e011be2fb75984573790982329bbb7d018b25374ca57a896fd7be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caa239882fce7897e8ed51310e2be00ae4a26a93480e555e502a743cea67bd3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdac0322927393f6f0bc42b1a94095e3b0d086277735312d4eebc20cc7f59552"
    sha256 cellar: :any_skip_relocation, ventura:        "9b16a29966d63107a19a4b04ff66114b929e790652aa0b9af08611caca43d038"
    sha256 cellar: :any_skip_relocation, monterey:       "72046bf0cfe7874251e22b39aa882a08c444f650c2a9802053bdea4e5b297249"
    sha256 cellar: :any_skip_relocation, big_sur:        "48ff555942cd5c5225ef1c1e9043582305abce6b8a9d49a1188c3f1893c0f52e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5118ceec975746d9b0d74c182032b7319f51b7eefb422e7c68b1c674205796ae"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202302090046/geoip.dat"
    sha256 "38e200a655c3e401dde6a438e79d493c3dbdd224e104a5158bef01f78ad4a151"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202302090046/geoip-only-cn-private.dat"
    sha256 "827097e93035f76c336b868def3bb706dfad9aea2ce189f753078d9733d16ed3"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20230210153419/dlc.dat"
    sha256 "2a92cd713c1f275efa0a307b232ae485dee9394f621597fa434503e5a0ed97e2"
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args, "-o", execpath,
                 "-ldflags", ldflags,
                 "./main"
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
    run [bin/"v2ray", "run", "-config", etc/"v2ray/config.json"]
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
    output = shell_output "#{bin}/v2ray test -c #{testpath}/config.json"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
