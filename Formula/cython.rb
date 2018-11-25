class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/f0/f8/7f406aac4c6919d5a4ce16509bbe059cd256e9ad94bae5ccac14094b7c51/Cython-0.29.1.tar.gz"
  sha256 "18ab7646985a97e02cee72e1ddba2e732d4931d4e1732494ff30c5aa084bfb97"

  bottle do
    cellar :any_skip_relocation
    sha256 "5adf6fa2be79d71c4d3138ae55ad13b64885c7aeaa450edcac5152af9ad3861d" => :mojave
    sha256 "4e8a563c4fcdfd7db328ce032152c7d96011218e252b339b0b5f75cf9e537125" => :high_sierra
    sha256 "cbff150f493474f6250ddcf997625e3e0476e3948e40a50d80be19492cadc52d" => :sierra
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    system "python3", "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("python3 -c 'import package_manager'")
  end
end
