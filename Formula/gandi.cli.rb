class GandiCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to Gandi.net products using the public API"
  homepage "https://cli.gandi.net/"
  url "https://files.pythonhosted.org/packages/cf/00/ff5acd1c9a0cfbb1a81a9f44ef4a745f31bb413869ae93295f8f5778cc4c/gandi.cli-1.6.tar.gz"
  sha256 "af59bf81a5a434dd3a5bc728a9475d80491ed73ce4343f2c1f479cbba09266c0"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce1f8294b2f45dd75225a93241d94d2bae8bf8adbf4d228dd30e1751797a87f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb16519dc3f206c2af1de48a0b81fca854bca655291f67146940f0e3558f2f00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8df1ad0c5ef9f749b4084c4031f3619964db740f0ad43cad5dafa2b794737b49"
    sha256 cellar: :any_skip_relocation, ventura:        "150df3899afab045028b3463416bbcb3e6802711255e5c7800faa01d7f6aba7b"
    sha256 cellar: :any_skip_relocation, monterey:       "86268b7df7927a754674c7a64db72363bed1b6990e289c3692e7440337e5f5d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "bef38c97c708cbb52c3683e5cdd8fdd9f3f96cd8150374f5a81458721e3d0e11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94ad4ab88f30cb72e6fee7a8343caa8e8951250724f62785c754c74fdd2335fa"
  end

  # https://github.com/Gandi/gandi.cli#gandi-cli
  deprecate! date: "2022-11-05", because: :deprecated_upstream

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "gandi.cli" do
    url "https://files.pythonhosted.org/packages/cf/00/ff5acd1c9a0cfbb1a81a9f44ef4a745f31bb413869ae93295f8f5778cc4c/gandi.cli-1.6.tar.gz"
    sha256 "af59bf81a5a434dd3a5bc728a9475d80491ed73ce4343f2c1f479cbba09266c0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "IPy" do
    url "https://files.pythonhosted.org/packages/64/a4/9c0d88d95666ff1571d7baec6c5e26abc08051801feb6e6ddf40f6027e22/IPy-1.01.tar.gz"
    sha256 "edeca741dea2d54aca568fa23740288c3fe86c0f3ea700344571e9ef14a7cc1a"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/gandi", "--version"
  end
end
