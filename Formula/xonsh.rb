class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.6.5.tar.gz"
  sha256 "fc5e320a504d9c1b0d9862b39990a36c56bf56537ab328cd57ae9230bee48ff6"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ead71bd433d6ada87182f5f929d2df61b0f4f52081020f204fd7cd0588c88f4c" => :high_sierra
    sha256 "f04c357e2ca59858a63e9162d3e200216c2b25a421b505fff618986dfd502f8e" => :sierra
    sha256 "78b16dc30e23154d8a9d9d3c5f9a3466584ece8453f4bf48554c9026ef448644" => :el_capitan
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
