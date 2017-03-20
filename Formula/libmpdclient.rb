class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.11.tar.gz"
  sha256 "249d510c96142f14c8c45f5f8f6bd824bfd45f534cc386aa60ca492ab2f98ede"

  bottle do
    cellar :any
    sha256 "fe07e076edafdb86d36590a0bab78f99e6f36faf54a450ffeee808bcc38b3193" => :sierra
    sha256 "260ae000202c5d848b014c682db6f414b621c37fa0ada15a50d39ffa30a7d06e" => :el_capitan
    sha256 "53c232fdc4c66fb2aa823b474337f8c5275cf01171077b8772a0dd2b1aaf670c" => :yosemite
    sha256 "a6d500dd34581bb30a623df20b2e031eb3f1a6a586886acc97e437a5447e144b" => :mavericks
    sha256 "d583dffa231db87e89bc291d20aedb63d9ac5324eeff80cdc974cff2b93c6a1a" => :mountain_lion
  end

  head do
    url "git://git.musicpd.org/master/libmpdclient.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "doxygen" => :build

  def install
    inreplace "autogen.sh", "libtoolize", "glibtoolize"
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
