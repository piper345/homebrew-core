class Opencascade < Formula
  desc "3D modeling and numerical simulation software for CAD/CAM/CAE"
  homepage "https://www.opencascade.com/content/overview"
  url "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=refs/tags/V7_3_0;sf=tgz"
  version "7.3.0"
  sha256 "7298c5eadc6dd0aeb6265ff2958e8e742d6e3aa65227acce8094f96f1bf6d2ac"

  bottle do
    cellar :any
    sha256 "011b4ee523e0f861412343fbdbcd95c31ab14fb57d990e07417e4baed86442c7" => :high_sierra
    sha256 "10901b2b2dac00baa8d0bc0e91e98c850ee252576109414c93405601aaa29fb3" => :sierra
    sha256 "12da230c3cfcce0f3eae07fa566f7e3e837ab14142ce26c02a015b907b02e6e6" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "freeimage"
  depends_on "freetype"
  depends_on "gl2ps"
  depends_on "tbb"

  def install
    system "cmake", ".",
                    "-DUSE_FREEIMAGE=ON",
                    "-DUSE_GL2PS=ON",
                    "-DUSE_TBB=ON",
                    "-DINSTALL_DOC_Overview=ON",
                    "-D3RDPARTY_FREEIMAGE_DIR=#{Formula["freeimage"].opt_prefix}",
                    "-D3RDPARTY_FREETYPE_DIR=#{Formula["freetype"].opt_prefix}",
                    "-D3RDPARTY_GL2PS_DIR=#{Formula["gl2ps"].opt_prefix}",
                    "-D3RDPARTY_TBB_DIR=#{Formula["tbb"].opt_prefix}",
                    "-D3RDPARTY_TCL_DIR:PATH=#{MacOS.sdk_path_if_needed}/usr",
                    "-D3RDPARTY_TCL_INCLUDE_DIR=#{MacOS.sdk_path_if_needed}/usr/include",
                    "-D3RDPARTY_TK_INCLUDE_DIR=#{MacOS.sdk_path_if_needed}/usr/include",
                    *std_cmake_args
    system "make", "install"

    bin.env_script_all_files(libexec/"bin", :CASROOT => prefix)

    # Some apps expect resources in legacy ${CASROOT}/src directory
    prefix.install_symlink pkgshare/"resources" => "src"
  end

  test do
    output = shell_output("#{bin}/DRAWEXE -c \"pload ALL\"")
    assert_equal "1", output.chomp
  end
end
