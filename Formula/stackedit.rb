require "language/node"

class Stackedit < Formula
  desc "In-browser markdown editor"
  homepage "https://github.com/benweet/stackedit"
  url "https://github.com/benweet/stackedit/archive/v4.3.14.tar.gz"
  sha256 "00e70998d4f7c56d9f96935b1c373b9d85b26b4004cae60296548be4448fdce6"

  bottle do
    cellar :any_skip_relocation
    sha256 "c515c3d39fee3e6a40f2f6c37e15ce5df9c04ae3cd6f4ddb8ad6d0e17bb6f842" => :sierra
    sha256 "72b2fdafed716eef3e209d20cba5df023f8c31f8d75b86baf7f52f6b488e9ebf" => :el_capitan
    sha256 "dc53c756c3397790177ea692aab8871192ed9c67d2092a234044641393930287" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    libexec.install Dir["*"]
    (bin/"stackedit").write <<-EOS.undent
      #!/bin/sh
      export STACKEDIT_BIN="#{bin}/stackedit"
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/lib/node_modules/stackedit/server.js" "$@"
    EOS
  end

  plist_options :manual => "stackedit"

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
        <false/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/stackedit</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/stackedit.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/stackedit.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    pid = fork do
      exec "#{bin}/stackedit"
    end
    sleep 5
    begin
      assert_match %r{HTTP/1.1 200 OK}, shell_output("curl -I localhost:3000/")
    ensure
      Process.kill("SIGKILL", pid)
      Process.wait(pid)
    end
  end
end
