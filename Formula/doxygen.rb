class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "https://www.doxygen.org/"
  url "https://doxygen.nl/files/doxygen-1.9.4.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.9.4/doxygen-1.9.4.src.tar.gz"
  sha256 "a15e9cd8c0d02b7888bc8356eac200222ecff1defd32f3fe05257d81227b1f37"
  license "GPL-2.0-only"
  head "https://github.com/doxygen/doxygen.git", branch: "master"

  livecheck do
    url "https://www.doxygen.nl/download.html"
    regex(/href=.*?doxygen[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "368ece92d696d30bb2001c98381df8db30a648a1419373749fd4ae4a917abfff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "630d13f7ce33d9778d14c286ef8cdf6db8a3e4425687ce883dcd03432067559d"
    sha256 cellar: :any_skip_relocation, monterey:       "d9890c4d75eab2b74894783bb8fe683c4f6f189a2deb5ed3a67d2ac6e1ee1eef"
    sha256 cellar: :any_skip_relocation, big_sur:        "b56fa527820cfbc37d6d73a1a5608d4bf030be4280d01247e2f90aa76e467f7c"
    sha256 cellar: :any_skip_relocation, catalina:       "22b7ceee204ea77784f0f6a9ffeb0a4e46d816949cb7da247ad07c5690cebcf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c61f9db9a0389820b164418e0b4a8982ba22556a3a94dbba3f16b3d8b0c4010d"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  uses_from_macos "flex", since: :big_sur => :build
  uses_from_macos "python" => :build

  on_linux do
    depends_on "gcc"
  end

  # Need gcc>=7.2. See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66297
  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/doxygen", "-g"
    system "#{bin}/doxygen", "Doxyfile"
  end
end
