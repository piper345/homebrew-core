class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1347.tar.gz"
  sha256 "8a96786fb77a5e2ba15ad7e399fec858c7621a6313150bd05a54bd7b4a37d043"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "db4087dcf0cfac3cbbe2e5d504518879c9bf33d61ccddae74cd9deaf5f2566fd" => :mojave
    sha256 "c3932441462ac191c90a72c83f85fa60661321f42eb7c11ba9c476077ccb9396" => :high_sierra
    sha256 "468a25dfa726d5a08dfd24d471444398aa70f2fcd2b3cac5a3530c92397af27a" => :sierra
  end

  depends_on "python"
  depends_on "rtmpdump"

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
