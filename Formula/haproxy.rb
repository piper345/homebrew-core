class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/1.8/src/haproxy-1.8.12.tar.gz"
  sha256 "f438a98e657935fa8fad48b98d9029a399e0ad9105cf0e7e8e54365f93d83e9b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9fabb272a85a3b756ff111a6a56c59b686659307afd2daee4dd3ae2c34241899" => :high_sierra
    sha256 "1b54421ff71d01ee5c91246b85b03cb8fcccb3a579001d1cf6e75d0bfba4aac5" => :sierra
    sha256 "402d926c477a79358d0e47ed87d87c7087ea7c4af0d19b9cb6872f06c507795a" => :el_capitan
  end

  depends_on "openssl"
  depends_on "pcre"
  depends_on "lua" => :optional

  def install
    args = %w[
      TARGET=generic
      USE_KQUEUE=1
      USE_POLL=1
      USE_PCRE=1
      USE_OPENSSL=1
      USE_THREAD=1
      USE_ZLIB=1
      ADDLIB=-lcrypto
    ]

    if build.with?("lua")
      lua = Formula["lua"]
      args << "USE_LUA=1"
      args << "LUA_LIB=#{lua.opt_lib}"
      args << "LUA_INC=#{lua.opt_include}/lua"
      args << "LUA_LD_FLAGS=-L#{lua.opt_lib}"
    end

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end

  plist_options :manual => "haproxy -f #{HOMEBREW_PREFIX}/etc/haproxy.cfg"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/haproxy</string>
          <string>-f</string>
          <string>#{etc}/haproxy.cfg</string>
        </array>
        <key>StandardErrorPath</key>
        <string>#{var}/log/haproxy.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/haproxy.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    system bin/"haproxy", "-v"
  end
end
