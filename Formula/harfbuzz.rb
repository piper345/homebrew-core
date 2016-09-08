class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.3.1.tar.bz2"
  sha256 "a242206dd119d5e6cc1b2253c116abbae03f9d930cb60b515fb0d248decf89a1"

  bottle do
    sha256 "9ea36c4b16291399d9206f5312699d22ae5aff22365c65a2c540b49ff567c412" => :el_capitan
    sha256 "7c4620ba3edd0fafd9e73efc8738b2b8039327a9c77a4cf1dc1f2c309b7dc749" => :yosemite
    sha256 "43be4893fe40aafce53258909b5e27746bb80fe70a038b8876294e405d237fe7" => :mavericks
  end

  head do
    url "https://github.com/behdad/harfbuzz.git"

    depends_on "ragel" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "with-cairo", "Build command-line utilities that depend on Cairo"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "freetype"
  depends_on "gobject-introspection"
  depends_on "icu4c" => :recommended
  depends_on "cairo" => :optional
  depends_on "graphite2" => :optional

  resource "ttf" do
    url "https://github.com/behdad/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
  end

  # use of undeclared identifier 'kCTVersionNumber10_10'
  patch :DATA

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-introspection=yes
      --with-freetype=yes
      --with-glib=yes
      --with-gobject=yes
      --with-coretext=yes
      --enable-static
    ]

    if build.with? "icu4c"
      args << "--with-icu=yes"
    else
      args << "--with-icu=no"
    end

    if build.with? "graphite2"
      args << "--with-graphite2=yes"
    else
      args << "--with-graphite2=no"
    end

    if build.with? "cairo"
      args << "--with-cairo=yes"
    else
      args << "--with-cairo=no"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    resource("ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
  end
end

__END__
diff --git a/src/hb-coretext.cc b/src/hb-coretext.cc
index ee7f91c..02742a2 100644
--- a/src/hb-coretext.cc
+++ b/src/hb-coretext.cc
@@ -152,13 +152,15 @@ create_ct_font (CGFontRef cg_font, CGFloat font_size)
    * operating system versions. Except for the emoji font, where _not_
    * reconfiguring the cascade list causes CoreText crashes. For details, see
    * crbug.com/549610 */
-  if (&CTGetCoreTextVersion != NULL && CTGetCoreTextVersion() < kCTVersionNumber10_10) {
+#ifndef kCTVersionNumber10_10
+  if (&CTGetCoreTextVersion != NULL) {
     CFStringRef fontName = CTFontCopyPostScriptName (ct_font);
     bool isEmojiFont = CFStringCompare (fontName, CFSTR("AppleColorEmoji"), 0) == kCFCompareEqualTo;
     CFRelease (fontName);
     if (!isEmojiFont)
       return ct_font;
   }
+#endif
 
   CFURLRef original_url = (CFURLRef)CTFontCopyAttribute(ct_font, kCTFontURLAttribute);
 
