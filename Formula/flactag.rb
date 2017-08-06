class Flactag < Formula
  desc "Tag single album FLAC files with MusicBrainz CUE sheets"
  homepage "https://flactag.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/flactag/v2.0.4/flactag-2.0.4.tar.gz"
  sha256 "c96718ac3ed3a0af494a1970ff64a606bfa54ac78854c5d1c7c19586177335b2"
  revision 1

  bottle do
    cellar :any
    sha256 "2b282403d61a6d13e3b04185b381bcf8c60c88f991dec2f85e40b2cc8829489c" => :sierra
    sha256 "0d075aa25a1e86ef0438789eccfac2069e9777aec8982bb15dbd0ce6058459c9" => :el_capitan
    sha256 "00616d547195f61ec0a9ebed92a6408ce195a83cee5c359f914a8d2062e6bc00" => :yosemite
    sha256 "e5700eb1c0a92a4f217247ddda62a7343b101af07f7b179d1fee9ee9c70607c4" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "asciidoc" => :build
  depends_on "flac"
  depends_on "libmusicbrainz"
  depends_on "neon"
  depends_on "libdiscid"
  depends_on "s-lang"
  depends_on "unac"
  depends_on "jpeg"

  # jpeg 9 compatibility
  patch do
    url "https://gist.githubusercontent.com/ilovezfs/b652c9e24958504d6942e3ce44fe6158/raw/41a4002a8ff238db9c99778c42f80103077e42fe/gistfile1.txt"
    sha256 "a8f3dda9e238da70987b042949541f89876009f1adbedac1d6de54435cc1e8d7"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append "LDFLAGS", "-liconv"
    ENV.append "LDFLAGS", "-lFLAC"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/flactag"
  end
end
