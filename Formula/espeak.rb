class Espeak < Formula
  desc "Text to speech, software speech synthesizer"
  homepage "http://espeak.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/espeak/espeak/espeak-1.48/espeak-1.48.04-source.zip"
  sha256 "bf9a17673adffcc28ff7ea18764f06136547e97bbd9edf2ec612f09b207f0659"

  bottle do
    revision 1
    sha256 "005a950ffc0a5cf7da0c6b52c9e5ef964947b2bbefdf7c06e682bb2ae68a66f9" => :el_capitan
    sha256 "5c7291d1241ad763e53fb41a6cf261580d4e9c87afeb390cde992cc7c4a6a31b" => :yosemite
    sha256 "fe40bd1a5622d30d30f091c435c8212783fdf4f7d6f41c96531e340fdf72dcfb" => :mavericks
  end

  depends_on "portaudio"

  patch do
      url "https://github.com/danielbair/homebrew-tap/raw/master/libespeak/espeak-osx.patch"
      sha256 "58b769e7e7f6f3904e2eee221f733029681184b8da654eb211bf90120abcab6b"
  end

  def install
    share.install "espeak-data"
    share.install "docs"
    cd "src" do
      rm "portaudio.h"
      system "make", "speak", "DATADIR=#{share}/espeak-data", "PREFIX=#{prefix}"
      bin.install "speak" => "espeak"
      system "make", "libespeak.so", "DATADIR=#{share}/espeak-data", "PREFIX=#{prefix}"
      lib.install "libespeak.so.1.1.48" => "libespeak.so.1.1.48"
      lib.install "libespeak.so.1" => "libespeak.so.1"
      lib.install "libespeak.so" => "libespeak.so"
      system "make", "libespeak.a", "DATADIR=#{share}/espeak-data", "PREFIX=#{prefix}"
      lib.install "libespeak.a" => "libespeak.a"
    end
  end

  test do
    system "#{bin}/espeak", "This is a test for Espeak.", "-w", "out.wav"
  end
end
