class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://nano-editor.org/dist/v3/nano-3.0.tar.gz"
  sha256 "3f5f7713665155d9089ffde814ca89b3795104892af2ce8db2c1a70b82fa84a3"

  bottle do
    sha256 "8a56c675b6f0fd55e5e4e2944759bb4811b894074cf1c3089cd92b7f4f14462a" => :mojave
    sha256 "1b7f5f7842d849709b209d48346bc2dc502b538eeee460ef63513775d82f70ec" => :high_sierra
    sha256 "0f14e7427708f6105143a6c03f962bf047f7162adfc1a9a7f67749d13a42614c" => :sierra
    sha256 "f2ec710b129cb095c1107a53c632c5009f8ecddb53db4b4b95eb08edca0037ae" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8"
    system "make", "install"
    doc.install "doc/sample.nanorc"
  end

  test do
    system "#{bin}/nano", "--version"
  end
end
