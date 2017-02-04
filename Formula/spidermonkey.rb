class Spidermonkey < Formula
  desc "Mozilla's JavaScript engine, as used in Firefox"
  homepage "https://developer.mozilla.org/en/SpiderMonkey"
  url "https://archive.mozilla.org/pub/firefox/tinderbox-builds/mozilla-release-macosx64/1486087028/jsshell-mac.zip"
  version "1486087028"
  sha256 "68ade82a1f5840ef575af51cd25bfc09a623049e35cb51bf6f914269701b5d94"

  bottle do
    cellar :any
    sha256 "88b8192561c83cae0f18f137bd31e48610d6f562f08f1655f92d7195f7a1413d" => :sierra
    sha256 "10d5d50274782ac46f6466f5d2b6a446b6c334acedccd52e3337872dea597346" => :el_capitan
    sha256 "88b8192561c83cae0f18f137bd31e48610d6f562f08f1655f92d7195f7a1413d" => :yosemite
  end

  def install
    lib.install "libmozglue.dylib", "libnss3.dylib"
    bin.install "js" => "spidermonkey"
  end

  test do
    (testpath/"test.js").write("print('Hello!');\n")
    assert_equal "Hello!", shell_output("#{bin}/spidermonkey test.js").chomp
  end
end
