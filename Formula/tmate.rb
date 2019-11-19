class Tmate < Formula
  desc "Instant terminal sharing"
  homepage "https://tmate.io/"
  url "https://github.com/tmate-io/tmate/archive/2.4.0.tar.gz"
  sha256 "62b61eb12ab394012c861f6b48ba0bc04ac8765abca13bdde5a4d9105cb16138"
  head "https://github.com/tmate-io/tmate.git"

  bottle do
    cellar :any
    sha256 "644a6f94ff04529b22d2a7e297ebddf3e6882c8591282d2f295a41fdf1e2cf61" => :catalina
    sha256 "d31d9aaa27d2fb8bd605e26cf4eb9721a821c1ea3262a2a9f9740de08dd296b9" => :mojave
    sha256 "6095c9b251e9a3c5b76155dee4b7866e157bc563ee9155f8976c86afaa5cbf3e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libssh"
  depends_on "msgpack"

  def install
    system "sh", "autogen.sh"

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/tmate", "-V"
  end
end
