class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://dl.cihar.com/gammu/releases/gammu-1.37.3.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/gammu/gammu_1.37.3.orig.tar.xz"
  sha256 "63fcb78e94e1c8cff199cada3f64c694f49c1e9fe2c3f17495dc01a5e8e03a84"
  head "https://github.com/gammu/gammu.git"

  bottle do
    sha256 "d58b0d51e5994f6560376a05e2ccb66ffa0d14728ca6a305d5936bf83ecd2aa6" => :el_capitan
    sha256 "8b9c699089f4545d3c18a7bb30a408f06e3677bfbe4b216ee8db6a48677c425e" => :yosemite
    sha256 "9357d5c1785ec7670bb3e935b30d1ac5bc732ec0f5f9e20647f6a0b61a066e52" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "glib" => :recommended
  depends_on "gettext" => :optional
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBASH_COMPLETION_COMPLETIONSDIR:PATH=#{bash_completion}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"gammu", "--help"
  end
end
