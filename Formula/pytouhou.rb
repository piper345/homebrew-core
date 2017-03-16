class Pytouhou < Formula
  desc "Libre implementation of Touhou 6 engine"
  homepage "https://pytouhou.linkmauve.fr/"
  url "https://hg.linkmauve.fr/touhou", :revision => "5270c34b4c00", :using => :hg
  version "634"
  head "https://hg.linkmauve.fr/touhou", :using => :hg

  bottle do
    cellar :any
    rebuild 1
    sha256 "0488097defbddd7e9bbd5d1f940593de01b84001390ad4a83832c3deed99b902" => :sierra
    sha256 "233816097a7e9941bc05ece0c32798ff8b22c3294483f00eb0a2eb8fa6618b92" => :el_capitan
    sha256 "392dc1c0918d747a97c1375a4b88e0724056a411b4e68c54210479627a126995" => :yosemite
  end

  option "with-demo", "Install demo version of Touhou 6"

  depends_on :python3
  depends_on "pkg-config" => :build
  depends_on "libepoxy"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"
  depends_on "gtk+3" => :recommended
  if build.with? "gtk+3"
    depends_on "py3cairo" # FIXME: didn't get picked up by pygobject3 below
    depends_on "pygobject3" => "with-python3"
  end

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/b7/67/7e2a817f9e9c773ee3995c1e15204f5d01c8da71882016cac10342ef031b/Cython-0.25.2.tar.gz"
    sha256 "f141d1f9c27a07b5a93f7dc5339472067e2d7140d1c5a9e20112a5665ca60306"
  end

  resource "demo" do
    url "http://www16.big.or.jp/~zun/data/soft/kouma_tr013.lzh"
    sha256 "77ea64ade20ae7d890a4b0b1623673780c34dd2aa48bf2410603ade626440a8b"
  end

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{pyver}/site-packages"
    resource("Cython").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    # hg can't determine revision number (no .hg on the stage)
    inreplace "setup.py", /(version)=.+,$/, "\\1='#{version}',"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{pyver}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    if build.with? "demo"
      resource("demo").stage do
        (pkgshare/"game").install Dir["東方紅魔郷　体験版/*"]
      end
    end

    # Set default game path to pkgshare
    inreplace "#{libexec}/bin/pytouhou", /('path'): '\.'/, "\\1: '#{pkgshare}/game'"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats
    s = <<-EOS.undent
    The default path for the game data is:
      #{pkgshare}/game
    EOS
    if build.with? "demo"
      s += <<-EOS.undent
      Demo version of Touhou 6 has been installed.
      EOS
    end
    s
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "#{bin}/pytouhou", "--help"
  end
end
