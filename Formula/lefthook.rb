class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "4873473f6a9dcbcb7ca756aa254b0bec8576435917a92be7d5081abf5a496065"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e42fb05f1b860f97770c2581005206fffca820936e7c1db66e875138eea0de24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ac5d609e3817a923cfc70295a399a024af4dacdbe340c49619f01a5f4b896bd"
    sha256 cellar: :any_skip_relocation, monterey:       "33b3efa300067a3317adecd2a32b0819aa50a893b228d8156dc242d9e60031cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "dce9b5d997e2543c0226e2855cced2778fea34a0454a86ba13e38bf27a0482bd"
    sha256 cellar: :any_skip_relocation, catalina:       "026c220ab4f8e98fc27be92035a170d004711e66e3e1335f6268fb3a659ac811"
    sha256 cellar: :any_skip_relocation, mojave:         "163adf2c067d85e44cce71682ce2f94421af706017bf8601cf4c88d262a67e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5d01af7de4480e289f5d132d0103610aa4c787e3bdf17ed892d2b860362dd4b"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
