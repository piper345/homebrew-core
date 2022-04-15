class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "https://vitess.io"
  url "https://github.com/vitessio/vitess/archive/v13.0.1.tar.gz"
  sha256 "26ebde8cd2720006510c573370fd6d77d5a573ea54e5e49e21c70906758775f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "356ad69d70c2663e1ef1da9726c17c963d72da2eaad419b1029189ea993e2ad7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca36bab3d5eaba9992cc3fa13ebd02a47040c53f9129ab067683add21e906659"
    sha256 cellar: :any_skip_relocation, monterey:       "cdf1d0e220d33196a3136255022525bd8ddc09a752404275d1f19a0677188791"
    sha256 cellar: :any_skip_relocation, big_sur:        "88212b2971ab6fa4278e46708f8a2652ae465b232e7becd08ab02a9a58d4f25c"
    sha256 cellar: :any_skip_relocation, catalina:       "19aec85755db5387f0ea132eb7755277fe9f34fa96cb542c2d65b75ed89c5b18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8291852afc3d7c75d709c1886e35dd7f20e52fa5e545e0a58618f5563163d18"
  end

  depends_on "go" => :build
  depends_on "etcd"

  def install
    # -buildvcs=false needed for build to succeed on Go 1.18.
    # It can be removed when this is no longer the case.
    system "make", "install-local", "PREFIX=#{prefix}", "VTROOT=#{buildpath}", "VT_EXTRA_BUILD_FLAGS=-buildvcs=false"
    pkgshare.install "examples"
  end

  test do
    ENV["ETCDCTL_API"] = "2"
    etcd_server = "localhost:#{free_port}"
    cell = "testcell"

    fork do
      exec Formula["etcd"].opt_bin/"etcd", "--enable-v2=true",
                                           "--data-dir=#{testpath}/etcd",
                                           "--listen-client-urls=http://#{etcd_server}",
                                           "--advertise-client-urls=http://#{etcd_server}"
    end
    sleep 3

    fork do
      exec Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}",
                                    "mkdir", testpath/"global"
    end
    sleep 1

    fork do
      exec Formula["etcd"].opt_bin/"etcdctl", "--endpoints", "http://#{etcd_server}",
                                    "mkdir", testpath/cell
    end
    sleep 1

    fork do
      exec bin/"vtctl", "-topo_implementation", "etcd2",
                        "-topo_global_server_address", etcd_server,
                        "-topo_global_root", testpath/"global",
                        "VtctldCommand", "AddCellInfo",
                        "--root", testpath/cell,
                        "--server-address", etcd_server,
                        cell
    end
    sleep 1

    port = free_port
    fork do
      exec bin/"vtgate", "-topo_implementation", "etcd2",
                         "-topo_global_server_address", etcd_server,
                         "-topo_global_root", testpath/"global",
                         "-tablet_types_to_wait", "PRIMARY,REPLICA",
                         "-cell", cell,
                         "-cells_to_watch", cell,
                         "-port", port.to_s
    end
    sleep 3

    output = shell_output("curl -s localhost:#{port}/debug/health")
    assert_equal "ok", output
  end
end
