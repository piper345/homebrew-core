class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://github.com/adrienverge/yamllint/archive/v1.11.1.tar.gz"
  sha256 "56221b7c0a50b1619e491eb157624a5d1b160c1a4f019d64f117268f42fe4ca4"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1a676a97330c981f2f1c849e705e02bdfc9f5bf82630fea724439c36be51b633" => :high_sierra
    sha256 "f7a9f20e2262fd6b7fefe4f89f147d7bdd12eeef249014a1ca89489555f69bfe" => :sierra
    sha256 "98c8c2124dbe032f0d7ede3eb6a763319797f06b8018ec0c4732302d2c1b6f2e" => :el_capitan
  end

  depends_on "libyaml"
  depends_on "python"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5e/59/d40bf36fda6cc9ec0e2d2d843986fa7d91f7144ad83e909bcb126b45ea88/pathspec-0.5.6.tar.gz"
    sha256 "be664567cf96a718a68b33329862d1e6f6803ef9c48a6e2636265806cfceb29d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"bad.yaml").write <<~EOS
      ---
      foo: bar: gee
    EOS
    output = shell_output("#{bin}/yamllint -f parsable -s bad.yaml", 1)
    assert_match "syntax error: mapping values are not allowed here", output

    (testpath/"good.yaml").write <<~EOS
      ---
      foo: bar
    EOS
    assert_equal "", shell_output("#{bin}/yamllint -f parsable -s good.yaml")
  end
end
