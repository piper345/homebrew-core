class Pygitup < Formula
  include Language::Python::Virtualenv

  desc "Nicer 'git pull'"
  homepage "https://github.com/msiemens/PyGitUp"
  url "https://files.pythonhosted.org/packages/55/13/2dd3d4c9a021eb5fa6d8afbb29eb9e6eb57faa56cf10effe879c9626eed1/git_up-2.2.0.tar.gz"
  sha256 "1935f62162d0e3cc967cf9e6b446bd1c9e6e9902edb6a81396065095a5a0784e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e334b7e9e18589dfc6b2d615a8746a69336d0fb54e9e675c15ead5aa4d0f19e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fef07b7a13d65448ae0570887e2d8393457b9eab037246ec791559b28f64c1d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f347a89960458f826ee638da7c95acacee1c7532fc7b392a19186d0b56718fc8"
    sha256 cellar: :any_skip_relocation, ventura:        "f88c27588eb7780db33684a8843a75a914dcd237f9415017a95c951ff45f876d"
    sha256 cellar: :any_skip_relocation, monterey:       "7bdd0ba57788f533752fd172ead77cc8875d0f73f6aa411cf8081f2fe4dac734"
    sha256 cellar: :any_skip_relocation, big_sur:        "38467c6e09fbf2c552a812770fe9f47e6eab7ac238c34b3351f41e8685bce6ad"
    sha256 cellar: :any_skip_relocation, catalina:       "a558b5e0e15a0f023e5391670c5fff6227d8a319cbcd1f0e8aad09eb27578e06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d75e1193d548457336d13ed25d9b5fadc01b1d2923edcded6e071990759f50c6"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/ef/8d/50658d134d89e080bb33eb8e2f75d17563b5a9dfb75383ea1a78e1df6fff/GitPython-3.1.30.tar.gz"
    sha256 "769c2d83e13f5d938b7688479da374c4e3d49f71549aaf462b646db9602ea6f8"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/e5/4e/b2a54a21092ad2d5d70b0140e4080811bee06a39cc8481651579fe865c89/termcolor-2.2.0.tar.gz"
    sha256 "dfc8ac3f350788f23b2947b3e6cfa5a53b630b612e6cd8965a015a776020b99a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "git", "clone", "https://github.com/Homebrew/install.git"
    cd "install" do
      assert_match "Fetching origin", shell_output("#{bin}/git-up")
    end
  end
end
