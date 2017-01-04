class GitSubrepo < Formula
  desc "Git Submodule Alternative"
  homepage "https://github.com/ingydotnet/git-subrepo"
  url "https://github.com/ingydotnet/git-subrepo/archive/0.3.1.tar.gz"
  sha256 "f36fb9e6ccb82b1200ba94c2b9c1db7fb683d93d2051ac92ab69c049f2529906"
  head "https://github.com/ingydotnet/git-subrepo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c21b30078673bd581298b904ea627c84eb39c611c5558d9e920184d63698f69" => :sierra
    sha256 "e42d73137d06bc594ac917e7e8fc35810083461c26d541eed49e0a459dc31e21" => :el_capitan
    sha256 "f1415cb1ec64de2a854511c5a5aed5b4574222e4c2b795f3c1603011c661a24b" => :yosemite
    sha256 "a818994ecab1ca578f715dff0d7bb11018e1e724d98d4bb21234e2575210fca8" => :mavericks
  end

  def install
    libexec.mkpath
    system "make", "PREFIX=#{prefix}", "INSTALL_LIB=#{libexec}", "install"
    bin.install_symlink libexec/"git-subrepo"
  end

  test do
    mkdir "mod" do
      system "git", "init"
      touch "HELLO"
      system "git", "add", "HELLO"
      system "git", "commit", "-m", "testing"
    end

    mkdir "container" do
      system "git", "init"
      touch ".gitignore"
      system "git", "add", ".gitignore"
      system "git", "commit", "-m", "testing"

      assert_match(/cloned into/,
                   shell_output("git subrepo clone ../mod mod"))
    end
  end
end
