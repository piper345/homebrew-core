class Psfex < Formula
  homepage "https://www.astromatic.net/software/psfex"
  url "https://www.astromatic.net/download/psfex/psfex-3.17.1.tar.gz"
  sha256 "53f1b449ab7da7e6e0a989c41b82885f52c8f08270ceb4378bb1ec7ef754af89"

  bottle do
    sha256 "f12bfe217a941d1cfd4eaad08e8d170feb5af30702e9aa704c2356833420a54f" => :mojave
    sha256 "914d9278f02e0dde19702de33efa12409a21da2c085116bcd026d817926c762f" => :high_sierra
  end

  depends_on "fftw"
  depends_on "plplot"
  depends_on "autoconf" => :build

  # this patches make the changes needed to compile with the Accelerate
  # framework for linear algebra routines. Based on sextractor.rb recipe.
  patch do
    # make macro file for autoconf to enable Accelerate lib
    url "https://gist.githubusercontent.com/wschoenell/c5edf355087d2ff95390e6e10c12fbeb/raw/0909371996ba6dae2dde8cff608c94439f1bf46c/psfex_accelerate.patch"
    sha256 "d5018f173f18a08f7f820172a9180a801f8acae4555ee538854540e6a0d704fd"
  end

  def install
    system "autoconf"
    system "autoheader"
    system "./configure", "--prefix=#{prefix}", "--enable-accelerate"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
