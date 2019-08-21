class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v19.08.10.101.tar.gz"
  sha256 "0f80277ac1609b8865c54856130d9fd7e8f099988e720367f6ef6448cd47b2b6"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "cc5b74c9ce4fde3e2d1dd76ef65f35fafed700b5848091573da1a55d81be361d" => :mojave
    sha256 "2674280c02e733f3fb7e832b092abd57c76cbe11124d293ab2365aa53ed48ff9" => :high_sierra
    sha256 "931ef56a79ab46c6aae0f8d0c6d8ad92f5f282d0164903a55970927d1991b939" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    assert_predicate testpath/"config", :exist?
  end
end
