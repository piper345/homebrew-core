class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2018.11.05.00.tar.gz"
  sha256 "3714ba8e50583b782d0e4f0dca60d9c0412d870effb151713f3ed3b17b21c8e4"
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "ed98c19ccbf5956a28fcba99375777ebbab9ed11f477366d7d65a7727290985d" => :mojave
    sha256 "cdf37081cfd80d16b9f309bcfbb6a1ede0c06fe6e298c5ba54a15ea18e81d5de" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "lz4"

  # https://github.com/facebook/folly/issues/451
  depends_on :macos => :el_capitan

  depends_on "openssl"
  depends_on "snappy"
  depends_on "xz"

  # Known issue upstream. They're working on it:
  # https://github.com/facebook/folly/pull/445
  fails_with :gcc => "6"

  needs :cxx11

  def install
    ENV.cxx11

    mkdir "_build" do
      args = std_cmake_args + %w[
        -DFOLLY_USE_JEMALLOC=OFF
      ]

      # Upstream issue 10 Jun 2018 "Build fails on macOS Sierra"
      # See https://github.com/facebook/folly/issues/864
      args << "-DCOMPILER_HAS_F_ALIGNED_NEW=OFF" if MacOS.version == :sierra

      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=ON"
      system "make"
      system "make", "install"

      system "make", "clean"
      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=OFF"
      system "make"
      lib.install "libfolly.a", "folly/libfollybenchmark.a"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
