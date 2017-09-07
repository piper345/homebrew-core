class Ccm < Formula
  desc "Create and destroy an Apache Cassandra cluster on localhost"
  homepage "https://github.com/pcmanus/ccm"
  url "https://files.pythonhosted.org/packages/26/8a/8bb98faa4ec409efca803d6252ab424a47b7b0ff81f345b1f2813766751e/ccm-2.8.4.tar.gz"
  sha256 "8d46669127b4fbd517bc06488e1215475e3850fc97f565c092aa964ecb7674e9"
  head "https://github.com/pcmanus/ccm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9f38ff936f7d68c7be0b0abf10350f3a98ab65a504c4c898d1edc9527167daf" => :sierra
    sha256 "13b51a59bdf8b794b5c9c9c6c4541a6ef07a7e3a45883358674fc04cb84af2c2" => :el_capitan
    sha256 "13b51a59bdf8b794b5c9c9c6c4541a6ef07a7e3a45883358674fc04cb84af2c2" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[PyYAML six].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ccm", 1)
  end
end
