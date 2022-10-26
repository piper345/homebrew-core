class Flume < Formula
  desc "Hadoop-based distributed log collection and aggregation"
  homepage "https://flume.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=flume/1.11.0/apache-flume-1.11.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/flume/1.11.0/apache-flume-1.11.0-bin.tar.gz"
  sha256 "6eb7806076bdc3dcadb728275eeee7ba5cb12b63a2d981de3da9063008dba678"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7375590ff5eddb9609f2d330bda1fe998fa775dd800fae3df24c5e9cbd5b9f49"
  end

  depends_on "hadoop"
  depends_on "openjdk@11"

  def install
    rm_f Dir["bin/*.cmd", "bin/*.ps1"]
    libexec.install %w[conf docs lib tools]
    prefix.install "bin"

    flume_env = Language::Java.java_home_env("11")
    flume_env[:FLUME_HOME] = libexec
    bin.env_script_all_files libexec/"bin", flume_env
  end

  test do
    assert_match "Flume #{version}", shell_output("#{bin}/flume-ng version")
  end
end
