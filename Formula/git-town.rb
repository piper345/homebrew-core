class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v4.1.2.tar.gz"
  sha256 "0f1b443196b33abf67ea103336213dbbe2df4d0ed384b66b610f95c6d6dd17bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "cfc049c4d6e5a844f5b4ef2eab97be4ea08ae402e617ac89a9c290523f791fbd" => :sierra
    sha256 "0c22c17fd403f631aaa4232c9d3704e31784fd3cdfabf714a7973f5d4c3693da" => :el_capitan
  end

  depends_on "go" => :build
  depends_on :macos => :el_capitan

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Originate").mkpath
    ln_sf buildpath, buildpath/"src/github.com/Originate/git-town"
    system "go", "build", "-o", bin/"git-town"
  end

  test do
    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system "#{bin}/git-town", "config"
  end
end
