class Pyqt < Formula
  include Language::Python::Virtualenv

  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/download5"
  url "https://www.riverbankcomputing.com/static/Downloads/PyQt5/5.13.2/PyQt5-5.13.2.tar.gz"
  sha256 "adc17c077bf233987b8e43ada87d1e0deca9bd71a13e5fd5fc377482ed69c827"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "c3e2354b324a380fee65658f87b22ec03bc3ac81538786d9148d0524de72cdac" => :catalina
    sha256 "3400e6944a13f80b02bbd44f634aadd6caee0c00012ab0170f922d00fe2e758b" => :mojave
    sha256 "7dbe8e7e69eeda102bae7cae9f6f1ccae9c73ea9662643df1534b66a9e8a70cc" => :high_sierra
  end

  depends_on "python"
  depends_on "qt"
  depends_on "sip"

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resource("PyQt-builder")

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    system "sip-install", "--confirm-license",
                          "--verbose",
                          "--target-dir", "#{lib}/python#{version}/site-packages"
  end

  test do
    system "#{bin}/pyuic5", "--version"
    system "#{bin}/pylupdate5", "-version"

    system "python3", "-c", "import PyQt5"
    %w[
      Gui
      Location
      Multimedia
      Network
      Quick
      Svg
      Widgets
      Xml
    ].each { |mod| system "python3", "-c", "import PyQt5.Qt#{mod}" }
  end
end
