class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.0.0/fonttools-4.0.0.zip"
  sha256 "9415fda795f4ff8e89d41ab907388ec5a4c236f4774ea65a746d8c1e4e839d3d"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "96a2ad62225e22085a8d6aae66ed2c521a1daccf55077377f92affade0dc055f" => :mojave
    sha256 "58e495912e99ec2ee46c255f9dcc1c8566a20944b4072ba0712afae75c0f55f3" => :high_sierra
    sha256 "15bbb1e78f0513a42047bbad11b66330cc5227a44180b73b29d2135e9cda1906" => :sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
