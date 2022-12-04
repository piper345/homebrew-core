class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2022.12.01.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2022.12.01.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "057c1d3dc24c26b33e14c4dc3592885adf220403a1e1255e8a101e233c69c108"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "95ae80e78ad2282ca21375722618effc79d73a7574f882c466f76c5607bb79d0"
    sha256 cellar: :any,                 arm64_monterey: "69b8e39a55632b206a579a8d35668b47d7b032a0fc3da29b54ceb660fa46a5b9"
    sha256 cellar: :any,                 arm64_big_sur:  "0a41915deda6427d9fd07a5ce0e23bcecd7d0192f8008489ff7f7f9ca63010be"
    sha256 cellar: :any,                 ventura:        "2244d935f6676e0fa9ba1f507494e38c461762d3547f43cd978d199fba8f5204"
    sha256 cellar: :any,                 monterey:       "e4fb50627851cf44ff4894ef0dc5662a1e719447420dee4a1de1908199edc6cc"
    sha256 cellar: :any,                 big_sur:        "eeb507a0cd57ef938858bbe85f67262bd43e36e78f6465bbdf6e743b13cc8862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2849d118808a873fd3f9d62f1a4d403361c24f4f1e4b57481e8c69ef2229c5e"
  end

  depends_on "openssl@3"

  # Fix usage of IN6ADDR_ANY_INIT macro (error: expected expression). See:
  # https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/netinet_in.h.html
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2eabc6f/openrtsp/openrtsp.2022.11.19.patch"
    sha256 "33f6b852b2673e59cce7dedb1e6d5461a23d352221236c5964de077d137120cd"
  end

  def install
    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]

    os_flag = OS.mac? ? "macosx-no-openssl" : "linux-no-openssl"
    system "./genMakefiles", os_flag
    system "make", "PREFIX=#{prefix}",
           "LIBS_FOR_CONSOLE_APPLICATION=#{libs.join(" ")}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin/"test*")
  end

  def caveats
    <<~EOS
      Testing executables have been placed in:
        #{libexec}
    EOS
  end

  test do
    assert_match "GNU", shell_output("#{bin}/live555ProxyServer 2>&1", 1)
  end
end
