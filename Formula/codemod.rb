class Codemod < Formula
  include Language::Python::Virtualenv

  desc "Large-scale codebase refactors assistant tool"
  homepage "https://github.com/facebook/codemod"
  url "https://files.pythonhosted.org/packages/9b/e3/cb31bfcf14f976060ea7b7f34135ebc796cde65eba923f6a0c4b71f15cc2/codemod-1.0.0.tar.gz"
  sha256 "06e8c75f2b45210dd8270e30a6a88ae464b39abd6d0cab58a3d7bfd1c094e588"
  revision 2
  version_scheme 1
  head "https://github.com/facebook/codemod.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e638db8882fb60037af07c712de325990144b4e9fc891fab3c903f514251a7f" => :catalina
    sha256 "46a429f995bc5491ef76d75c3fd850aae40e5414ead2080361f06e69a39c79ec" => :mojave
    sha256 "cbf4fa912e1a717b55992756b44d10e7eb8640cc541d255625cecb0e65c41377" => :high_sierra
    sha256 "cbf4fa912e1a717b55992756b44d10e7eb8640cc541d255625cecb0e65c41377" => :sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    # work around some codemod terminal bugs
    ENV["TERM"] = "xterm"
    ENV["LINES"] = "25"
    ENV["COLUMNS"] = "80"
    (testpath/"file1").write <<~EOS
      foo
      bar
      potato
      baz
    EOS
    (testpath/"file2").write <<~EOS
      eeny potato meeny miny moe
    EOS
    system bin/"codemod", "--include-extensionless", "--accept-all", "potato", "pineapple"
    assert_equal %w[foo bar pineapple baz], File.read("file1").lines.map(&:strip)
    assert_equal ["eeny pineapple meeny miny moe"], File.read("file2").lines.map(&:strip)
  end
end
