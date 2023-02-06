class OscCli < Formula
  include Language::Python::Virtualenv

  desc "Official Outscale CLI providing connectors to Outscale API"
  homepage "https://github.com/outscale/osc-cli"
  url "https://files.pythonhosted.org/packages/b0/60/cd6582d56188c841bd58ce004b67c0a64b8ad855175ea574f01b0158271d/osc-sdk-1.9.0.tar.gz"
  sha256 "b6cc9b06500493ec445c073458c32b18709c6a5dd842410c3bd141efd81c7ff7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51fb8b48198ed88fbfb632630991cb1cc6f55e1ecd172e6333c88f76d91e712f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f4aa38a384a42a6f67e45e867f17b7798505b4c42accd99a06a04bf14189a78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4f67aa3d1db55152bd09d455198cea002b6d0713898649ea43792aba90e2422"
    sha256 cellar: :any_skip_relocation, ventura:        "ad0c875d8dc42bec3468e9fe27ff8027b018c3c2b52917abb2bc6261e4e0a93f"
    sha256 cellar: :any_skip_relocation, monterey:       "aac7921084a5a48453e7107436d1a1a95b314b0cc6280c26c3bccdbd7507ce67"
    sha256 cellar: :any_skip_relocation, big_sur:        "26c675002c79f590c4321c4211acda199edb487f73b0218d7828e8a4637587d2"
    sha256 cellar: :any_skip_relocation, catalina:       "2877569347709416e213796e5193717e4464d195383c8ff9e12f732f1a419d7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65d4b01674f06989bc42c32c9be9bc2c524348f616678505fe1924c7ea7f5603"
  end

  depends_on "python-typing-extensions"
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

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "fire" do
    url "https://files.pythonhosted.org/packages/94/ed/3b9a10605163f48517931083aee8364d4d6d3bb1aa9b75eb0a4a5e9fbfc1/fire-0.5.0.tar.gz"
    sha256 "a6b0d49e98c8963910021f92bba66f65ab440da2982b78eb1bbf95a0a34aacc6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/e5/4e/b2a54a21092ad2d5d70b0140e4080811bee06a39cc8481651579fe865c89/termcolor-2.2.0.tar.gz"
    sha256 "dfc8ac3f350788f23b2947b3e6cfa5a53b630b612e6cd8965a015a776020b99a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # we test the help wich is printed in stderr :(
    str = shell_output("#{bin}/osc-cli -- --help 2>&1 >/dev/null")
    assert_match "osc-cli SERVICE CALL <flags>", str
    str = shell_output("#{bin}/osc-cli api ReadVms 2>&1 >/dev/null", 1)
    assert_match "Missing Access Key for authentication", str

    mkdir testpath/".osc"
    (testpath/".osc/config.json").write <<~EOS
      {
        "default": {
          "access_key": "F4K4T706S9XKGEXAMPLE",
          "secret_key": "E4XJE8EJ98ZEJ18E4J9ZE84J19Q8E1J9S87ZEXAMPLE",
          "host": "outscale.com",
          "https": true,
          "method": "POST",
          "region_name": "eu-west-2"
        }
      }
    EOS

    str = shell_output("#{bin}/osc-cli api ReadVms 2>&1 >/dev/null", 1)
    match = "raise OscApiException(http_response)"
    assert_match match, str
  end
end
