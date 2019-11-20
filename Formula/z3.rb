class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.8.7.tar.gz"
  sha256 "8c1c49a1eccf5d8b952dadadba3552b0eac67482b8a29eaad62aa7343a0732c3"
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    sha256 "77e5760f19f5acdf3b73adebdf1e93ad00d5bc43d695a0565728ca8e6aa02b70" => :catalina
    sha256 "0c71a481c7232c4c93e4a28e85271959a7ec2fe4ff88f4245936bdf5dff5c389" => :mojave
    sha256 "5999876e4ae35a590879c8f7caeace02aacc4fe77eb58819443dd2fb05aff495" => :high_sierra
    sha256 "e08003ed5ac98409f7d9c0f6fbe2bd483d202079db5233ddbca53e3182a6108a" => :sierra
  end

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    system "python3", "scripts/mk_make.py",
                      "--prefix=#{prefix}",
                      "--python",
                      "--pypkgdir=#{lib}/python#{xy}/site-packages",
                      "--staticlib"

    cd "build" do
      system "make"
      system "make", "install"
    end

    system "make", "-C", "contrib/qprofdiff"
    bin.install "contrib/qprofdiff/qprofdiff"

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lz3",
           pkgshare/"examples/c/test_capi.c", "-o", testpath/"test"
    system "./test"
  end
end
