class Pev < Formula
  desc "PE analysis toolkit"
  homepage "http://pev.sf.net/"
  url "https://downloads.sourceforge.net/project/pev/pev-0.80/pev-0.80.tar.gz"
  sha256 "f68c8596f16d221d9a742812f6f728bcc739be90957bc1b00fbaa5943ffc5cfa"
  head "https://github.com/merces/pev.git"

  bottle do
    cellar :any
    sha256 "ae2da367a475feabca973d61db14a8f7b9bb14d0508453059bb09c66ad8c7ee4" => :sierra
    sha256 "81e831cd776a7ecea986012a4a8aae05c316b7c628314c679bbc89daf89190e8" => :el_capitan
    sha256 "e01f09a92f3af2fb454e17529bac7900978960382bc52ae62aa4fa6b751f41c0" => :yosemite
    sha256 "f2ffcbda87b08fdd2a4621468f711c7f5542b2413833f350f93105d0825a97d9" => :mavericks
    sha256 "08ba1dbebcb68b2c6a67a2052840764803ad3efc975563e72960da0f8b6e463d" => :mountain_lion
  end

  depends_on "pcre"
  depends_on "openssl"

  def install
    ENV.deparallelize
    system "make", "prefix=#{prefix}", "CC=#{ENV.cc}"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "#{bin}/pedis", "--version"
  end
end
