class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.0.1.tar.xz"
  sha256 "4a93264ad0cda7ea2252d1ba057e474722f77848165f2893e0c76e21ae406415"
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git"

  bottle do
    rebuild 1
    sha256 "f5f6c40bd0aca777361059a501fc30a1d8485bd9e9735acdb6ab0f5ee056860b" => :catalina
    sha256 "ce9df928898820cb0e9af1115d1064307fc2a41a39029b924ee063e0cbd5945b" => :mojave
    sha256 "7160763c1178ddcb9d44a4c062d75c816e7607abaf2569915757afcc7b8d8d7a" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "knot"
  depends_on "libuv"
  depends_on "lmdb"
  depends_on "luajit"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "--default-library=static", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  # DNSSEC root anchor published by IANA (https://www.iana.org/dnssec/files)
  def root_keys
    <<~EOS
      . IN DS 20326 8 2 e06d44b80b8f1d39a95c0b0d7c65d08458e880409bbc683457104237c7f8ec8d
    EOS
  end

  plist_options :startup => true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WorkingDirectory</key>
        <string>#{var}/kresd</string>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/kresd</string>
          <string>-c</string>
          <string>#{etc}/kresd/config</string>
          <string>-f</string>
          <string>1</string>
        </array>
        <key>StandardInPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/kresd.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    system sbin/"kresd", "--version"
  end
end
