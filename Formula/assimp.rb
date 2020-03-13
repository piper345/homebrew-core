class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/v5.0.1.tar.gz"
  sha256 "11310ec1f2ad2cd46b95ba88faca8f7aaa1efe9aa12605c55e3de2b977b3dbfc"
  head "https://github.com/assimp/assimp.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7fc14753e0951463527bfab2d38c9199cb7d3efaaa2a8d6246583de960bfbf97" => :catalina
    sha256 "449e06fa758f12eb91d6c2450c8d362ac4fb453cd9bce0e29117e4494d1cb58c" => :mojave
    sha256 "0e3ca738fcea750f3b19ec379670483c046accd8be44cd541efc95825589bbde" => :high_sierra
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  # Fix "unzip.c:150:11: error: unknown type name 'z_crc_t'"
  # Upstream PR from 12 Dec 2017 "unzip: fix build with older zlib"
  if MacOS.version <= :el_capitan
    patch do
      url "https://github.com/assimp/assimp/pull/1634.patch?full_index=1"
      sha256 "79b93f785ee141dc2f56d557b2b8ee290eed0afc7dd373ad84715c6c9aa23460"
    end
  end

  def install
    args = std_cmake_args
    args << "-DASSIMP_BUILD_TESTS=OFF"
    system "cmake", *args
    system "make", "install"
  end

  test do
    # Library test.
    (testpath/"test.cpp").write <<~EOS
      #include <assimp/Importer.hpp>
      int main() {
        Assimp::Importer importer;
        return 0;
      }
    EOS
    system ENV.cc, "-std=c++11", "test.cpp", "-L#{lib}", "-lassimp", "-o", "test"
    system "./test"

    # Application test.
    (testpath/"test.obj").write <<~EOS
      # WaveFront .obj file - a single square based pyramid

      # Start a new group:
      g MySquareBasedPyramid

      # List of vertices:
      # Front left
      v -0.5 0 0.5
      # Front right
      v 0.5 0 0.5
      # Back right
      v 0.5 0 -0.5
      # Back left
      v -0.5 0 -0.5
      # Top point (top of pyramid).
      v 0 1 0

      # List of faces:
      # Square base (note: normals are placed anti-clockwise).
      f 4 3 2 1
      # Triangle on front
      f 1 2 5
      # Triangle on back
      f 3 4 5
      # Triangle on left side
      f 4 1 5
      # Triangle on right side
      f 2 3 5
    EOS
    system bin/"assimp", "export", "test.obj", "test.ply"
  end
end
