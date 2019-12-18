class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v1.8.0.tar.gz"
  sha256 "af644d2555c3852513135e87dc6f9bc8b5ee789a4f1c151f4478d108fa007c49"
  head "https://github.com/latex-lsp/texlab.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "654c2def92f4e7f3785bafd3ef25a7a46ff34573dc95628740c769fc355e86a8" => :catalina
    sha256 "4607882488fb7a90102d97d1198436cb13933e9e15b795a9ecd507cbf38ad94b" => :mojave
    sha256 "24fd12e3363319405f10cf385beec82ee15066dfc06ea178ce79a9917218c23e" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    require "open3"

    begin
      stdin, stdout, _, wait_thr = Open3.popen3("#{bin}/texlab")
      pid = wait_thr.pid
      stdin.write <<~EOF
        Content-Length: 103

        {"jsonrpc": "2.0", "id": 0, "method": "initialize", "params": { "rootUri": null, "capabilities": {}}}

      EOF
      assert_match "Content-Length: 543", stdout.gets("\n")
    ensure
      Process.kill "SIGKILL", pid
    end
  end
end
