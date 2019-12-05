class Stolon < Formula
  desc "Cloud native PostgreSQL manager for high availability"
  homepage "https://github.com/sorintlab/stolon"
  url "https://github.com/sorintlab/stolon.git",
    :tag      => "v0.15.0",
    :revision => "6d95a34cce93e12a594420443aacdd7f919399f1"

  bottle do
    cellar :any_skip_relocation
    sha256 "51d6407392f8c4c13a12de0003f188bbb0f8fc02eed970d8cf62c7cf9d194cf5" => :catalina
    sha256 "4c9b9cfaf27f24e6011277f5a37ef9292ffeaa9bb53561b5223cd8796c071660" => :mojave
    sha256 "fcbe634904119d23eb304dfb3a96973eb60721a65163b782c919a2eebef60a8a" => :high_sierra
    sha256 "893841a3fbe74d09346c360f38c95c9e534a51604e9a9f834cd1fb86cfe3473c" => :sierra
  end

  depends_on "go" => :build
  depends_on "consul" => :test
  depends_on "postgresql"

  def install
    system "go", "build", "-ldflags", "-s -w -X github.com/sorintlab/stolon/cmd.Version=#{version}", "-trimpath", "-o", bin/"stolonctl", "./cmd/stolonctl"
    system "go", "build", "-ldflags", "-s -w -X github.com/sorintlab/stolon/cmd.Version=#{version}", "-trimpath", "-o", bin/"stolon-keeper", "./cmd/keeper"
    system "go", "build", "-ldflags", "-s -w -X github.com/sorintlab/stolon/cmd.Version=#{version}", "-trimpath", "-o", bin/"stolon-sentinel", "./cmd/sentinel"
    system "go", "build", "-ldflags", "-s -w -X github.com/sorintlab/stolon/cmd.Version=#{version}", "-trimpath", "-o", bin/"stolon-proxy", "./cmd/proxy"
    prefix.install_metafiles
  end

  test do
    pid = fork do
      exec "consul", "agent", "-dev"
    end
    sleep 2

    assert_match "stolonctl version #{version}", shell_output("#{bin}/stolonctl version 2>&1")
    assert_match "nil cluster data: <nil>", shell_output("#{bin}/stolonctl status --cluster-name test --store-backend consul 2>&1", 1)
    assert_match "stolon-keeper version #{version}", shell_output("#{bin}/stolon-keeper --version 2>&1")
    assert_match "stolon-sentinel version #{version}", shell_output("#{bin}/stolon-sentinel --version 2>&1")
    assert_match "stolon-proxy version #{version}", shell_output("#{bin}/stolon-proxy --version 2>&1")

    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
