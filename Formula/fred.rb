class Fred < Formula
  include Language::Python::Virtualenv

  desc "Fully featured FRED Command-line Interface & Python API wrapper"
  homepage "https://fred.stlouisfed.org/docs/api/fred/"
  url "https://files.pythonhosted.org/packages/1e/7a/bb49f22f2ce33109ce5a5f8c7b85263cbc97bf9c9b44ba612c8380d3406f/fred-py-api-1.1.0.tar.gz"
  sha256 "f1eddf12fac2f26f656e317a11f61ec0129ba353187b659c20d05a600dba78c8"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dd3e5fd76f56869bafc86a628891ff70cceac1059ac959723c48b81649ae367"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f64bc97b0a130bd6c7712cb49ffea8cf4ba3771cb9f38ef8c5b96e88ae71473"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3b33a42e371193eb507ad2b721e227c7130e7b7dcf7fb14ae469a551b138b96"
    sha256 cellar: :any_skip_relocation, ventura:        "678069963f75aa2295140390f058cadd86027f9707d109b483f1eaebd705e166"
    sha256 cellar: :any_skip_relocation, monterey:       "c4c3e0d78e863f9e0e5c5a423cea6ea5b2f6519e00ef3efc9271c43636f937f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a3c20a1ee1d21326be1e4f3a12962a896b7ac952fb8f0bb839b1b40c883ed0f"
    sha256 cellar: :any_skip_relocation, catalina:       "b3f2d155cfc44272e88c069c79660a3126f53f2596e1bc401a41bbc8a3e7ac6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "716a01f678e2088968bd745dc55d99d5a4a79ff3aeb297c2e223072b8c5a21ab"
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
  end

  test do
    # assert output & ensure exit code is 2
    # NOTE: this makes an API request to FRED with a purposely invalid API key
    assert_match \
      shell_output("#{bin}/fred --api-key sqwer1234asdfasdfqwer1234asdfsdf categories get-category -i 15", 2), \
      "Bad Request.  The value for variable api_key is not registered."
  end
end
