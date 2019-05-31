class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://github.com/CCExtractor/ccextractor/archive/v0.88.tar.gz"
  sha256 "e0bfad4c7cf5d8a05305107ab53829a33b209446aaec515d5c51b72392b1eda7"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d08337e5455f14055cc355013190441bbf0238c19d0d2b1669d86a973a9f8fc1" => :mojave
    sha256 "44c4b3599f3e4f9ca362473751b6cd040d0a06b32f2a22e2087f22413ff6e45b" => :high_sierra
    sha256 "8d5bbddf6f2f173e1e65dab7b43ae70987938ef6b255f7d61d99cb9427357e2a" => :sierra
  end

  def install
    cd "mac" do
      system "./build.command"
      bin.install "ccextractor"
    end
    (pkgshare/"examples").install "docs/ccextractor.cnf.sample"
  end

  test do
    touch testpath/"test"
    pid = fork do
      exec bin/"ccextractor", testpath/"test"
    end
    Process.wait(pid)
    assert_predicate testpath/"test.srt", :exist?
  end
end
