class Keepassc < Formula
  desc "Curses-based password manager for KeePass v.1.x and KeePassX"
  homepage "https://raymontag.github.com/keepassc/"
  url "https://github.com/raymontag/keepassc/archive/1.7.0.tar.gz"
  sha256 "218537f6a16f70d907d22a23d1a4dec952d7622c65fae65f03c9ee98e64938dd"
  revision 4
  head "https://github.com/raymontag/keepassc.git", :branch => "development"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d09e806b0e04814f8b0c170e45d146496d366553d17c2b7b11bdd1d8cd2baa1e" => :high_sierra
    sha256 "0712ec8fc3fe4dcd2041d670d043a165ccecc4c8947b37ff85a00adee5b16105" => :sierra
    sha256 "c021ab1902760b3756f60dd58bb015d66d32d0ead96312ba6f7d96d217506218" => :el_capitan
  end

  depends_on "python"

  resource "pycrypto" do
    # homepage "https://www.dlitz.net/software/pycrypto"
    url "https://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "kppy" do
    # homepage "https://github.com/raymontag/kppy"
    url "https://github.com/raymontag/kppy/archive/1.4.0.tar.gz"
    sha256 "a7ebcb7a13b037aada2785ca19cbc1ecaf0351ffa422ca6b487ece0b09ce1c10"
  end

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python#{pyver}/site-packages"
    install_args = %W[setup.py install --prefix=#{libexec}]

    resource("pycrypto").stage { system "python3", *install_args }
    resource("kppy").stage { system "python3", *install_args }

    system "python3", *install_args

    man1.install Dir["*.1"]

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # Fetching help is the only non-interactive action we can perform, and since
    # interactive actions are un-scriptable, there nothing more we can do.
    system "#{bin}/keepassc", "--help"
  end
end
