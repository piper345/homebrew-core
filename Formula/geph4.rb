class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.7.4.tar.gz"
  sha256 "362cf745bdf6fb961b1266e4f2122d6522822c62969975dafd0cfafbe8a455cf"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5710c61f0008dd2482e7cd396a76b71aa3e9d660d8534f5595e8e71e096da19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "553b74f2b12097213ef04dc4bd86e8b31896b11e997c04e60b5134f4ba5abfe4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "625aecf3ab5a2f2bbbe3303772b4e4fa0484c0e6bf32818a643bc7b2c44f0319"
    sha256 cellar: :any_skip_relocation, ventura:        "8615f1a9537f023ae328783ea63af964c34741dc120cb46d3d08cdebb8f5113f"
    sha256 cellar: :any_skip_relocation, monterey:       "6b76ed4d55f09306787c3df2b55f367762fda645ff142ad42465e5ad4edc7aad"
    sha256 cellar: :any_skip_relocation, big_sur:        "805e77d15f539f693ccdbdcbe8a2b16ea0b898d74e7b39d71f3961455b97b3ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "205a7bf1d5a6b3855364aa8a379694a92690aad060bc55bd866ef18c47a2239d"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid username or password",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
