class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.9.4.tar.gz"
  sha256 "d03023a57180d548c821e59ff2449564f98442e2bb8f9579cc5f3a689996505e"

  bottle do
    cellar :any_skip_relocation
    sha256 "8addc2640700160e3ce9dd6547cc5462011c047b2a953362b61c1f9a4a0cf1a2" => :sierra
    sha256 "5dc88bee0245c92e907853ab59ec8a12fa1f5cd592d78f53f93c6d64d9dbbf76" => :el_capitan
    sha256 "45e10b1de920f9acb89c4aa851199443f2897809d44bb18b932582feb51e5bd5" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "aspy.yaml" do
    url "https://files.pythonhosted.org/packages/f0/68/49af646ea5d7ea4a53209109c89a811e5b2569e802d4fcd28763cdded43c/aspy.yaml-0.2.1.tar.gz"
    sha256 "a91370183aea63c87d8487e7b399ed2d99a7c2f14b108d27c0bc8ad9ef595d9a"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/ae/02/09b905981aefb99c97ad53ac1cc0a90f02c1457a549eae98d87e8e6f2d7e/cached-property-1.3.0.tar.gz"
    sha256 "458e78b1c7286ece887d92c9bee829da85717994c5e3ddd253a40467f488bc81"
  end

  resource "functools32" do
    url "https://files.pythonhosted.org/packages/c5/60/6ac26ad05857c601308d8fb9e87fa36d0ebf889423f47c3502ef034365db/functools32-3.2.3-2.tar.gz"
    sha256 "f6253dfbe0538ad2e387bd8fdfd9293c925d63553f5813c4e587745416501e6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/0d/c816f5ea5adaf1293a1d81d32e4cdfdaf8496973aa5049786d7fdb14e7e7/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/fa/62/f3dc0d7b596f7187585520bca14c050909de88866e8f793338de907538cf/nodeenv-1.0.0.tar.gz"
    sha256 "def2a6d927bef8d17c1776edbd5bbc8b7a5f0eee159af53b9924d559fc8d3202"
  end

  resource "ordereddict" do
    url "https://files.pythonhosted.org/packages/53/25/ef88e8e45db141faa9598fbf7ad0062df8f50f881a36ed6a0073e1572126/ordereddict-1.1.tar.gz"
    sha256 "1c35b4ac206cef2d24816c89f89cf289dd3d38cf7c449bb3fab7bf6d43f01b1f"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d4/0c/9840c08189e030873387a73b90ada981885010dd9aea134d6de30cd24cb8/virtualenv-15.1.0.tar.gz"
    sha256 "02f8102c2436bb03b3ee6dede1919d1dac8a427541652e5ec95171ec8adbc93a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    testpath.cd do
      system "git", "init"
      (testpath/".pre-commit-config.yaml").write <<-EOF.undent
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          sha: 5541a6a046b7a0feab73a21612ab5d94a6d3f6f0
          hooks:
          -   id: trailing-whitespace
      EOF
      system bin/"pre-commit", "install"
      system bin/"pre-commit", "run", "--all-files"
    end
  end
end
