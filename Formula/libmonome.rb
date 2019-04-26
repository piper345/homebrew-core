class Libmonome < Formula
  desc "Interact with monome devices via C, Python, or FFI"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/v1.4.2.tar.gz"
  sha256 "d8f87fc8240214c2ca433f4b185eb3ddbace2065f95487e5d9ac0ab60220393d"
  revision 1
  head "https://github.com/monome/libmonome.git"

  bottle do
    cellar :any
    sha256 "612905a8a5c7b0018035e37c3e47fb97401a9ee8e9956acafedd868ea9e27566" => :mojave
    sha256 "28fc0f51edbe3c08831b6258da5501a18ebcf7f1920eb3221380e05283a140d4" => :high_sierra
    sha256 "146b9d93265fdf1fe4ab555b7ff452720df451d52865fba0516a9932be13fa34" => :sierra
  end

  depends_on "liblo"

  def install
    # Fix build on Mojave
    # https://github.com/monome/libmonome/issues/62
    inreplace "wscript", /conf.env.append_unique.*-mmacosx-version-min=10.5.*/,
                         "pass"

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end
end
