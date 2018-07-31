class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.31.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.31.tar.gz"
  sha256 "5a9de9199f22ca7f35eac378f93c45ead636994fc59f3ac08f6b3569f73fcf6f"

  bottle do
    sha256 "b15ac1832f141514cde7bb0ed3ed639c7487611876589cdeb10da1378fc6e06e" => :high_sierra
    sha256 "b1c1b5d340bab02647ac1e524b9962debca5c3d6641283e93a99049310cf53c5" => :sierra
    sha256 "dccb4fb54d875c5ce0b582702a884f5a0f67a14a1c7c3749a519fffa54c1f6d3" => :el_capitan
  end

  def install
    ENV.cxx11
    ENV.append "CXXFLAGS", "-Wno-c++11-narrowing"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--disable-werror",
                          "--target=arm-linux-gnueabihf",
                          "--enable-gold=yes",
                          "--enable-ld=yes",
                          "--enable-interwork"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/arm-linux-gnueabihf-c++filt _Z1fv")
  end
end
