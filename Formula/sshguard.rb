class Sshguard < Formula
  desc "Protect from brute force attacks against SSH"
  homepage "http://www.sshguard.net/"
  url "https://downloads.sourceforge.net/project/sshguard/sshguard/1.6.4/sshguard-1.6.4.tar.gz"
  sha256 "654d5412ed010e500e2715ddeebfda57ab23c47a2bd30dfdc1e68c4f04c912a9"

  bottle do
    cellar :any_skip_relocation
    sha256 "abce8fa2ed4290871d433a22b539a89bb96d9e3797c55dc4a0f85314758b3af0" => :el_capitan
    sha256 "d1939f763079959ce9bd3c49db2b56b0cb2dac3206c33c6c69ff14d07407790b" => :yosemite
    sha256 "0ab30d0a677d360f02ead6c98f510bd86ddbd9a693c63f87e6a5e7c79e830474" => :mavericks
    sha256 "2c115efec5b401a9c3463b830031db885db06b6bb432d29c81db4a0596de28bd" => :mountain_lion
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-firewall=#{firewall}"
    system "make", "install"
  end

  def firewall
    MacOS.version >= :lion ? "pf" : "ipfw"
  end

  def log_path
    MacOS.version >= :lion ? "/var/log/system.log" : "/var/log/secure.log"
  end

  def caveats
    if MacOS.version >= :lion then <<-EOS.undent
      Add the following lines to /etc/pf.conf to block entries in the sshguard
      table (replace $ext_if with your WAN interface):

        table <sshguard> persist
        block in quick on $ext_if proto tcp from <sshguard> to any port 22 label "ssh bruteforce"

      Then run sudo pfctl -f /etc/pf.conf to reload the rules.
      EOS
    end
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
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
        <string>#{opt_sbin}/sshguard</string>
        <string>-l</string>
        <string>#{log_path}</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/sshguard -v 2>&1", 64)
  end
end
