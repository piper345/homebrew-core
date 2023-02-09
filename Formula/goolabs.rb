class Goolabs < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for morphologically analyzing Japanese language"
  homepage "https://pypi.python.org/pypi/goolabs"
  url "https://files.pythonhosted.org/packages/ce/86/2d3b5bd85311ee3a7ae7a661b3619095431503cd0cae03048c646b700cad/goolabs-0.4.0.tar.gz"
  sha256 "4f768a5b98960c507f5ba4e1ca14d45e3139388669148a2750d415c312281527"
  revision 5

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6827c4b62794c81fcfb40ebd97075ad112395a9d5735e1809f0ba5aa44813ba4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d911074af03f75f3c427204ba9de2c0cbde484acea50e1812083d5380c432fbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "333363cc68a5f1ea613b1f5289ae885f29aa21a4fe823b7613f0b42e1b54a743"
    sha256 cellar: :any_skip_relocation, ventura:        "8792ad356850a0d1f8d279050f804c258438af585882392fd2fce12dfa198d3c"
    sha256 cellar: :any_skip_relocation, monterey:       "12e163a6e7ec11fd896d9eddcf84f8392a28286d7185d62f3e2007c63a378713"
    sha256 cellar: :any_skip_relocation, big_sur:        "599d3c67f4d493645f2ab05624a759bda6243bb3e2b9567ae124621363fb953c"
    sha256 cellar: :any_skip_relocation, catalina:       "631ffed8f4068eb6999ed105ce79d717a890423696422ae643d0711044f64739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a291badb249a5b354d472099a450092730d23ab4ab66c0b3b9788bbe2d853972"
  end

  depends_on "python@3.11"
  depends_on "six"

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

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
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
    assert_match "Usage: goolabs morph", shell_output("#{bin}/goolabs morph test 2>&1", 2)
  end
end
