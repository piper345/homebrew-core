class Waybackpy < Formula
  include Language::Python::Virtualenv

  desc "Wayback Machine API interface & command-line tool"
  homepage "https://pypi.org/project/waybackpy/"
  url "https://files.pythonhosted.org/packages/34/ab/90085feb81e7fad7d00c736f98e74ec315159ebef2180a77c85a06b2f0aa/waybackpy-3.0.6.tar.gz"
  sha256 "497a371756aba7644eb7ada0ebd4edb15cb8c53bc134cc973bf023a12caff83f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "203d0696cda06d03a3f0b909a10a4241308e807aa172b9cb116959957e30189f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a99fd25b6c9efbcfcf9713d5df5f837d504cf75c5821b70a393899b93565d5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7e37f1a14753480fa41e0565de432f3d1fc6cc4a9dc3b6f310bd96b9c0d90c5"
    sha256 cellar: :any_skip_relocation, ventura:        "8c90b9b262f58114a07ef869f0e3c24782abdda330f08da78c04ef4824ec5a7c"
    sha256 cellar: :any_skip_relocation, monterey:       "c0af8229a0cc143daab0d884b4ca7e486fe00caad22264705ddd94594b09cae0"
    sha256 cellar: :any_skip_relocation, big_sur:        "786d6e6760ca75a613d324b36b22d7ed8e9ff1581b61f7ff4d74feaf0e772064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a49fd06be723daa5d3216efe791fc6be5606f7ba3abd85feaa55550431d6f131"
  end

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
    bin.install_symlink libexec/"bin/waybackpy"
  end

  test do
    output = shell_output("#{bin}/waybackpy -o --url https://brew.sh")
    assert_match "20130328163936", output
  end
end
