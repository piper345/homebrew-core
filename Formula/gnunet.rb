class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.11.0.tar.gz"
  sha256 "b7477a3c3b0d5e8a013685dc208cfb4ccee4145f8668faa8eb5b382af36c7e9a"

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libextractor"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libmpc"
  depends_on "libunistring"
  depends_on "unbound"

  def install
    args = %W[
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    chmod "+x", prefix/"bin/gnunet-qr.py"
  end

  test do
    assert_equal "#{bin}/gnunet-arm v#{version} release\n",
      shell_output("#{bin}/gnunet-arm --version", 1)
  end
end
