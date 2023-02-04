class Grokmirror < Formula
  include Language::Python::Virtualenv

  desc "Framework to smartly mirror git repositories"
  homepage "https://github.com/mricon/grokmirror"
  url "https://files.pythonhosted.org/packages/b0/ef/ffad6177d84dafb7403ccaca2fef735745d5d43200167896a2068422ae89/grokmirror-2.0.11.tar.gz"
  sha256 "6bc1310dc9a0e97836201e6bb14ecbbee332b0f812b9ff345a8386cb267c908c"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/mricon/grokmirror.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f150f165e9b344bdd451af27884677d636af72239d1168914b5b58377ce22aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3247fcb790e5bf02062162e65ee093bf6c33528a2f734e472bc259ea7b36ae02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3fa6d1cab11e8a5420fb936a5e0815f4913fa3c228316820fd489b02c7c4141"
    sha256 cellar: :any_skip_relocation, ventura:        "12024c31b1e067f1028b2a089838ad8da3cd195aeb48b4a34591e3344a8be60d"
    sha256 cellar: :any_skip_relocation, monterey:       "1021e03076c4b6851ecd9edc8916024e839e1731d10dcfc60799f01aae79e28c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc8fb3248cde8ca25f41c572e33250e7b74d77864366a3419457a57d9ba02d62"
    sha256 cellar: :any_skip_relocation, catalina:       "711286b10063e47357abfdd277c1fdb12aa5c6bdd147c0f94349ea12aab51156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46fc238fa908a5e27b3ff868f028d26b00ffce7963cd09ec09ed6a498a649e6a"
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
    mkdir "repos/repo" do
      system "git", "init"
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@test.com"
      (testpath/"repos/repo/test").write "foo"
      system "git", "add", "test"
      system "git", "commit", "-m", "Initial commit"
      system "git", "config", "--bool", "core.bare", "true"
      mv testpath/"repos/repo/.git", testpath/"repos/repo.git"
    end
    rm_rf testpath/"repos/repo"

    system bin/"grok-manifest", "-m", testpath/"manifest.js.gz", "-t", testpath/"repos"
    system "gzip", "-d", testpath/"manifest.js.gz"
    refs = Utils.safe_popen_read("git", "--git-dir", testpath/"repos/repo.git", "show-ref")
    manifest = JSON.parse (testpath/"manifest.js").read
    assert_equal Digest::SHA1.hexdigest(refs), manifest["/repo.git"]["fingerprint"]
  end
end
