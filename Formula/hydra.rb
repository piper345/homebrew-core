class Hydra < Formula
  desc "Network logon cracker which supports many services"
  homepage "https://github.com/vanhauser-thc/thc-hydra"
  url "https://github.com/vanhauser-thc/thc-hydra/archive/8.6.tar.gz"
  sha256 "05a87eb018507b24afca970081f067e64441460319fb75ca1e64c4a1f322b80b"
  revision 1
  head "https://github.com/vanhauser-thc/thc-hydra.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "915eef8e61e93d88032ecdc744b024e0461626107d3a7425780e3d4ee94d12f3" => :high_sierra
    sha256 "07197331ff1006734ffe3373c7008319f6ceebd4ca98f619b4c4e461554bc627" => :sierra
    sha256 "06db42aad5a60767fad351cc317e362287f9a2ac88f718a52d1b13562b0422f8" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "mysql"
  depends_on "openssl"
  depends_on "subversion" => :optional
  depends_on "libidn" => :optional
  depends_on "libssh" => :optional
  depends_on "pcre" => :optional
  depends_on "gtk+" => :optional

  def install
    inreplace "configure" do |s|
      # Link against our OpenSSL
      # https://github.com/vanhauser-thc/thc-hydra/issues/80
      s.gsub! "/opt/local/lib", Formula["openssl"].opt_lib
      s.gsub! "/opt/local/*ssl", Formula["openssl"].opt_lib
      s.gsub! "/opt/*ssl/include", Formula["openssl"].opt_include
      # Avoid opportunistic linking of subversion
      s.gsub! "libsvn", "oh_no_you_dont" if build.without? "subversion"
      # Avoid opportunistic linking of libssh
      s.gsub! "libssh", "certainly_not" if build.without? "libssh"
    end

    # Having our gcc in the PATH first can cause issues. Monitor this.
    # https://github.com/vanhauser-thc/thc-hydra/issues/22
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    system "make", "all", "install"
    share.install prefix/"man" # Put man pages in correct place
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hydra", 255)
  end
end
