class Mtoc < Formula
  desc "Mach-O to PE/COFF binary converter"
  homepage "https://opensource.apple.com/source/cctools/cctools-927.0.2/"
  url "https://opensource.apple.com/tarballs/cctools/cctools-927.0.2.tar.gz"
  sha256 "3d5d35e7120aac187de306019d4b53b3b08dd7ebf48764fcd5c8cefef40b3dbf"

  depends_on "llvm" => :build

  def install
    # Conflicts with _structs.h in macOS 10.13 - 10.15 SDK
    File.delete "include/mach/i386/_structs.h"

    system "make", "-C", "libstuff", "EFITOOLS=efitools"
    system "make", "-C", "efitools"

    bin.install "efitools/mtoc.NEW" => "mtoc"
    man1.install "man/mtoc.1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      __attribute__((naked)) int start() {}
    EOS

    args = %W[
      -nostdlib
      -Wl,-preload
      -Wl,-e,_start
      -seg1addr 0x1000
      -o #{testpath}/test
      #{testpath}/test.c
    ]
    system "cc", *args
    system "#{bin}/mtoc", "#{testpath}/test", "#{testpath}/test.pe"
  end
end
