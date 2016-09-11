class Planck < Formula
  desc "Stand-alone ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/1.17.tar.gz"
  sha256 "f088acecc25412f901b512478d9fd5acf38c1ff0276f18d45f78ad9a5ce37596"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ffbf5a9439d756896b01d09951d35c10ebc5db1eb711e4316d8e317f757435c" => :el_capitan
    sha256 "1b2944dc62383551126f4584e4b977644de642b3ed19dd2a7199b453c5935846" => :yosemite
    sha256 "446f24b245d33c54c8d5c2c4362c9d70091433500db72fd4f5f0954158e91586" => :mavericks
  end

  depends_on "leiningen" => :build
  depends_on :xcode => :build
  depends_on :macos => :mavericks

  def install
    system "./script/build-sandbox"
    bin.install "build/Release/planck"
  end

  test do
    system "#{bin}/planck", "-e", "(- 1 1)"
  end
end
