class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/61/0e/1fa3e8511829ca27e3cb129b9709c1c4578161213d6432c799e911b9dcf3/svtplay-dl-4.18.tar.gz"
  sha256 "ea813d11874671944282f1d952560ebe176af77d3aac81ca82173efa029fe081"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "d7ef07861f284a24421d67e1d624061e63468ca299bddd79e495ee806d9b7e63"
    sha256 cellar: :any,                 arm64_monterey: "7dd75d77cb3b7f9ac2113a6a5f806949cc089b02e3b6cd9f8d622408a82ecf99"
    sha256 cellar: :any,                 arm64_big_sur:  "1fc38997be334c1f75d41f9229b91886a9f626f87d686a3709ae6ab3e9842c3b"
    sha256 cellar: :any,                 ventura:        "06f920994780203a3e59f30ccf64163946e6856e33c4d104db673d57cda1f0a3"
    sha256 cellar: :any,                 monterey:       "fbb5276cec60bdc75ea21bca3e4f8a527f6bd967411e96ce04e2889f19d8fa3d"
    sha256 cellar: :any,                 big_sur:        "e5a58a9e6016529dd800a97913eeb4c0f144abe84f6a75e733f8f92e5c4eab38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a7a40bf512e7d750eba1c7a73be87281501e6089ce06bd137faff50cfd340b8"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "pyyaml"

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

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/6a/f5/a729774d087e50fffd1438b3877a91e9281294f985bda0fd15bf99016c78/cryptography-39.0.1.tar.gz"
    sha256 "d1f6198ee6d9148405e49887803907fe8962a23e6c6f83ea7d98f1c0de375695"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
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

  def caveats
    <<~EOS
      To use post-processing options:
        `brew install ffmpeg` or `brew install libav`.
    EOS
  end

  test do
    url = "https://tv.aftonbladet.se/abtv/articles/244248"
    match = "https://amd-ab.akamaized.net/ab/vod/2018/02/cdaefe0533c2561f00a41c52a2d790bd/1280_720_pkg.m3u8"
    assert_match match, shell_output("#{bin}/svtplay-dl -g #{url}")
  end
end
