class GribApi < Formula
  desc "Encode and decode grib messages (editions 1 and 2)"
  homepage "https://software.ecmwf.int/wiki/display/GRIB/Home"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/grib-api/grib-api_1.26.1.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/g/grib-api/grib-api_1.26.1.orig.tar.xz"
  sha256 "ee4a4607f7208ee329d9ae622dc34da8f0675ac08ab65ebe61c68856bebee810"
  revision 1

  bottle do
    rebuild 1
    sha256 "8deae9f105dd29714c38c3a638f9c68f0f7475bd8b9ac0fc1f45aecaf4969316" => :high_sierra
    sha256 "2812f3146507cdaeced49064d4886140d2426cfed0f92ab81e6491398504be08" => :sierra
    sha256 "8813cf79830136ed27dae6374950c335b35c6b0073107e026555d9d66a390392" => :el_capitan
  end

  option "with-static", "Build static instead of shared library."

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "jasper" => :recommended
  depends_on "libpng" => :optional

  conflicts_with "eccodes",
    :because => "grib-api and eccodes install the same binaries."

  def install
    # Fix "no member named 'inmem_' in 'jas_image_t'"
    inreplace "src/grib_jasper_encoding.c", "image.inmem_    = 1;", ""

    inreplace "CMakeLists.txt", "find_package( OpenJPEG )", ""

    mkdir "build" do
      args = std_cmake_args
      args << "-DBUILD_SHARED_LIBS=OFF" if build.with? "static"

      if build.with? "libpng"
        args << "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}"
        args << "-DENABLE_PNG=ON"
      end

      system "cmake", "..", "-DENABLE_NETCDF=OFF", *args
      system "make", "install"
    end
  end

  test do
    grib_samples_path = shell_output("#{bin}/grib_info -t").strip
    system bin/"grib_ls", "#{grib_samples_path}/GRIB1.tmpl"
    system bin/"grib_ls", "#{grib_samples_path}/GRIB2.tmpl"
  end
end
