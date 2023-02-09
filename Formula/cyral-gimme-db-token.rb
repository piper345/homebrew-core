class CyralGimmeDbToken < Formula
  include Language::Python::Virtualenv

  desc "Eases using Cyral for SSO login to databases"
  homepage "https://cyral.com/docs/connect/repo-connect/#cli-token-retriever-for-sso"
  url "https://files.pythonhosted.org/packages/96/44/1810cb177f63217550a1cb0f38adf5652636167062e78dd6b1fb3207faf5/cyral-gimme-db-token-0.8.1.tar.gz"
  sha256 "7f49ac2410870b895118f39051264ac047d9f6537d7cbdd8828a7627681c8857"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "bc877b9568fdeda909ccc4187760bbeb02c3567269e95f3537d8aee472f8e164"
    sha256 cellar: :any,                 arm64_monterey: "f4a3f972cf49ca27292f585083229e94d5c79c30c506d054894cec18872aceea"
    sha256 cellar: :any,                 arm64_big_sur:  "044f09cab926119833653f3ea2d23ea37dba5e5242f70dce1d17f77bd309e3a8"
    sha256 cellar: :any,                 ventura:        "73015ad99174d2850ec08a18eab926a743a96d44d70fc21acacdbab4aaf9d7f7"
    sha256 cellar: :any,                 monterey:       "a6871304bad5d9d78456f85940f6d85f98c50bc2b49d020183e3871913b3d3d5"
    sha256 cellar: :any,                 big_sur:        "4c6322337b987ae8a5100ad0f98d563caa01760f641bdf26de26264122480a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "065ae3979c98d76f9254e35b1e1177c2cb97ac24632d2fa3c70fc894af8a8fb9"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "awscli" do
    url "https://files.pythonhosted.org/packages/87/4c/6b0b4b715ae5d5b6594bce69998d0c01d335ad97fc8c5ccfee4b984695a5/awscli-1.27.67.tar.gz"
    sha256 "7516f3f102d7a65afe7a003f74ed0bcb8bcb96b69d7ac9afc40e55cf52a958b4"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/fb/e3/5557a3301221e8c984344acce43af61ed2ff99cf39aefa4305e400ef3620/botocore-1.29.67.tar.gz"
    sha256 "0ccec4a906b6b8c7bb6bc5226509059ee9ed94d3cf1014487ef5b8e56801e6a3"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/a7/51953e73828deef2b58ba1604de9167843ee9cd4185d8aaffcb45dd1932d/cryptography-36.0.2.tar.gz"
    sha256 "70f8f4f7bb2ac9f340655cbac89d68c527af5bb4387522a8413e841e3e6628c9"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  # patch to use latest poetry_core to fix build
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/gimme_db_token --version")
    assert_match "There was an error fetching your token.",
      shell_output("#{bin}/gimme_db_token --address localhost --timeout 1")
    assert_match "Error: Invalid value", shell_output("#{bin}/gimme_db_token unsupported 2>&1", 2)
  end
end

__END__
diff --git a/pyproject.toml b/pyproject.toml
index f88b284..e8b5fbd 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -28,6 +28,5 @@ flake8 = "^3.8.4"
 [tool.poetry.scripts]
 gimme_db_token = "gimme_db_token.__main__:run"
 [build-system]
-requires = ["poetry>=0.12"]
-build-backend = "poetry.masonry.api"
-
+requires = ["poetry_core>=1.0.0"]
+build-backend = "poetry.core.masonry.api"
