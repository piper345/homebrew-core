class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-2.1.0.tar.gz"
  sha256 "f7d74eecde0aed75bfc51ec48c91d01fe16a6bf16bce1987a7073286701e2fc6"
  license "BSD-3-Clause"
  revision 3
  head "https://ceres-solver.googlesource.com/ceres-solver.git", branch: "master"

  livecheck do
    url "http://ceres-solver.org/installation.html"
    regex(/href=.*?ceres-solver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "f12f93e7c94dd4d9e637e246e701ef1fafbaad3adb6c5a017bf215df3a8f8461"
    sha256 cellar: :any,                 arm64_monterey: "35728fcad03b676927e813b779b4a7c44f4e7d82324a9d593900e7abdf99774c"
    sha256 cellar: :any,                 arm64_big_sur:  "a4807a7e8aede0638d63fa82da0e826a404832d7932e162a3d39d9fefce73169"
    sha256 cellar: :any,                 ventura:        "51616e048c6c21b6268b3b7aed022a5c3b6b7c584e2a8aaae94a69a6f5ba8e8e"
    sha256 cellar: :any,                 monterey:       "ecefafa20520360cf5b2cf4322c64a6aa9b35eb22796fc1ad820b1ccc9e768d3"
    sha256 cellar: :any,                 big_sur:        "c1f640a30f86d2c7a3686904cadc11d398f841d3a455b044d29240e46777dbd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf7e9f108963e511e4c6b1a7597af01533934b9ea02ee6b82fc657172acb376c"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen"
  depends_on "gflags"
  depends_on "glog"
  depends_on "metis"
  depends_on "openblas"
  depends_on "suite-sparse"
  depends_on "tbb"

  fails_with gcc: "5" # C++17

  # Fix version detection for suite-sparse >= 6.0. Remove in next release.
  patch do
    url "https://github.com/ceres-solver/ceres-solver/commit/352b320ab1b5438a0838aea09cbbf07fa4ff5d71.patch?full_index=1"
    sha256 "0289adbea4cb66ccff57eeb844dd6d6736c37649b6ff329fed73cf0e9461fb53"
  end

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_EXAMPLES=OFF",
                    "-DLIB_SUFFIX=''"
    system "make"
    system "make", "install"
    pkgshare.install "examples", "data"
  end

  test do
    cp pkgshare/"examples/helloworld.cc", testpath
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(helloworld)
      find_package(Ceres REQUIRED COMPONENTS SuiteSparse)
      add_executable(helloworld helloworld.cc)
      target_link_libraries(helloworld Ceres::ceres)
    EOS

    system "cmake", "-DCeres_DIR=#{share}/Ceres", "."
    system "make"
    assert_match "CONVERGENCE", shell_output("./helloworld")
  end
end
