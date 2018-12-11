class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://github.com/AsamK/signal-cli/releases/download/v0.6.1/signal-cli-0.6.1.tar.gz"
  sha256 "550b389a25089ef2251d97997e06d57c70e9d4023684ff8682afef23ed2f1822"
  bottle do
    cellar :any_skip_relocation
    sha256 "9f78f519c436a3feaf038a20f5eddbd38f5d864ca44d471ed23d40687d454571" => :mojave
    sha256 "e13ce729d63e4f364f617e8dd7ee0239063265c1212accb6742de29c070005e0" => :high_sierra
    sha256 "e13ce729d63e4f364f617e8dd7ee0239063265c1212accb6742de29c070005e0" => :sierra
  end

  depends_on :java => "1.7+"

  def install
    # pattern taken from activemq
    libexec.install Dir["lib", "bin"]
    (bin/"signal-cli").write_env_script libexec/"bin/signal-cli", Language::Java.java_home_env("1.6+")
  end

  test do
    begin
      io = IO.popen("#{bin}/signal-cli link", :err => [:child, :out])
      sleep 6
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end
    assert_match "tsdevice:/?uuid=", io.read
  end
end
