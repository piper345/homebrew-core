class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark"
  url "https://github.com/github/cmark/archive/0.27.1.gfm.3.tar.gz"
  version "0.27.1.gfm.3"
  sha256 "928d3c548267106b59f7a3dfad82489cfb9ce8a17551d8c0c0b44c291923a3bd"

  bottle do
    cellar :any
    sha256 "61cb87933dfb822df9757d1c6ac371ef35d76ab137a1e61c4f56f0fe6eb07017" => :sierra
    sha256 "203c0c7782c3255997ad9e7cafc197aee51037d0d91066c76d34f3471afa2ed2" => :el_capitan
    sha256 "bd491385abaabc348cb20de6b805240224dfacf4af621d7c4d99937029219bc6" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :python3 => :build

  conflicts_with "cmark", :because => "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
