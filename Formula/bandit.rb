class Bandit < Formula
  include Language::Python::Virtualenv

  desc "Security-oriented static analyser for Python code"
  homepage "https://github.com/PyCQA/bandit"
  url "https://files.pythonhosted.org/packages/39/36/a37a2f6f8d0ed8c3bc616616ed5019e1df2680bd8b7df49ceae80fd457de/bandit-1.7.4.tar.gz"
  sha256 "2d63a8c573417bae338962d4b9b06fbc6080f74ecd955a092849e1e65c717bd2"
  license "Apache-2.0"
  head "https://github.com/PyCQA/bandit.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "915f962f89f0cf0ae432a4fc72901c4529a66a280b22a6d44306efcdc716ff80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1e17670712be6fee6d21317c108098e3d5144708d133f218deeeaa797c9d98b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43bd465a694df50d4c6d305d947ee3df3b9d011629a6070ea4960af73a0aa991"
    sha256 cellar: :any_skip_relocation, ventura:        "c94f859d5644ac37a62613030f07da6b73865b993ece6a0501d7692e87be8906"
    sha256 cellar: :any_skip_relocation, monterey:       "058d08e4c08317f2516696e3ab71e4145ab8d48106a26edb84be0a2e9c066ba0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9abf0e13a3b93ee4711cb3524b8e404a5e0dc17ed1c17174477a888218e85eb"
    sha256 cellar: :any_skip_relocation, catalina:       "c4d190831b21b6110bb3eab21f79406e94b196a57188a744fa137b45fcc00552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20277723685bcd548b17fcf4639d6ba3bbc3a1638c091b5612816d04f7eb2d15"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/ef/8d/50658d134d89e080bb33eb8e2f75d17563b5a9dfb75383ea1a78e1df6fff/GitPython-3.1.30.tar.gz"
    sha256 "769c2d83e13f5d938b7688479da374c4e3d49f71549aaf462b646db9602ea6f8"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/66/c0/26afabea111a642f33cfd15f54b3dbe9334679294ad5c0423c556b75eba2/stevedore-4.1.1.tar.gz"
    sha256 "7f8aeb6e3f90f96832c301bff21a7eb5eefbe894c88c506483d355565d88cc1a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "assert True\n"
    output = JSON.parse shell_output("#{bin}/bandit -q -f json test.py", 1)
    assert_equal output["results"][0]["test_id"], "B101"
  end
end
