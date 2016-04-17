class GitSecrets < Formula
  desc "Prevents you from committing sensitive information to a git repo"
  homepage "https://github.com/awslabs/git-secrets"
  url "https://github.com/awslabs/git-secrets/archive/1.1.0.tar.gz"
  sha256 "30c6a51851487776bc976792c7dd472725c878c2e92710c898afbcc33cd02cbb"

  head "https://github.com/awslabs/git-secrets.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6abde5153f03906e0b055a356813aea27e358ac7d4f504af6af2a39433001f6" => :el_capitan
    sha256 "f7c7f71e359fce6ee76ff734f88e6520f3d09f13aa5ba40ff76c80c3e72f98af" => :yosemite
    sha256 "c482df635611c73d9962a4bd85b9575a0d49223e26f678c66b5b4a00810fbec8" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "git", "init"
    system "git", "secrets", "--install"
  end
end
