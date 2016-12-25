class ProxychainsNg < Formula
  desc "Hook preloader"
  homepage "https://sourceforge.net/projects/proxychains-ng/"
  url "https://github.com/rofl0r/proxychains-ng/releases/download/v4.12/proxychains-ng-4.12.tar.xz"
  sha256 "482a549935060417b629f32ddadd14f9c04df8249d9588f7f78a3303e3d03a4e"

  head "https://github.com/rofl0r/proxychains-ng.git"

  bottle do
    sha256 "60df39b3ad0eba93a5fc3845ea6370b0ca14b6cdbbd6a12a5fbfc93efb570ead" => :sierra
    sha256 "3a54f2ae04b107b97db3a0522f06cc77c0420bf7a562a07d4938c209e34d53ca" => :el_capitan
    sha256 "336d042fcdef471d60bca6233c834db94b85c911425efba8bf442b6affc0db00" => :yosemite
    sha256 "2707450f3238082aeef0884770eabae0167d17c1029840a5ab48db0af320b254" => :mavericks
  end

  option :universal

  def install
    args = ["--prefix=#{prefix}", "--sysconfdir=#{prefix}/etc"]
    if build.universal?
      ENV.universal_binary
      args << "--fat-binary"
    end
    system "./configure", *args
    system "make"
    system "make", "install"
    system "make", "install-config"
  end

  test do
    assert_match "config file found", shell_output("#{bin}/proxychains4 test 2>&1", 1)
  end
end
