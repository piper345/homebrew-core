class Pgplot < Formula
  desc "Device-independent graphics package for making simple scientific graphs"
  homepage "http://www.astro.caltech.edu/~tjp/pgplot/"
  url "ftp://ftp.astro.caltech.edu/pub/pgplot/pgplot522.tar.gz"
  mirror "https://distfiles.macports.org/pgplot/pgplot522.tar.gz"
  mirror "ftp://ftp.us.horde.org/pub/linux/gentoo/distro/distfiles/pgplot522.tar.gz"
  version "5.2.2"
  sha256 "a5799ff719a510d84d26df4ae7409ae61fe66477e3f1e8820422a9a4727a5be4"
  revision 4

  bottle do
    rebuild 1
    sha256 "f61e6c9d99184ec8f266833113ef9386b9374862db76bcf85c07488bb2cb23bd" => :sierra
    sha256 "99d11818e392c29a73c04626af905b5605fb43a00af1462f477b1e7419aec84b" => :el_capitan
    sha256 "c93bc43d9c749570674c69b075b7c2319c7dacd55390c7ba8eb4d65514f2801d" => :yosemite
  end

  depends_on :x11
  depends_on :fortran
  depends_on "libpng"

  # from MacPorts: https://trac.macports.org/browser/trunk/dports/graphics/pgplot/files
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/b520c2d/pgplot/patch-makemake.diff"
    sha256 "1af44204240dd91a59c899714b4f6012ff1eccfcad8f2133765beec34d6f1423"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/b520c2d/pgplot/patch-proccom.c.diff"
    sha256 "93c55078389c660407c0052569d3ed543c92107c139c765d207b90687cfb7a0c"
  end

  def install
    ENV.deparallelize
    ENV.append "CPPFLAGS", "-DPG_PPU"
    # allow long lines in the fortran code (for long homebrew PATHs)
    ENV.append "FCFLAGS", "-ffixed-line-length-none"

    # re-hardcode the share dir
    inreplace "src/grgfil.f", "/usr/local/pgplot", share
    # perl may not be in /usr/local
    inreplace "makehtml", "/usr/local/bin/perl", which("perl")
    # prevent a "dereferencing pointer to incomplete type" in libpng
    inreplace "drivers/pndriv.c", "setjmp(png_ptr->jmpbuf)", "setjmp(png_jmpbuf(png_ptr))"

    # configure options
    (buildpath/"sys_darwin/homebrew.conf").write <<-EOS.undent
      XINCL="#{ENV.cppflags}"
      MOTIF_INCL=""
      ATHENA_INCL=""
      TK_INCL=""
      RV_INCL=""
      FCOMPL="#{ENV.fc}"
      FFLAGC="#{ENV.fcflags}"
      FFLAGD=""
      CCOMPL="#{ENV.cc}"
      CFLAGC="#{ENV.cppflags}"
      CFLAGD=""
      PGBIND_FLAGS="bsd"
      LIBS="#{ENV.ldflags} -lX11"
      MOTIF_LIBS=""
      ATHENA_LIBS=""
      TK_LIBS=""
      RANLIB="#{which "ranlib"}"
      SHARED_LIB="libpgplot.dylib"
      SHARED_LD="#{ENV.fc} -dynamiclib -single_module $LDFLAGS -lX11 -install_name libpgplot.dylib"
      SHARED_LIB_LIBS="#{ENV.ldflags} -lpng -lX11"
      MCOMPL=""
      MFLAGC=""
      SYSDIR="$SYSDIR"
      CSHARED_LIB="libcpgplot.dylib"
      CSHARED_LD="#{ENV.fc} -dynamiclib -single_module $LDFLAGS -lX11"
      EOS

    mkdir "build" do
      # activate drivers
      cp "../drivers.list", "."
      %w[GIF VGIF LATEX PNG TPNG PS
         VPS CPS VCPS XWINDOW XSERVE].each do |drv|
        inreplace "drivers.list", %r{^! (.*\/#{drv} .*)}, '  \1'
      end

      # make everything
      system "../makemake .. darwin; make; make cpg; make pgplot.html"

      # install
      bin.install "pgxwin_server", "pgbind"
      lib.install Dir["*.dylib", "*.a"]
      include.install Dir["*.h"]
      share.install Dir["*.txt", "*.dat"]
      doc.install Dir["*.doc", "*.html"]
      (share/"examples").install Dir["*demo*", "../examples/pgdemo*.f", "../cpg/cpgdemo*.c", "../drivers/*/pg*demo.*"]
    end
  end

  test do
    (testpath/"test.f90").write <<-EOS.undent
      PROGRAM SIMPLE
      INTEGER I, IER, PGBEG
      REAL XR(100), YR(100)
      REAL XS(5), YS(5)
      data XS/1.,2.,3.,4.,5./
      data YS/1.,4.,9.,16.,25./
      IER = PGBEG(0,'?',1,1)
      IF (IER.NE.1) STOP
      CALL PGENV(0.,10.,0.,20.,0,1)
      CALL PGLAB('(x)', '(y)', 'A Simple Graph')
      CALL PGPT(5,XS,YS,9)
      DO 10 I=1,60
          XR(I) = 0.1*I
          YR(I) = XR(I)**2
   10 CONTINUE
      CALL PGLINE(60,XR,YR)
      CALL PGEND
      END
    EOS
    system "gfortran", "-o", "test", "test.f90", "-L#{lib}", "-lpgplot", "-lX11", "-L/usr/X11/lib", "-I/usr/X11/include"
  end
end
