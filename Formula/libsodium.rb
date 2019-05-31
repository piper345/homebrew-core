class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/archive/1.0.18.tar.gz"
  sha256 "d59323c6b712a1519a5daf710b68f5e7fde57040845ffec53850911f10a5d4f4"

  bottle do
    cellar :any
    sha256 "ac5455ed23e8e62db7ab5c96786ae21060f01074256f5d785a0f0d5dd6a9e1c6" => :mojave
    sha256 "dceca36893073a2f24f4f256d4ff98ea4b80eb44de89a706c70c69c15d5c7bae" => :high_sierra
    sha256 "b6dbce55089f4c5405272a163b98f981be44076514de098c65a1a074024d81e3" => :sierra
  end

  head do
    url "https://github.com/jedisct1/libsodium.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <sodium.h>

      int main()
      {
        assert(sodium_init() != -1);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}",
                   "-lsodium", "-o", "test"
    system "./test"
  end
end
