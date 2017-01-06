class Libevent < Formula
  desc "Asynchronous event library"
  homepage "http://libevent.org"

  stable do
    url "https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz"
    sha256 "71c2c49f0adadacfdbe6332a372c38cf9c8b7895bb73dabeaa53cdcc1d4e1fa3"

    # https://github.com/Homebrew/homebrew-core/issues/2869
    # https://github.com/libevent/libevent/issues/376
    patch do
      url "https://github.com/libevent/libevent/commit/df6f99e5b51a3.patch"
      sha256 "26e831f7b000c7a0d79fed68ddc1d9bd1f1c3fab8a3c150fcec04a3e282b1acb"
    end
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "606789b6b1457db65b9fdf47ecd26181ecad771fff5b598fd163cc9a0ac1466a" => :sierra
    sha256 "f4f68794b016422b097b9d2996f4a79f11a773ffb243badc94df51d747cc626c" => :el_capitan
    sha256 "d6415b9c8df0a5d0827650c2b4a89d6e07782a9afbb2480e9d9277f85cbaae58" => :yosemite
  end

  devel do
    url "https://github.com/libevent/libevent/archive/release-2.1.7-rc.tar.gz"
    sha256 "548362d202e22fe24d4c3fad38287b4f6d683e6c21503341373b89785fa6f991"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  head do
    url "https://github.com/libevent/libevent.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "without-doxygen", "Don't build & install the manpages (uses Doxygen)"

  deprecated_option "enable-manpages" => "with-doxygen"

  depends_on "doxygen" => [:recommended, :build]
  depends_on "pkg-config" => :build
  depends_on "openssl"

  conflicts_with "pincaster",
    :because => "both install `event_rpcgen.py` binaries"

  def install
    ENV.universal_binary if build.universal?
    ENV.deparallelize

    if build.with? "doxygen"
      inreplace "Doxyfile", /GENERATE_MAN\s*=\s*NO/, "GENERATE_MAN = YES"
    end

    system "./autogen.sh" unless build.stable?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug-mode",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    if build.with? "doxygen"
      system "make", "doxygen"
      man3.install Dir["doxygen/man/man3/*.3"]
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <event2/event.h>

      int main()
      {
        struct event_base *base;
        base = event_base_new();
        event_base_free(base);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-levent", "-o", "test"
    system "./test"
  end
end
