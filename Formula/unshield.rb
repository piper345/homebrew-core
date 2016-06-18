class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/1.3.tar.gz"
  sha256 "31a49c43b60e86b3ed731e0a1b988b88d35b755c85d103e93e1507278328bf73"

  bottle do
    cellar :any
    revision 1
    sha256 "d748ddbd90b120251f5a87099d3a8b108a04a749a3ebbf0c98403b2acc294437" => :el_capitan
    sha256 "d12fdb3e2bd24a0944c1d5f23729c29ded8b2f9b88c63f673f099755cef5a701" => :yosemite
    sha256 "7a81e99c54047df0c0746f7ecfe9778cea2c949589fc16df7aeda8f550c2cd04" => :mavericks
  end

  head do
    url "https://github.com/twogood/unshield.git"

    # Fix compilation on OS X
    patch do
      url "https://github.com/twogood/unshield/pull/47.patch"
      sha256 "3b37bdac497a9113e576c2ddc042b978ce15758ef8158e3f495f819f92dad531"
    end
  end

  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unshield -V")
  end
end
