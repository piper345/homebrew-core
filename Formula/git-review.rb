class GitReview < Formula
  include Language::Python::Virtualenv

  desc "Submit git branches to gerrit for review"
  homepage "https://opendev.org/opendev/git-review"
  url "https://files.pythonhosted.org/packages/8e/5c/18f534e16b193be36d140939b79a8046e07f343b426054c084b12d59cf0b/git-review-2.3.1.tar.gz"
  sha256 "24e938136eecb6e6cbb38b5e2b034a286b70b5bb8b5a2853585c9ed23636014f"
  license "Apache-2.0"
  head "https://opendev.org/opendev/git-review.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "465665143bbad4a6e1cc00ffa3b3ddd3627ec508726f463b40d779d4e77f2a4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7df1495c0fb807fd2337b88a71766c59c35c4ff1d1d21e17f520a6d3e597379f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9010deaf20b3c78b9ba95ed5466534552549cab39d733ab351580118178ac7d3"
    sha256 cellar: :any_skip_relocation, ventura:        "e193a7e5655b097777bb43842558b0646a70e5a2ce4f6738d611c0dfc9052f92"
    sha256 cellar: :any_skip_relocation, monterey:       "0a62cd57c2a5ba7452e42035cba35275755f08ad00676bfd0cf4e23fc42cf0e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d40296f48a0f24261fc4e8dd8087807fb16d215803af8bc2fb499dc50e4875e0"
    sha256 cellar: :any_skip_relocation, catalina:       "e3b03b93811344d8b3ed75ef01b3ae386b50fa95ba776a5cc2137c36784387d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a910dfac976e4a18bb859f40e7235eecabc9deef41a706c4354dc6fd39116f03"
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
    man1.install Utils::Gzip.compress("git-review.1")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "git", "remote", "add", "gerrit", "https://github.com/Homebrew/brew.sh"
    (testpath/".git/hooks/commit-msg").write "# empty - make git-review happy"
    (testpath/"foo").write "test file"
    system "git", "add", "foo"
    system "git", "commit", "-m", "test"
    system "#{bin}/git-review", "--dry-run"
  end
end
