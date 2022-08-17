require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.5.tgz"
  sha256 "0b4b001d3138375f4e5891fbc2ab24dce55d5d990479cba41132b74ff0b6f4a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2737b0ae321f75ce189f12763dcb75945d30405f2c45aaf7c4339bc9282ebef5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2737b0ae321f75ce189f12763dcb75945d30405f2c45aaf7c4339bc9282ebef5"
    sha256 cellar: :any_skip_relocation, monterey:       "53d16f0824bd349919de0061aa338c291ac9cacf0ff76707f49e418fed75016d"
    sha256 cellar: :any_skip_relocation, big_sur:        "53d16f0824bd349919de0061aa338c291ac9cacf0ff76707f49e418fed75016d"
    sha256 cellar: :any_skip_relocation, catalina:       "53d16f0824bd349919de0061aa338c291ac9cacf0ff76707f49e418fed75016d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02a03acc3185731577ec4819d462717f9dcbf8451de89f0013c2c5ab092ac2c0"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"app.jsx").write <<~EOS
      import * as React from 'react'
      import * as Server from 'react-dom/server'

      let Greet = () => <h1>Hello, world!</h1>
      console.log(Server.renderToString(<Greet />))
    EOS

    system Formula["node"].libexec/"bin/npm", "install", "react", "react-dom"
    system bin/"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1>Hello, world!</h1>\n", shell_output("node out.js")
  end
end
