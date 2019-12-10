class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.20.2/faust-2.20.2.tar.gz"
  sha256 "bea8675446c5e5ef4ac4ba1fb1d64b3a2af99f5f293be0492ccaf32baf7fcb5c"

  bottle do
    cellar :any
    sha256 "4743141d43f5f48bf58bc735c4488f14799b141f855b3113b2071c09c6d50715" => :mojave
    sha256 "1f9af5b37d363cabc9236e847b1742a49ac7b90ca7400bd7f996a83fc5c3b584" => :high_sierra
    sha256 "64f752d06254dee602600ed971701f766fcb185a3874082cff0af12830fbfa7e" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm"

  def install
    system "make", "world"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"noise.dsp").write <<~EOS
      import("stdfaust.lib");
      process = no.noise;
    EOS

    system "#{bin}/faust", "noise.dsp"
  end
end
