class Rssh < Formula
  desc "Restricted shell for use with OpenSSH"
  homepage "http://www.pizzashack.org/rssh"
  url "https://downloads.sourceforge.net/project/rssh/rssh/2.3.4/rssh-2.3.4.tar.gz"
  sha256 "f30c6a760918a0ed39cf9e49a49a76cb309d7ef1c25a66e77a41e2b1d0b40cd9"

  bottle do
    revision 1
    sha256 "23891b0317ef29a36b0b8ee9f140193d17ae616983c13f2179d5b317b33e1eee" => :el_capitan
    sha256 "a63ead463b79c5375e0b919976173db13a236fcea06c4fa038a719375a550ca9" => :yosemite
    sha256 "603e4f5c2fd808d31e1a794573bc7c9949c87f6d0997851dc60d778282854a3e" => :mavericks
  end

  # Submitted upstream:
  # https://sourceforge.net/p/rssh/mailman/message/32251335/
  patch do
    url "https://gist.githubusercontent.com/arminsch/9230011/raw/f0c5ed95bbba0be28ce2b5f0d1080de84ec317ab/rsshconf-log-rename.diff"
    sha256 "abd625a8dc24f3089b177fd0318ffc1cf4fcb08d0c149191bb45943ad55f6934"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    # test to check if everything is linked correctly
    system "#{bin}/rssh", "-v"
    # the following test checks if rssh, if invoked without commands and options, fails
    system "sh", "-c", "! #{bin}/rssh"
  end
end
