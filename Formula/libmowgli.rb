class Libmowgli < Formula
  desc "Core framework for Atheme applications"
  homepage "https://github.com/atheme/libmowgli-2"
  url "https://github.com/atheme/libmowgli-2/archive/v2.1.0.tar.gz"
  sha256 "46ef60c642c457a5d0e36bfc8c277e74d2ebf4ab9cbc4e40153781ed4ab0fe7d"
  head "https://github.com/atheme/libmowgli-2.git"

  bottle do
    cellar :any
    revision 3
    sha256 "6576cf998b59cc3deb45d7072930296eaad347e3993a9243bea4ca984d5d06c2" => :el_capitan
    sha256 "e32cc8c528e1cb58775f1fd4fb2e491649bbc1d50fe6c7767d8502fa183d1cab" => :yosemite
    sha256 "687b05dd17d208907b854c245be8ee1c2eae759aab0db7e2b620173cd6fd06f1" => :mavericks
    sha256 "c7bb30b3ec74cbeb74a9092504b336c5e1ec155c6702830ae6d6f548b65d74e0" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <mowgli.h>

      int main(int argc, char *argv[]) {
        char buf[65535];
        mowgli_random_t *r = mowgli_random_create();
        mowgli_formatter_format(buf, 65535, "%1! %2 %3 %4.",\
                    "sdpb", "Hello World", mowgli_random_int(r),\
                    0xDEADBEEF, TRUE);
        puts(buf);
        mowgli_object_unref(r);
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "-I#{include}/libmowgli-2", "-o", "test", "test.c", "-lmowgli-2"
    system "./test"
  end
end
