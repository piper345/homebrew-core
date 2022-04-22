class Trino < Formula
  include Language::Python::Shebang

  desc "Distributed SQL query engine for big data"
  homepage "https://trino.io"
  url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/378/trino-server-378.tar.gz"
  sha256 "c9939c7fb8b734c8da6f6185e7ed4c4503d944adf726770cec8aab91bbda2e5c"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-server/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e9fec133101fbe331768e3826fdee180d2697609b246e8dab3f09fc27158054"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e9fec133101fbe331768e3826fdee180d2697609b246e8dab3f09fc27158054"
    sha256 cellar: :any_skip_relocation, monterey:       "5e9fec133101fbe331768e3826fdee180d2697609b246e8dab3f09fc27158054"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e9fec133101fbe331768e3826fdee180d2697609b246e8dab3f09fc27158054"
    sha256 cellar: :any_skip_relocation, catalina:       "5e9fec133101fbe331768e3826fdee180d2697609b246e8dab3f09fc27158054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7377af0312b739814bdcf3adf278fb5973ed86e4f60987509d43845c5d9111e"
  end

  depends_on "gnu-tar" => :build
  depends_on "openjdk"
  depends_on "python@3.10"

  resource "trino-src" do
    url "https://github.com/trinodb/trino/archive/378.tar.gz", using: :nounzip
    sha256 "afda089374767dbdcad9d0afc679b1736ea7c3ef0006c48b34204c6542d6c1c7"
  end

  resource "trino-cli" do
    url "https://search.maven.org/remotecontent?filepath=io/trino/trino-cli/378/trino-cli-378-executable.jar"
    sha256 "0bfdde39faf15222ea3cfe06723ada66446799af56ea08319a001028680f1da7"
  end

  def install
    libexec.install Dir["*"]

    # Manually untar, since macOS-bundled tar produces the error:
    #   trino-363/plugin/trino-hive/src/test/resources/<truncated>.snappy.orc.crc: Failed to restore metadata
    # Remove when https://github.com/trinodb/trino/issues/8877 is fixed
    resource("trino-src").stage do |r|
      ENV.prepend_path "PATH", Formula["gnu-tar"].opt_libexec/"gnubin"
      system "tar", "-xzf", "trino-#{r.version}.tar.gz"
      (libexec/"etc").install Dir["trino-#{r.version}/core/docker/default/etc/*"]
      inreplace libexec/"etc/node.properties", "docker", tap.user.downcase
      inreplace libexec/"etc/node.properties", "/data/trino", var/"trino/data"
    end

    rewrite_shebang detected_python_shebang, libexec/"bin/launcher.py"
    (bin/"trino-server").write_env_script libexec/"bin/launcher", Language::Java.overridable_java_home_env

    resource("trino-cli").stage do
      libexec.install "trino-cli-#{version}-executable.jar"
      bin.write_jar_script libexec/"trino-cli-#{version}-executable.jar", "trino"
    end

    # Remove incompatible pre-built binaries
    libprocname_dirs = libexec.glob("bin/procname/*")
    libprocname_dirs.reject! { |dir| dir.basename.to_s == "#{OS.kernel_name}-#{Hardware::CPU.arch}" }
    libprocname_dirs.map(&:rmtree)
  end

  def post_install
    (var/"trino/data").mkpath
  end

  service do
    run [opt_bin/"trino-server", "run"]
    working_dir opt_libexec
  end

  test do
    port = free_port
    cp libexec/"etc/config.properties", testpath/"config.properties"
    inreplace testpath/"config.properties", "8080", port.to_s
    server = fork do
      exec bin/"trino-server", "run", "--verbose",
                                      "--data-dir", testpath,
                                      "--config", testpath/"config.properties"
    end
    sleep 30

    query = "SELECT state FROM system.runtime.nodes"
    output = shell_output(bin/"trino --debug --server localhost:#{port} --execute '#{query}'")
    assert_match "\"active\"", output
  ensure
    Process.kill("TERM", server)
    Process.wait server
  end
end
