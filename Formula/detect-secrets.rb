class DetectSecrets < Formula
  include Language::Python::Virtualenv

  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https://github.com/Yelp/detect-secrets"
  url "https://files.pythonhosted.org/packages/f1/55/292f9ce52bba7f3df0a9cde65dabf458d3aeec6a63bf737e5a5fa9fe6d31/detect_secrets-1.4.0.tar.gz"
  sha256 "d56787e339758cef48c9ccd6692f7a094b9963c979c9813580b0169e41132833"
  license "Apache-2.0"
  head "https://github.com/Yelp/detect-secrets.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7031eb88670ddce6debdd065845964eedb4e76861cd18173c4c292bf46e91894"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1622566470e48ee2ebad364f0e55ef38c15287e7ba32a0684ab8f2e2fa4cb3eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "183fe37e5115b2bbc4de9262ecf3bc3dd826201f45ab09e54c36fc231255fd21"
    sha256 cellar: :any_skip_relocation, ventura:        "1f76cfc33331a7fb3b76b93d7d45b297462f20dd4ad11c0a0c8954425f9535bd"
    sha256 cellar: :any_skip_relocation, monterey:       "eaa33b66b295b5cebfce5bc2466b0b75ce366e486103eb91d049c052d569e650"
    sha256 cellar: :any_skip_relocation, big_sur:        "0830609eb2780349a180dfa53ae9d0cc2c294d0ad963697365b6c0d593245be8"
    sha256 cellar: :any_skip_relocation, catalina:       "22929cf2fb7109b11e718c01178c171bdcf639d390a0b57a133fccfe96ab0369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6653e0c83e9a1725e6c6915fcab0f2237930b19e44dcfc05bebf04435d47f3c9"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
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
    assert_match "ArtifactoryDetector", shell_output("#{bin}/detect-secrets scan --list-all-plugins 2>&1")
  end
end
