class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  revision 1
  head "https://github.com/nickg/nvc.git"

  stable do
    url "https://github.com/nickg/nvc/releases/download/r1.1.0/nvc-1.1.0.tar.gz"
    sha256 "b3b5f67ee91046ab802112e544b7883f7a92b69d25041b5b8187c07016dfda75"

    # Remove for > 1.1.0
    # LLVM 3.9 compatibility
    # Fix "Undefined symbols for architecture x86_64: '_LLVMLinkModules'"
    # Upstream commit from 8 Jan 2017 "Use LLVMLinkModules2 where available."
    # Reported 8 Jan 2017 https://github.com/nickg/nvc/issues/310
    patch do
      url "https://github.com/nickg/nvc/commit/cd427e4.patch"
      sha256 "5223274735e72bfa5f55ca7d7a97f1c1d254b8104fe4adb40e47ae67311f2c28"
    end

    # Remove for > 1.1.0
    # LLVM 4.0 compatibility
    # Fix "use of undeclared identifier 'LLVMNoUnwindAttribute'"
    # Upstream commit from 7 Mar 2017 "Update for new LLVM attribute API."
    # Reported 16 Feb 2017 https://github.com/nickg/nvc/issues/313
    patch do
      url "https://github.com/nickg/nvc/commit/028ece6.patch"
      sha256 "9c2ae65129b6f3e5e6efb1eff77bd2bde790f3d8168b7fe482b4bf9f1115fd63"
    end
  end

  bottle do
    sha256 "1e9c83fa64952cccf301e1652516697c6ab9e17a3d05e6f5f3861cb97689f1c0" => :sierra
    sha256 "05d0071242e0e8cc1621e3ac0ea1e8b5bcdcfbfe9622db9bef8a7a3077c39983" => :el_capitan
    sha256 "1b530bdf998bb161222efaae1ee59fe135889d6ed245f28dd2cee06e845ddc0e" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm" => :build
  depends_on "check" => :build

  resource "vim-hdl-examples" do
    url "https://github.com/suoto/vim-hdl-examples.git",
        :revision => "c112c17f098f13719784df90c277683051b61d05"
  end

  def install
    args = %W[
      --with-llvm=#{Formula["llvm"].opt_bin}/llvm-config
      --prefix=#{prefix}
    ]

    if build.head?
      system "./autogen.sh"
    else
      system "autoreconf", "-fiv"
    end

    system "./tools/fetch-ieee.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    resource("vim-hdl-examples").stage testpath
    system "#{bin}/nvc", "-a", "#{testpath}/basic_library/very_common_pkg.vhd"
  end
end
