class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm/2.1.0/scummvm-2.1.0.tar.xz"
  sha256 "6b50c6596a1536b52865f556dc05ded20f86b6ffabe4bccbd746b5587b15f727"
  head "https://github.com/scummvm/scummvm.git"

  bottle do
    sha256 "659537c3c08496ae20aee7cb0655ff00a05966c58d108a1ff9f2ce88c19321e9" => :catalina
    sha256 "7e19e7f58daa0e46c2343871804967fe915c27af7b92bc9d4c1007a3b2d609f3" => :mojave
    sha256 "83b2bfb31084378352b3a0056d28c23101615bc3fd871e53c25671cdc32ff360" => :high_sierra
    sha256 "3269c1ce9326d70f62471b4e11a70f513621864c8983013d21129bf54f68e297" => :sierra
  end

  depends_on "a52dec"
  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libmpeg2"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl2"
  depends_on "theora"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-release",
                          "--with-sdl-prefix=#{Formula["sdl2"].opt_prefix}"
    system "make"
    system "make", "install"
    (share+"pixmaps").rmtree
    (share+"icons").rmtree
  end

  test do
    system "#{bin}/scummvm", "-v"
  end
end
