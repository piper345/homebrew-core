class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.6.1.tar.gz"
  sha256 "a38b8f8a282addc8253fb27dfe4a9e0198b7093a0c0d78a842ee133b35647b59"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "328b1d5f8abe976cf91c9cf64c394bff5f2cee8179885e7789c2a31609370f93" => :high_sierra
    sha256 "8cbbc417e9014f7cb380b713eac80926036086bbc2ac92238a088004e52178d9" => :sierra
    sha256 "4cb850dc84be83958614b538ba209510738fdaa10183b55e11d460b362ce4009" => :el_capitan
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
