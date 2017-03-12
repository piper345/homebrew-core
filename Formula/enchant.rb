class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://www.abisource.com/projects/enchant/"
  url "https://www.abisource.com/downloads/enchant/1.6.0/enchant-1.6.0.tar.gz"
  sha256 "2fac9e7be7e9424b2c5570d8affe568db39f7572c10ed48d4e13cddf03f7097f"

  bottle do
    rebuild 1
    sha256 "84c1b1857bc1f2e5ba97c831bd924b01e582da2671125499c6a87bfe9088296a" => :sierra
    sha256 "fe3948c3808bff35cca07f1af0ae0f413a3028390221f954ed9b91288b954912" => :el_capitan
    sha256 "7faced005fef7c06c35ef932ce7572d1e09dfa86520a4e53cf5e27583af57a05" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :python => :optional
  depends_on "glib"
  depends_on "aspell"

  # https://pythonhosted.org/pyenchant/
  resource "pyenchant" do
    url "https://pypi.python.org/packages/source/p/pyenchant/pyenchant-1.6.5.tar.gz"
    sha256 "623f332a9fbb70ae6c9c2d0d4e7f7bae5922d36ba0fe34be8e32df32ebbb4f84"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-ispell",
                          "--disable-myspell"
    system "make", "install"

    if build.with? "python"
      resource("pyenchant").stage do
        # Don't download and install distribute now
        inreplace "setup.py", "distribute_setup.use_setuptools()", ""
        ENV["PYENCHANT_LIBRARY_PATH"] = lib/"libenchant.dylib"
        system "python", "setup.py", "install", "--prefix=#{prefix}",
                              "--single-version-externally-managed",
                              "--record=installed.txt"
      end
    end
  end

  test do
    text = "Teh quikc brwon fox iumpz ovr teh lAzy d0g"
    enchant_result = text.sub("fox ", "").split.join("\n")
    file = "test.txt"
    (testpath/file).write text
    assert_equal enchant_result, shell_output("#{bin}/enchant -l #{file}").chomp
  end
end
