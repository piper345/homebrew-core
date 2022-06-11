require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.21.tgz"
  sha256 "f5aace4a8488ebfed2684102fb3c444392af47faae514f4c4b043a1511edab51"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b4736ee1a3f190e38e9d40cc6667594ca9aa436d26f3b4e089a01d0d1e15c81b"
  end

  # `bin/proxy/mac/Whistle` was only built for `x86_64`
  # upstream issue tracker, https://github.com/avwo/whistle/issues/734
  depends_on arch: :x86_64
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
