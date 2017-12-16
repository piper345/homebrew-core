class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://graphviz.org/"
  # versioned URLs are missing upstream as of 16 Dec 2017
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/graphviz/graphviz-2.40.1.tar.gz"
  mirror "https://fossies.org/linux/misc/graphviz-2.40.1.tar.gz"
  sha256 "ca5218fade0204d59947126c38439f432853543b0818d9d728c589dfe7f3a421"
  version_scheme 1

  bottle do
    rebuild 2
    sha256 "1a34f5467894695e30a351781063f7233286340fe966c0f553b7ffb9cdd78da9" => :high_sierra
    sha256 "e90b206f2df0a0b7366853ae668615e0e54f760eae45c9e31512398ed4d08f3a" => :sierra
    sha256 "b4be4787ca11cd39b73b9ae01ae2d02cc2d06a7a5650aab075684b3d078dd14a" => :el_capitan
  end

  head do
    url "https://github.com/ellson/graphviz.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-bindings", "Build Perl/Python/Ruby/etc. bindings"
  option "with-pango", "Build with Pango/Cairo for alternate PDF output"
  option "with-app", "Build GraphViz.app (requires full XCode install)"
  option "with-gts", "Build with GNU GTS support (required by prism)"

  deprecated_option "with-x" => "with-x11"
  deprecated_option "with-pangocairo" => "with-pango"

  depends_on "pkg-config" => :build
  depends_on :xcode => :build if build.with? "app"
  depends_on "libtool" => :run
  depends_on "pango" => :optional
  depends_on "gts" => :optional
  depends_on "librsvg" => :optional
  depends_on "freetype" => :optional
  depends_on :x11 => :optional
  depends_on "gd"
  depends_on "libpng"

  if build.with? "bindings"
    depends_on "swig" => :build
    depends_on :python
    depends_on :java
    depends_on "ruby"
  end

  def install
    # Only needed when using superenv, which causes qfrexp and qldexp to be
    # falsely detected as available. The problem is triggered by
    #   args << "-#{ENV["HOMEBREW_OPTIMIZATION_LEVEL"]}"
    # during argument refurbishment of cflags.
    # https://github.com/Homebrew/brew/blob/ab060c9/Library/Homebrew/shims/super/cc#L241
    # https://github.com/Homebrew/legacy-homebrew/issues/14566
    # Alternative fixes include using stdenv or using "xcrun make"
    inreplace "lib/sfio/features/sfio", "lib qfrexp\nlib qldexp\n", ""

    if build.with? "bindings"
      # the ruby pkg-config file is version specific
      inreplace "configure" do |s|
        s.gsub! "ruby-1.9", "ruby-#{Formula["ruby"].stable.version.to_f}"
        s.gsub! "if test `$SWIG -php7 2>&1", "if test `$SWIG -php0 2>&1"
      end
    end

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-qt
      --with-quartz
      --disable-php
    ]
    args << "--with-gts" if build.with? "gts"
    args << "--disable-swig" if build.without? "bindings"
    args << "--without-pangocairo" if build.without? "pango"
    args << "--without-freetype2" if build.without? "freetype"
    args << "--without-x" if build.without? "x11"
    args << "--without-rsvg" if build.without? "librsvg"

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"

    if build.with? "app"
      cd "macosx" do
        xcodebuild "SDKROOT=#{MacOS.sdk_path}", "-configuration", "Release", "SYMROOT=build", "PREFIX=#{prefix}",
                   "ONLY_ACTIVE_ARCH=YES", "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
      end
      prefix.install "macosx/build/Release/Graphviz.app"
    end

    (bin/"gvmap.sh").unlink
  end

  test do
    (testpath/"sample.dot").write <<~EOS
      digraph G {
        a -> b
      }
    EOS

    system "#{bin}/dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end
