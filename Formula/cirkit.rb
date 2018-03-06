class Cirkit < Formula
  desc "Logic synthesis toolkit"
  homepage "https://msoeken.github.io/cirkit.html"
  url "https://github.com/msoeken/cirkit", :using => :git, :branch => :develop, :revision => "9a097c9a23d050b2c84a7c1c6a874859a6475ba6"
  version "2.4b15"

  head "https://github.com/msoeken/cirkit", :using => :git, :branch => :develop

  bottle do
    cellar :any
    sha256 "e5da8d0c100c777e26e2ff4ce7a1aeba2c7ee634467c57d40fc3f56ec28c0923" => :high_sierra
    sha256 "3e6dfb543ca9b030d4f46b814c3397b418a3b1401902fc09a8e9e113b9d3f745" => :sierra
    sha256 "e19a7dd5393caac1cb533a1eb583ca3e167bcabe9c3197305d28376956b602a6" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gmp"
  depends_on "readline"

  depends_on "python" => :optional

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_TESTING=OFF"
      system "make"
      system "make", "install"

      Language::Python.each_python(build) do |_, version|
        system "cmake", "..", "-Dcirkit_ENABLE_PYTHON_API=ON", "-DCMAKE_PYTHON_SITE_PATH=#{lib}/python#{version}/site-packages", "-DPYBIND11_PYTHON_VERSION=#{version}"
        system "make"
        system "make", "install"
      end
    end
  end

  test do
    system "#{bin}/cirkit", "-c", "help; quit"
  end
end
