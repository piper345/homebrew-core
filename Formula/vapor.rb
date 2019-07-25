class Vapor < Formula
  desc "Vapor Toolbox"
  homepage "https://vapor.codes"
  head "https://github.com/vapor/toolbox.git"
  depends_on :xcode => "11"
  depends_on "openssl"

  stable do
    version "18.0.0-beta.17"
    url "https://github.com/vapor/toolbox/archive/18.0.0-beta.17.tar.gz"
    sha256 "202208026843dbf68ec54a13fe08db1c41d3d39e8c060fdbb723f192b88ecd8d"
  end
  bottle do
    cellar :any
    sha256 "ac691641bd97f761f6022aa7987a35ec9c0f5662146f28b39a434de616860f78" => :mojave
    sha256 "0ec0e6297c1f3d71ba133a0cff5a5819015002ac8246664e1abf9a021a6cb3d7" => :high_sierra
  end


  def install
    system "swift", "build", "--disable-sandbox"
    system "mv", ".build/debug/Executable", "vapor"
    bin.install "vapor"
  end
end
