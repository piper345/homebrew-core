class Gd < Formula
  desc "Graphics library to dynamically manipulate images"
  homepage "https://libgd.github.io/"
  revision 1

  stable do
    url "https://github.com/libgd/libgd/releases/download/gd-2.2.4/libgd-2.2.4.tar.xz"
    sha256 "137f13a7eb93ce72e32ccd7cebdab6874f8cf7ddf31d3a455a68e016ecd9e4e6"

    patch do
      url "https://github.com/libgd/libgd/commit/381e89de16125bb0e86ffc144d6fe3e9cfdd898f.patch?full_index=1"
      sha256 "93bcd92e7d18ef1f4cf4466482f41de8f0c65a7644c10bb88d10d59de96a13f1"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "b3533db2562ece8d90f15e1ceb98e788342bcd8c8de61ebfd680126be90597b8" => :sierra
    sha256 "4435c8d53b947dba6ed42643b5c72c86b1dbdee614e0d6c59063c074202be66e" => :el_capitan
    sha256 "bf326affde955276d79657b8e9c5a51d8a3bf9f550f7db3e649c1a32f8bd5517" => :yosemite
  end

  head do
    url "https://github.com/libgd/libgd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "webp"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-freetype=#{Formula["freetype"].opt_prefix}",
                          "--with-png=#{Formula["libpng"].opt_prefix}",
                          "--without-x",
                          "--without-xpm"
    system "make", "install"
  end

  test do
    system "#{bin}/pngtogd", test_fixtures("test.png"), "gd_test.gd"
    system "#{bin}/gdtopng", "gd_test.gd", "gd_test.png"
  end
end
