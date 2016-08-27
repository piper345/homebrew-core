class ThePlatinumSearcher < Formula
  desc "Multi-platform code-search similar to ack and ag"
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/v2.1.4.tar.gz"
  sha256 "92448712e2d5e6e5a6ec19c0a145d268ec0a96dea115237250c1ad4aaa8f81f7"
  head "https://github.com/monochromegane/the_platinum_searcher.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b869dd3e8f0bb6441c192f5354b0ba9276ab8d76cf56318b5e5739f1f7622735" => :el_capitan
    sha256 "17487b135f34dc5dd659dd88675a91027f03e95d7522acfb71b2700561230e74" => :yosemite
    sha256 "78b98b1cedce81d3b508c7f00aa4c6b475f1a1c51989426f9298c48f5fb679d3" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/monochromegane/the_platinum_searcher"
    dir.install buildpath.children
    cd dir do
      system "godep", "restore"
      system "go", "build", "-o", bin/"pt", ".../pt"
      prefix.install_metafiles
    end
  end

  test do
    path = testpath/"hello_world.txt"
    path.write "Hello World!"

    lines = `#{bin}/pt 'Hello World!' #{path}`.strip.split(":")
    assert_equal "Hello World!", lines[2]
  end
end
