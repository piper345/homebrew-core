class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftpmirror.gnu.org/emacs/emacs-25.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/emacs/emacs-25.1.tar.xz"
  sha256 "19f2798ee3bc26c95dca3303e7ab141e7ad65d6ea2b6945eeba4dbea7df48f33"

  bottle do
    rebuild 5
    sha256 "f5bd6d841bdcc5fa730124c7ef21363aab4510a9656cfcc2024dd50a4c416465" => :sierra
    sha256 "133d6ce27d6ca0ae6f78cbbb8905a5275b05f58e881ee34293cb5e9c4a7313c6" => :el_capitan
    sha256 "5f978bc914fd63a828b2a51c0f5fc354f261661be5cc7bbe75514b45062cf281" => :yosemite
  end

  devel do
    url "https://alpha.gnu.org/gnu/emacs/pretest/emacs-25.2-rc2.tar.xz"
    sha256 "4f405314b427f9fdfc3fe89c3a062524156b23e07396427bb16d30ba1a8bf687"
  end

  head do
    url "https://github.com/emacs-mirror/emacs.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gnu-sed" => :build
    depends_on "texinfo" => :build
  end

  option "with-cocoa", "Build a Cocoa version of emacs"
  option "with-ctags", "Don't remove the ctags executable that emacs provides"
  option "without-libxml2", "Don't build with libxml2 support"
  option "with-modules", "Compile with dynamic modules support"

  deprecated_option "cocoa" => "with-cocoa"
  deprecated_option "keep-ctags" => "with-ctags"
  deprecated_option "with-d-bus" => "with-dbus"
  deprecated_option "imagemagick" => "imagemagick@6"

  depends_on "pkg-config" => :build
  depends_on "dbus" => :optional
  depends_on "gnutls" => :optional
  depends_on "librsvg" => :optional
  # Emacs does not support ImageMagick 7:
  # Reported on 2017-03-04: https://debbugs.gnu.org/cgi/bugreport.cgi?bug=25967
  depends_on "imagemagick@6" => :optional
  depends_on "mailutils" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp
      --infodir=#{info}/emacs
      --prefix=#{prefix}
      --without-x
    ]

    if build.with? "libxml2"
      args << "--with-xml2"
    else
      args << "--without-xml2"
    end

    if build.with? "dbus"
      args << "--with-dbus"
    else
      args << "--without-dbus"
    end

    if build.with? "gnutls"
      args << "--with-gnutls"
    else
      args << "--without-gnutls"
    end

    # Note that if ./configure is passed --with-imagemagick but can't find the
    # library it does not fail but imagemagick support will not be available.
    # See: https://debbugs.gnu.org/cgi/bugreport.cgi?bug=24455
    if build.with? "imagemagick@6"
      args << "--with-imagemagick"
    else
      args << "--without-imagemagick"
    end

    args << "--with-modules" if build.with? "modules"
    args << "--with-rsvg" if build.with? "librsvg"
    args << "--without-pop" if build.with? "mailutils"

    if build.head?
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
      system "./autogen.sh"
    end

    if build.with? "cocoa"
      args << "--with-ns" << "--disable-ns-self-contained"
    else
      args << "--without-ns"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    if build.with? "cocoa"
      prefix.install "nextstep/Emacs.app"

      # Replace the symlink with one that avoids starting Cocoa.
      (bin/"emacs").unlink # Kill the existing symlink
      (bin/"emacs").write <<-EOS.undent
        #!/bin/bash
        exec #{prefix}/Emacs.app/Contents/MacOS/Emacs "$@"
      EOS
    end

    # Follow MacPorts and don't install ctags from Emacs. This allows Vim
    # and Emacs and ctags to play together without violence.
    if build.without? "ctags"
      (bin/"ctags").unlink
      (man1/"ctags.1.gz").unlink
    end
  end

  def caveats
    if build.with? "cocoa" then <<-EOS.undent
      Please try the Cask for a better-supported Cocoa version:
        brew cask install emacs
      EOS
    end
  end

  plist_options :manual => "emacs"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/emacs</string>
        <string>--daemon</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_equal "4", shell_output("#{bin}/emacs --batch --eval=\"(print (+ 2 2))\"").strip
  end
end
