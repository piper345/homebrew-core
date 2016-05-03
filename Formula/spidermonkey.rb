class Spidermonkey < Formula
  desc "JavaScript-C Engine"
  homepage "https://developer.mozilla.org/en/SpiderMonkey"
  url "https://people.mozilla.org/~sstangl/mozjs-38.2.1.rc0.tar.bz2"
  version "38.2.1"
  sha256 "01994c758174bc173bcf4960f05ecb4da21014f09641a63b2952bbf9eeaa8b5c"

  head "https://hg.mozilla.org/tracemonkey/archive/tip.tar.gz"

  bottle do
    cellar :any
    sha256 "9716e976a148be0e0feb924844351a69346425e435936a5bb9b72481bf2b5693" => :el_capitan
    sha256 "57693a53db2b5608ff2bc27557d2361d12a06a8a30c7d0e0f1e881bb57b33c0b" => :yosemite
    sha256 "43a8bd8b7f794b895bc323d8f53099e9c1024d7a3544e9ee8ca76a618b48875b" => :mavericks
  end

  conflicts_with "narwhal", :because => "both install a js binary"

  depends_on "readline"
  depends_on "nspr"

  def install
    mkdir "brew-build" do
      # Configure needs python to figure out which version of libmozjs it is
      # building.
      ENV["PYTHON"] = which "python"
      system "../js/src/configure", "--prefix=#{prefix}",
                                    "--enable-dtrace",
                                    "--enable-readline",
                                    "--enable-threadsafe",
                                    "--with-system-nspr",
                                    "--with-nspr-prefix=#{Formula["nspr"].opt_prefix}",
                                    "--enable-macos-target=#{MacOS.version}"

      # These need to be in separate steps.
      system "make"
      system "make", "install", "STATIC_LIBRARY_NAME=js_static"

      # Also install js REPL.
      bin.install "js/src/shell/js"
    end
  end

  test do
    path = testpath/"test.js"
    path.write "print('hello');"
    assert_equal "hello", shell_output("#{bin}/js #{path}").strip
  end
end
