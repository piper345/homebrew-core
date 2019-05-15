class Mpdscribble < Formula
  desc "Last.fm reporting client for mpd"
  homepage "https://www.musicpd.org/clients/mpdscribble/"
  url "https://www.musicpd.org/download/mpdscribble/0.22/mpdscribble-0.22.tar.gz"
  sha256 "ff882d02bd830bdcbccfe3c3c9b0d32f4f98d9becdb68dc3135f7480465f1e38"
  revision 1

  bottle do
    rebuild 1
    sha256 "4f53420725b1988d9d16bb9e24b4e5edfb033f6ac0df32f5dd2f5585eb1e2c16" => :mojave
    sha256 "d3b6cfa4eb897ed5e7888733f94959bc07a35c44278639a3e6842913a1edbf0e" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libmpdclient"

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
  end

  def caveats; <<~EOS
    The configuration file was placed in #{etc}/mpdscribble.conf
  EOS
  end

  plist_options :manual => "mpdscribble"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/mpdscribble</string>
            <string>--no-daemon</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/mpdscribble", "--version"
  end
end
