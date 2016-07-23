class Steem < Formula
  desc "Proof of Work blockchain with an unproven consensus algorithm."
  homepage "https://steemit.com/"
  url "https://github.com/steemit/steem.git",
      :tag => "v0.12.1",
      :revision => "0cca4bcd8212aed662a5aba4e35a5b75be3dcb1a"

  depends_on :macos => [:yosemite, :el_capitan, :sierra]

  depends_on "cmake" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :python3 => :build
  depends_on "doxygen" => :build
  depends_on "berkeley-db" => :optional
  depends_on "gperftools" => :optional
  depends_on "qt5" => :optional
  depends_on "icu4c"
  depends_on "boost"
  depends_on "openssl"
  depends_on "readline"

  def install
    cmake_args = %W[
      CMakeLists.txt
      -DLOW_MEMORY_NODE=ON
    ]

    cmake_args << "-DENABLE_CONTENT_PATCHING=OFF" if build.without? "qt5"

    system "cmake", *(cmake_args + std_cmake_args)
    system "make", "install"
  end

  test do
    system "#{bin}/steemd", "-h"
  end
end
