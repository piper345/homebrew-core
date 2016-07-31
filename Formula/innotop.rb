class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/v1.11.1.tar.gz"
  sha256 "c93a4fb496ce1749aaaf0a70f0899ed1fa1aa5cd231208b6b3424285c77dc1b7"
  revision 1

  head "https://github.com/innotop/innotop.git"

  bottle do
    cellar :any
    sha256 "3aa3a88202b6179db9c719a4c173dad504cc35aa3c27b9746623116e3bdb4e16" => :el_capitan
    sha256 "1325fd9a98fe92025af333d6277465852dad735d081977e66ec196f7abb319ef" => :yosemite
    sha256 "74db5fd6cbf7abdf7ee663cf7f77ae872380932d78a2021e6a33f1bc37d98df6" => :mavericks
  end

  depends_on :mysql
  depends_on "openssl"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/M/MI/MICHIELB/DBD-mysql-4.035.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MI/MICHIELB/DBD-mysql-4.035.tar.gz"
    sha256 "b7eca365ea16bcf4c96c2fc0221304ff9c4995e7a551886837804a8f66b61937"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resource("DBD::mysql").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "install"
    share.install prefix/"man"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    # Calling commands throws up interactive GUI, which is a pain.
    assert_match version.to_s, shell_output("#{bin}/innotop --version")
  end
end
