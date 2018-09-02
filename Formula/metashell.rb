class Metashell < Formula
  desc "Metaprogramming shell for C++ templates"
  homepage "http://metashell.org"
  url "https://github.com/metashell/metashell/archive/v4.0.0.tar.gz"
  sha256 "02a88204fe36428cc6c74453059e8c399759d4306e8156d0920aefa4c07efc64"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "eea9e8e3467f067df5c18021e70d529fca81444b1b5a58987d585fea9c14e234" => :mojave
    sha256 "ea62126c211e42451b2272b250b877c2714c470a654d4d81dbf40a26c79fd4f0" => :high_sierra
    sha256 "b2ed4c805b490c689c9d2f8f8407b19a936a9d8bcc26b167d3a7727b1d503a5b" => :sierra
    sha256 "4d55dfb291e53beb8397f88d49121f8fb403c451a5f0eea05b819240449d740e" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11

    # Build internal Clang
    mkdir "3rd/templight/build" do
      system "cmake", "../llvm", "-DLLVM_ENABLE_TERMINFO=OFF", *std_cmake_args
      system "make", "templight"
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.hpp").write <<~EOS
      template <class T> struct add_const { using type = const T; };
      add_const<int>::type
    EOS
    output = pipe_output("#{bin}/metashell -H", "cat #{testpath}/test.hpp", 0)
    assert_match "const int", output
  end
end
