class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://github.com/xonsh/xonsh/archive/0.7.2.tar.gz"
  sha256 "0e88ad84c6e3dbe1a49b4979bcef495d4e10bb998e597ae6553a085d794320b7"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "57566d83cb229556be5d7fcd90aae31eb1fe349b7015bd2ff1a7ea1e10df2435" => :high_sierra
    sha256 "68442bc960d4c56c17cf2da903025b15bc9c6a5337a10bbe09ed3b52f87797ca" => :sierra
    sha256 "fcdfaacf708ac55fda297bab234feece063e2bbb0d7b348e14ac03c89cd157df" => :el_capitan
  end

  depends_on "python"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/77/bf/5d7664605c91db8f39a3e49abb57a3c933731a90b7a58cdcafd4a9bcbe97/prompt_toolkit-2.0.4.tar.gz"
    sha256 "ff58ce8bb82c11c43416dd3eec7701dcbe8c576e2d7649f1d2b9d21a2fd93808"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/5a/0d/dc0d2234aacba6cf1a729964383e3452c52096dc695581248b548786f2b3/setproctitle-1.1.10.tar.gz"
    sha256 "6283b7a58477dd8478fbb9e76defb37968ee4ba47b05ec1c053cb39638bd7398"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
