class Todolist < Formula
  desc "Very fast, simple task manager for the command-line, based upon GTD."
  homepage "http://todolist.site"
  url "https://github.com/gammons/todolist/archive/0.8.tar.gz"
  sha256 "3c70dfb5e331cc636bd22fc686223faa34459a1b5e18d6b53557a14dff7a2b23"

  bottle do
    cellar :any_skip_relocation
    sha256 "22269a2051b13030b25761b5598d66f18746df836b3096929e5ccf3cba79d6be" => :high_sierra
    sha256 "ce52f46de9c0a6199b8e249b81a2b7e4c721af584b6c3b9da940752d3dc6a0b2" => :sierra
    sha256 "ad92cc8acf856f2a608f2d34e93987a6dd56d7cf8b670687a327d385a3f5fcb5" => :el_capitan
    sha256 "5feccfa0c2443dba0c8cbbd42bf8cec23211e77a7661dccf663d00b92399ebe3" => :yosemite
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gammons/").mkpath
    ln_s buildpath, buildpath/"src/github.com/gammons/todolist"
    system "go", "build", "-o", bin/"todolist", "./src/github.com/gammons/todolist"
  end

  test do
    system bin/"todolist", "init"
    assert File.exist?(".todos.json")
    add_task = shell_output("#{bin}/todolist add learn the Tango")
    assert_match /Todo.* added/, add_task
  end
end
