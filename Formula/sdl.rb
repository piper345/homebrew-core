class Sdl < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick and graphics"
  homepage "https://www.libsdl.org/"
  url "https://www.libsdl.org/release/SDL-1.2.15.tar.gz"
  sha256 "d6d316a793e5e348155f0dd93b979798933fb98aa1edebcc108829d6474aad00"

  bottle do
    cellar :any
    rebuild 3
    sha256 "12bc928852eedd72e469388efad6a7f7c23443e061d6901148a7e4042fe5b271" => :sierra
    sha256 "16a4c7dffaf8bee35d0ffa14dd4142f5ad09ef6d357f8aac97f998e1cf356795" => :el_capitan
    sha256 "ecd58053ef56a0e5aa1af8cd41c02f9e1a6385af86b669121c54c229ec2cae11" => :yosemite
  end

  head do
    url "https://hg.libsdl.org/SDL", :branch => "SDL-1.2", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-x11", "Compile with support for X11 video driver"
  option "with-test", "Compile and install the tests"
  option :universal

  deprecated_option "with-x11-driver" => "with-x11"
  deprecated_option "with-tests" => "with-test"

  depends_on :x11 => :optional

  if build.with? "x11"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # Fix build against recent libX11; requires regenerating configure script
    patch do
      url "https://hg.libsdl.org/SDL/raw-rev/91ad7b43317a"
      sha256 "04fa6aaf1ae1043e82d85f367fdb3bea5532e60aa944ce17357030ee93bb856c"
    end
  end

  # Fix for a bug preventing SDL from building at all on OSX 10.9 Mavericks
  # Related ticket: https://bugzilla.libsdl.org/show_bug.cgi?id=2085
  patch do
    url "https://bugzilla-attachments.libsdl.org/attachment.cgi?id=1320"
    sha256 "ba0bf2dd8b3f7605db761be11ee97a686c8516a809821a4bc79be738473ddbf5"
  end

  # Fix compilation error on 10.6 introduced by the above patch
  patch do
    url "https://bugzilla-attachments.libsdl.org/attachment.cgi?id=1324"
    sha256 "ee7eccb51cefff15c6bf8313a7cc7a3f347dc8e9fdba7a3c3bd73f958070b3eb"
  end

  def install
    # we have to do this because most build scripts assume that all sdl modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl.pc.in sdl-config.in], "@prefix@", HOMEBREW_PREFIX

    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head? || build.with?("x11")

    args = %W[--prefix=#{prefix}]
    args << "--disable-nasm" unless MacOS.version >= :mountain_lion # might work with earlier, might only work with new clang
    # LLVM-based compilers choke on the assembly code packaged with SDL.
    if ENV.compiler == :clang && DevelopmentTools.clang_build_version < 421
      args << "--disable-assembly"
    end

    if build.with? "x11"
      args << "--with-x"
    else
      args << "--without-x"
    end

    system "./configure", *args
    system "make", "install"

    # Copy source files needed for Ojective-C support.
    libexec.install Dir["src/main/macosx/*"] if build.stable?

    if build.with? "test"
      ENV.prepend_path "PATH", bin
      # We need the build to point at the newly-built (not yet linked) copy of SDL.
      inreplace bin/"sdl-config", "prefix=#{HOMEBREW_PREFIX}", "prefix=#{prefix}"
      cd "test" do
        system "./configure"
        system "make"
        # Tests don't have a "make install" target
        (share/"tests").install %w[checkkeys graywin loopwave testalpha testbitmap testblitspeed testcdrom
                                   testcursor testdyngl testerror testfile testgamma testgl testhread testiconv
                                   testjoystick testkeys testloadso testlock testoverlay testoverlay2 testpalette
                                   testplatform testsem testsprite testtimer testver testvidinfo testwin testwm
                                   threadwin torturethread]
        (share/"test_extras").install %w[icon.bmp moose.dat picture.xbm sail.bmp sample.bmp sample.wav]
        bin.write_exec_script Dir["#{share}/tests/*"]
      end
      # Point sdl-config back at the normal prefix once we've built everything.
      inreplace bin/"sdl-config", "prefix=#{prefix}", "prefix=#{HOMEBREW_PREFIX}"
    end
  end

  test do
    system bin/"sdl-config", "--version"
  end
end
