class Qtkeychain < Formula
  desc "Qt API for storing passwords securely in the keychain"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/v0.8.0.tar.gz"
  sha256 "b492f603197538bc04b2714105b1ab2b327a9a98d400d53d9a7cb70edd2db12f"

  bottle do
    cellar :any
    sha256 "f6db1daf842379b6052bb53d11dca1480c59be03003c680dda7730822d5353f4" => :sierra
    sha256 "eb206f51eb9ed1fc0377a61d36e59838451c7e37da6f8d9edd120ccea243ceda" => :el_capitan
    sha256 "6d68aabc7b75c96cb409409b1eb765460596bf9f05cfbc859e36f140d9937e1a" => :yosemite
  end

  depends_on 'cmake' => :build
  depends_on "qt"

  def install
    # We need to set QT_TRANSLATIONS_DIR, else it tries to install translations
    # into Qt's directory which fails
    system "cmake", ".", "-DQT_TRANSLATIONS_DIR=#{prefix}/translations", *std_cmake_args
    system "make", "install"
    bin.install "testclient"
  end

  test do
    assert '#{bin}/testclient 2>&1 | grep account'
    # I wanted to do something like this, but this fails because the sandbox
    # does not have a keychain :-(
    # system "#{bin}/testclient", "store","__qtkeychaintest", "pw"
    # assert '#{bin}/testclient restore __qtkeychaintest 2>&1 | grep pw'
    # system "#{bin}/testclient", "delete","__qtkeychaintest"
  end
end
