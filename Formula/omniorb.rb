class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.3.0/omniORB-4.3.0.tar.bz2"
  sha256 "976045a2341f4e9a85068b21f4bd928993292933eeecefea372db09e0219eadd"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "0e05e6e0d23e598d7b23e89ddb58230369933dee00d389c56f56777e396c1687"
    sha256 cellar: :any,                 arm64_big_sur:  "1de446edfd905f9d455fc68bd4ea4e645ad5d1458f9f6011a29076f2737b0084"
    sha256 cellar: :any,                 monterey:       "a3deb94051db3a410b6035a3ea14b72df42e5ba9a9e37f34b7a3fcca8c484e5c"
    sha256 cellar: :any,                 big_sur:        "18881ad0bf3a710e26a80c40fe35175c6affbbeb41f237b234d1529be7bd6300"
    sha256 cellar: :any,                 catalina:       "07d60469609804fa434497a100bbbf22a24e3473ffd18931524eee975530fdff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a297fb5833f049ad78e4c613c51a6077fea5ebf153b2014790d2d2edf891f31"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10"

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.3.0/omniORBpy-4.3.0.tar.bz2"
    sha256 "fffcfdfc34fd6e2fcc45d803d7d5db5bd4d188a747ff9f82b3684a753e001b4d"
  end

  def install
    ENV["PYTHON"] = python = which("python3")
    # TODO: Remove when configure correctly parses Python 3.10+ version
    ENV["am_cv_python_version"] = Language::Python.major_minor_version python

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    resource("bindings").stage do
      system "./configure", "--prefix=#{prefix}"
      ENV.deparallelize # omnipy.cc:392:44: error: use of undeclared identifier 'OMNIORBPY_DIST_DATE'
      system "make", "install"
    end
  end

  test do
    system "#{bin}/omniidl", "-h"
    system "#{bin}/omniidl", "-bcxx", "-u"
    system "#{bin}/omniidl", "-bpython", "-u"
  end
end
