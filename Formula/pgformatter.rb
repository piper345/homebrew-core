class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://github.com/darold/pgFormatter/archive/v1.6.tar.gz"
  sha256 "a389d1a848fab553dbaa5648b6eb78a70a98ae59e26338183b1eb826c40566da"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c1ae9b379d82e5270978d9bae77674136701ae78eb007a9439aea78aaafdf6c" => :sierra
    sha256 "221f601d5cd69d05c733c9a95654707e231f726ac08f9c4b3faabd38531df3c0" => :el_capitan
    sha256 "2747addee67d2055fee10de760e7c6af4debf119978c63651b3d718b34b9d144" => :yosemite
    sha256 "160b6d71ed83367689e069145d255bbcf9a2f136da48be1278c2969e4b56b5a9" => :mavericks
  end

  def install
    # Fix path to Perl modules. Per default, the script expects to
    # find them in a lib directory beneath it's own path.
    inreplace "pg_format", "$FindBin::Bin/lib", libexec

    system "perl", "Makefile.PL", "DESTDIR=."
    system "make", "install"

    bin.install "blib/script/pg_format"
    libexec.install "blib/lib/pgFormatter"
    man1.install "blib/man1/pg_format.1"
    man3.install "blib/man3/pgFormatter::Beautify.3pm"
    man3.install "blib/man3/pgFormatter::CGI.3pm"
    man3.install "blib/man3/pgFormatter::CLI.3pm"
  end

  test do
    test_file = (testpath/"test.sql")
    test_file.write("SELECT * FROM foo")
    system "#{bin}/pg_format", test_file
  end
end
