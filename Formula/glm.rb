class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "https://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/releases/download/0.9.9.1/glm-0.9.9.1.zip"
  sha256 "10f1471d69ec09992f400705bedc9f5121e17a2c8fd6f9591244bb5ee1104a10"
  head "https://github.com/g-truc/glm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a24df7dfbff0609223550b7e6a712162dc74aa9c91f6c9c8af14ccffc1ba0660" => :mojave
    sha256 "39dd1a7f073bc7ea2da8133c6ccac3050fc250218e552bb6848bc4c64d99cfbc" => :high_sierra
    sha256 "39dd1a7f073bc7ea2da8133c6ccac3050fc250218e552bb6848bc4c64d99cfbc" => :sierra
    sha256 "39dd1a7f073bc7ea2da8133c6ccac3050fc250218e552bb6848bc4c64d99cfbc" => :el_capitan
  end

  option "with-doxygen", "Build documentation"
  depends_on "doxygen" => [:build, :optional]
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

    if build.with? "doxygen"
      cd "doc" do
        system "doxygen", "man.doxy"
        man.install "html"
      end
    end
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glm/vec2.hpp>// glm::vec2
      int main()
      {
        std::size_t const VertexCount = 4;
        std::size_t const PositionSizeF32 = VertexCount * sizeof(glm::vec2);
        glm::vec2 const PositionDataF32[VertexCount] =
        {
          glm::vec2(-1.0f,-1.0f),
          glm::vec2( 1.0f,-1.0f),
          glm::vec2( 1.0f, 1.0f),
          glm::vec2(-1.0f, 1.0f)
        };
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end
