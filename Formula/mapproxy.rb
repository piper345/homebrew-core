class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/db/98/d8805c5434d4b636cd2b71d613148b2096d36ded5b6f6ba0e7325d03ba2b/MapProxy-1.15.1.tar.gz"
  sha256 "4952990cb1fc21f74d0f4fc1163fe5aeaa7b04d6a7a73923b93c6548c1a3ba26"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "96633af64e88279cbf3062095ca96ef95522835bbfc20e81f3b068a1b7fb449c"
    sha256 cellar: :any,                 arm64_monterey: "ff955bf3cafc207cff54ede86ab9af6a26e82a1f926e17992f8c689b9ba19640"
    sha256 cellar: :any,                 arm64_big_sur:  "5ea6bc9610c648de888b0553c82353d9dc91dae631f27ba90b6394365d1e4e51"
    sha256 cellar: :any,                 ventura:        "ef3e2cb7cce260a2cdb614c4a1f77729ac3f46221279aaada1e9eb252df31e05"
    sha256 cellar: :any,                 monterey:       "7ac2bdd48c416aeebb081af7d7607400c6b23be9e5e9e3b98f7827f493d3adbd"
    sha256 cellar: :any,                 big_sur:        "c65306fdb99cb9ee7b1326809733b0cd25a20279091b6a1c79242bce50caf044"
    sha256 cellar: :any,                 catalina:       "e7aee9b2bbcf914c1b8afd11cdc95ce91e0ea14c475bb777df0ad037a405ed08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55110b267f859d8f690573f3df112fd02c8fe8bfc5303e5b6d92b30feb462e3b"
  end

  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/c0/fc/fd53e45d2ad5862d32ab8614e70c3c1f52a8e0d8bd243ee6a23b6a481b4a/pyproj-3.4.1.tar.gz"
    sha256 "261eb29b1d55b1eb7f336127344d9b31284d950a9446d1e0d1c2411f7dd8e3ac"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath/"seed.yaml", :exist?
  end
end
