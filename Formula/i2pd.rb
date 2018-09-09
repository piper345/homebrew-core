class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://github.com/PurpleI2P/i2pd/archive/2.20.0.tar.gz"
  sha256 "e424c368f92be5050f3dd5e98ed9ce2ea8d6076e36444c99b96e3b10f69420b1"

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@1.1"

  needs :cxx11

  # That patches will be here till next release
  # Upstream commits:
  # https://github.com/PurpleI2P/i2pd/commit/064460b95f656cb211995f88c66bea94d88224d4
  # https://github.com/PurpleI2P/i2pd/commit/6fe1de5d869343a2b80fdd168c4276880bc57b3f
  patch do
    url "https://github.com/PurpleI2P/i2pd/commit/064460b95f656cb211995f88c66bea94d88224d4.diff?full_index=1"
    sha256 "0d8503b7188bd7172d12c6b75e2928ab80606cc75400912a62eb28a4b0809978"
  end

  patch do
    url "https://github.com/PurpleI2P/i2pd/commit/6fe1de5d869343a2b80fdd168c4276880bc57b3f.diff?full_index=1"
    sha256 "073ba6c44eddeadbbb28c37846a9faedb5715b82b82519c6d00420f01f0fac6d"
  end

  def install
    ENV["HOMEBREW_OPTFLAGS"] = "-march=#{Hardware.oldest_cpu}" unless build.bottle?

    system "make", "install", "DEBUG=no", "HOMEBREW=1", "USE_UPNP=yes", "USE_AENSI=no", "USE_AVX=no", "PREFIX=#{prefix}"

    # preinstall to prevent overwriting changed by user configs
    confdir = etc/"i2pd"
    rm_rf prefix/"etc"
    confdir.install doc/"i2pd.conf", doc/"subscriptions.txt", doc/"tunnels.conf"
  end

  def post_install
    # i2pd uses datadir from variable below. If that path not exists, create that directory and create symlinks to certificates and configs.
    # Certificates can be updated between releases, so we must re-create symlinks to latest version of it on upgrade.
    datadir = var/"lib/i2pd"
    if datadir.exist?
      rm datadir/"certificates"
      datadir.install_symlink pkgshare/"certificates"
    else
      datadir.dirname.mkpath
      datadir.install_symlink pkgshare/"certificates", etc/"i2pd/i2pd.conf", etc/"i2pd/subscriptions.txt", etc/"i2pd/tunnels.conf"
    end

    (var/"log/i2pd").mkpath
  end

  plist_options :manual => "i2pd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/i2pd</string>
        <string>--datadir=#{var}/lib/i2pd</string>
        <string>--conf=#{etc}/i2pd/i2pd.conf</string>
        <string>--tunconf=#{etc}/i2pd/tunnels.conf</string>
        <string>--log=file</string>
        <string>--logfile=#{var}/log/i2pd/i2pd.log</string>
        <string>--pidfile=#{var}/run/i2pd.pid</string>
      </array>
    </dict>
    </plist>
  EOS
  end

  test do
    pid = fork do
      exec "#{bin}/i2pd", "--datadir=#{testpath}", "--daemon"
    end
    sleep 5
    Process.kill "TERM", pid
    assert_predicate testpath/"router.keys", :exist?, "Failed to start i2pd"
  end
end
