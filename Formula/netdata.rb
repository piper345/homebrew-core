class Netdata < Formula
  desc "Distributed real-time performance and health monitoring"
  homepage "https://my-netdata.io/"
  url "https://github.com/firehol/netdata/releases/download/v1.10.0/netdata-1.10.0.tar.bz2"
  sha256 "70cb42277427b79689f12f3d98b91b500232f8d8a4ad37ee109551352674dd9b"

  bottle do
    sha256 "58d29b1b9eaa31f75e4f5f90f16710bbec2090059d63b153ab64bfa511319dc0" => :high_sierra
    sha256 "2ba70429fb0a799d9307dd286a04daa4556f3c392f8832b01d027ef5b6d6d70e" => :sierra
    sha256 "9459d637edfd39c482e3989ab9f7aa83a1020ce5e09025c5f4c16b477e46ef7e" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "ossp-uuid"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"

    (etc/"netdata").install "system/netdata.conf"
  end

  def post_install
    config = etc/"netdata/netdata.conf"
    inreplace config do |s|
      s.gsub!(/web files owner = .*/, "web files owner = #{ENV["USER"]}")
      s.gsub!(/web files group = .*/, "web files group = #{Etc.getgrgid(prefix.stat.gid).name}")
    end
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/sbin/netdata -D"

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
            <string>#{opt_sbin}/netdata</string>
            <string>-D</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{sbin}/netdata", "-W", "set", "registry", "netdata unique id file",
                              "#{testpath}/netdata.unittest.unique.id",
                              "-W", "unittest"
  end
end
