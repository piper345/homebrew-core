class Pdnsd < Formula
  desc "Proxy DNS server with permanent caching"
  homepage "http://members.home.nl/p.a.rombouts/pdnsd/"
  url "http://members.home.nl/p.a.rombouts/pdnsd/releases/pdnsd-1.2.9a-par.tar.gz"
  version "1.2.9a-par"
  sha256 "bb5835d0caa8c4b31679d6fd6a1a090b71bdf70950db3b1d0cea9cf9cb7e2a7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "96ae86eeb5157344c0d5dd4b0cc1027731f8483d4a8df099bbfaacb3da7d5c96" => :el_capitan
    sha256 "a55b3ea9a71be9bee77ddb9ced37f77bc0f37376bf2d66ecdb7780282ae66e35" => :yosemite
    sha256 "4dc63c69195b38fdb977bfcedb97de860d21a61beb0e280634037c1dee8bd455" => :mavericks
    sha256 "473a9d25b7461badb8814355a313595c12240dd8054a6865acf709d85f197da2" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}",
                          "--with-cachedir=#{var}/cache/pdnsd"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    This install of "pdnsd" expects config files to be in #{etc}
    All state files (status and cache) are stored in #{var}/cache/pdnsd.

    pdnsd needs to run as root since it listens on privileged ports.

    Sample config file can be found at #{etc}/pdnsd.conf.sample.

    Note that you must create the config file before starting the service,
    and change ownership to "root" or pdnsd will refuse to run:
      sudo chown root #{etc}/pdnsd.conf

    For other related utilities, e.g. pdnsd-ctl, to run, change the ownership
    to the user (default: nobody) running the service:
      sudo chown -R nobody #{var}/log/pdnsd.log #{var}/cache/pdnsd
    EOS
  end

  plist_options :startup => true, :manual => "sudo pdnsd"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>Program</key>
      <string>#{opt_sbin}/pdnsd</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/pdnsd.log</string>
      <key>StandardOutputPath</key>
      <string>#{var}/log/pdnsd.log</string>
      <key>Disabled</key>
      <false/>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_match "version #{version}",
      shell_output("#{sbin}/pdnsd --version", 1)
  end
end
