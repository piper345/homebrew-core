class HowardHinnantDate < Formula
  desc "C++ library for date and time operations based on <chrono>"
  homepage "https://github.com/HowardHinnant/date"
  url "https://github.com/HowardHinnant/date/archive/v2.4.1.tar.gz"
  sha256 "98907d243397483bd7ad889bf6c66746db0d7d2a39cc9aacc041834c40b65b98"

  bottle do
    cellar :any
    rebuild 1
    sha256 "daf996aeb4bde8049e845560ae07eb57ce240e005f8699bedf805a610eec0d6d" => :high_sierra
    sha256 "60022a316b39f4452992afa69e1d56fa8bea5488937556a2ce4933dc2f5c44e3" => :sierra
    sha256 "77ecfb7185934e6174330ce94639f72fac06797fe625574e92bf04a2cd499511" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    system "cmake", ".", *std_cmake_args,
                         "-DENABLE_DATE_TESTING=OFF",
                         "-DUSE_SYSTEM_TZ_DB=ON",
                         "-DBUILD_SHARED_LIBS=ON"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "date/tz.h"
      #include <iostream>

      int main() {
        auto t = date::make_zoned(date::current_zone(), std::chrono::system_clock::now());
        std::cout << t << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-ltz", "-o", "test"
    system "./test"
  end
end
