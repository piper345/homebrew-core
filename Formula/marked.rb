require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.3.tgz"
  sha256 "f82e30aa816c6feab0698febbab73806b96012bbd7acee2ac290caab4a33f84e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "45b5e582505b94426abe2f03e7c4801c395435df963d7ad05fb69dcb82ff05b9"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end
