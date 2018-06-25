class NestopiaUe < Formula
  desc "Nestopia UE (Undead Edition): NES emulator"
  homepage "http://0ldsk00l.ca/nestopia/"
  url "https://downloads.sourceforge.net/project/nestopiaue/1.49/nestopia-1.49.tgz"
  sha256 "653e6a39376b883196a32926691aef0071cc881d3256d2f0394c248a010560ba"
  head "https://github.com/rdanbrook/nestopia.git"

  bottle do
    sha256 "3d3340bf96768b1a0df348c5c980eaaa31b41e4317727177499c881e694b0f91" => :high_sierra
    sha256 "9f66bf2e5c42ba743d4967d5b3cb9f4993a265a619dfd71de74478273a0b1f38" => :sierra
    sha256 "1e319cdecfa2dbe1779b124cd4d758921d64128b0ccb06f1aab8a1d23a428fe9" => :el_capitan
    sha256 "f3dda418bd311d3c4fd4856fb8464dedac1fa1051864497b365bc42cb683d59d" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "libao"
  depends_on "libarchive"
  depends_on "libepoxy"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--datarootdir=#{pkgshare}"
    system "make", "install"
  end

  test do
    assert_match /Nestopia UE #{version}$/, shell_output("#{bin}/nestopia --version")
  end
end
