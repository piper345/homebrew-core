class Xcbuild < Formula
  desc "Xcode-compatible build tool"
  homepage "https://github.com/facebook/xcbuild"
  url "https://github.com/facebook/xcbuild.git", :tag => "0.1.0", :revision => "08575f65f1c907e280ed4663b5461b7cfaf5cfaa"
  head "https://github.com/facebook/xcbuild.git", :shallow => false

  depends_on "ninja" => :recommended
  depends_on "cmake"
  depends_on "libpng"
  depends_on "pkg-config"

  def install
    system "make", "install", "cmake_flags=-DCMAKE_INSTALL_PREFIX=#{bin}"
  end

  test do
    system "#{bin}/xcbuild", "-showsdks"
  end
end
