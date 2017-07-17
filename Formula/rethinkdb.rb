class Rethinkdb < Formula
  desc "The open-source database for the realtime web"
  homepage "https://www.rethinkdb.com/"
  url "https://github.com/rethinkdb/rethinkdb/archive/v2.3.6.tar.gz"
  sha256 "6a12778bca0c4b623b06acbfbe2a5e68a8ba555c706e0e076298eeef8fa585a1"

  bottle do
    cellar :any
    sha256 "6e4e8e922e112854353932311d13218ff3c9cb6dc09f6ece87eb0e2b79a0d396" => :sierra
    sha256 "b0d0fadb51e976b928aa7d24c8f94f30df1a4c9d6d9ae0102264b266524f9ae3" => :el_capitan
    sha256 "672dfcd6bc467878aff6864bef96f420e3f25bb9ebda4161810a55b10d5d5b84" => :yosemite
    sha256 "dfa15869b955c42614200ff00987f8a4e9a50e1aabf9ee9738f43a617bf6cdac" => :mavericks
  end

  depends_on :macos => :lion
  depends_on "boost" => :build
  depends_on "openssl"

  fails_with :gcc do
    build 5666 # GCC 4.2.1
    cause "RethinkDB uses C++0x"
  end

  def install
    args = ["--prefix=#{prefix}"]

    # rethinkdb requires that protobuf be linked against libc++
    # but brew's protobuf is sometimes linked against libstdc++
    args += ["--fetch", "protobuf"]

    system "./configure", *args
    system "make"
    system "make", "install-osx"

    (var/"log/rethinkdb").mkpath

    inreplace "packaging/assets/config/default.conf.sample",
              /^# directory=.*/, "directory=#{var}/rethinkdb"
    etc.install "packaging/assets/config/default.conf.sample" => "rethinkdb.conf"
  end

  plist_options :manual => "rethinkdb"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
          <string>#{opt_bin}/rethinkdb</string>
          <string>--config-file</string>
          <string>#{etc}/rethinkdb.conf</string>
      </array>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/rethinkdb/rethinkdb.log</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/rethinkdb/rethinkdb.log</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    shell_output("#{bin}/rethinkdb create -d test")
    assert File.read("test/metadata").start_with?("RethinkDB")
  end
end
