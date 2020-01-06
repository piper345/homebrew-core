class PbcSig < Formula
  desc "Signatures library"
  homepage "https://crypto.stanford.edu/pbc/sig/"
  url "https://crypto.stanford.edu/pbc/sig/files/pbc_sig-0.0.8.tar.gz"
  sha256 "7a343bf342e709ea41beb7090c78078a9e57b833454c695f7bcad2475de9c4bb"

  bottle do
    cellar :any
    rebuild 1
    sha256 "47773fefdfeb3f7381046934974bbaf7f41a641c3d3f3af5802d07a7ea340ba6" => :catalina
    sha256 "134c203178bb93b406b4c5fb5aecf171db6473d558d0bf62cf9b1682b57448e9" => :mojave
    sha256 "79c31a3f1bcc2429648a2258974ccb1185cfe244d4fcbbfa2840c7393e7e058a" => :high_sierra
  end

  depends_on "pbc"

  # https://groups.google.com/forum/#!topic/pbc-devel/ZmFCHZmrhcw
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <pbc/pbc.h>
      #include <pbc/pbc_sig.h>

      int main()
      {
        pbc_param_t param;
        pairing_t pairing;
        bls_sys_param_t bls_param;
        pbc_param_init_a_gen(param, 160, 512);
        pairing_init_pbc_param(pairing, param);
        bls_gen_sys_param(bls_param, pairing);
        bls_clear_sys_param(bls_param);
        pairing_clear(pairing);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{Formula["pbc"].lib}",
                   "-L#{lib}", "-lpbc", "-lpbc_sig"
    system "./test"
  end
end

__END__
diff --git a/sig/bbs.c b/sig/bbs.c
index ed1b437..8aa8331 100644
--- a/sig/bbs.c
+++ b/sig/bbs.c
@@ -1,4 +1,5 @@
 //see Boneh, Boyen and Shacham, "Short Group Signatures"
+#include <stdint.h>
 #include <pbc/pbc_utils.h>
 #include "pbc_sig.h"
 #include "pbc_hash.h"
