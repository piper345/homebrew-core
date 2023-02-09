class Flit < Formula
  include Language::Python::Virtualenv

  desc "Simplified packaging of Python modules"
  homepage "https://github.com/pypa/flit"
  url "https://files.pythonhosted.org/packages/28/c6/c399f38dab6d3a2518a50d334d038083483a787f663743d713f1d245bde3/flit-3.8.0.tar.gz"
  sha256 "d0f2a8f4bd45dc794befbf5839ecc0fd3830d65a57bd52b5997542fac5d5e937"
  license "BSD-3-Clause"
  head "https://github.com/pypa/flit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bd28c6b210602e16d0430cfde9bea90bc36c3f3c8df5462e8894a2a6231e615"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dbf8a9e8e9df5301a978774c79361bccb722227344b8257de66aef1f89864b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d424220d30faa14fcd391ae4acbcdcdb3b923ca4237990d85b5a15f614f5090b"
    sha256 cellar: :any_skip_relocation, ventura:        "d8c0d3c83ec706d3c8db72b4ce50fa58fd05e230e6f4bc61836c7c024fe03ad2"
    sha256 cellar: :any_skip_relocation, monterey:       "ec577206379daaaab4f712994a1a546a8a79b2b335165f374058cff750191ca9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a28df2da3dc584cc9ff6e2159e2bc0c33caadd813611d9a4aaad7b1d257762b4"
    sha256 cellar: :any_skip_relocation, catalina:       "3da182a01a57251992616c5275d64781206644df7d7d9d8d5b31636b0b7e8fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db0339e8e776366d78171427ccbd679f4566ad1715935aa1e9dc320615d37b6a"
  end

  depends_on "docutils"
  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/10/e5/be08751d07b30889af130cec20955c987a74380a10058e6e8856e4010afc/flit_core-3.8.0.tar.gz"
    sha256 "b305b30c99526df5e63d6022dd2310a0a941a187bd3884f4c8ef0418df6c39f3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/49/05/6bf21838623186b91aedbda06248ad18f03487dc56fbc20e4db384abde6c/tomli_w-1.0.0.tar.gz"
    sha256 "f463434305e0336248cac9c2dc8076b707d8a12d019dd349f5c1e382dd1ae1b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"sample.py").write <<~END
      """A sample package"""
      __version__ = "0.1"
    END
    (testpath/"pyproject.toml").write <<~END
      [build-system]
      requires = ["flit_core"]
      build-backend = "flit_core.buildapi"

      [tool.flit.metadata]
      module = "sample"
      author = "Sample Author"
    END
    system bin/"flit", "build"
    assert_predicate testpath/"dist/sample-0.1-py2.py3-none-any.whl", :exist?
    assert_predicate testpath/"dist/sample-0.1.tar.gz", :exist?
  end
end
