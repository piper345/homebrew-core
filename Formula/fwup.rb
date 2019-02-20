class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.3.0/fwup-1.3.0.tar.gz"
  sha256 "aa273338c4b3813c7c9ffe2397a20ff88a882db2049be70c01fd3ed0657abef6"

  bottle do
    cellar :any
    sha256 "a642ee6d079846d02b0e68bf7f4d6da7bf179f08b819e052719ff29469716e3b" => :mojave
    sha256 "bb4e3dc6ae8360a136d3022278f4ad30da969b15e79498b06b42b8d37e6ce996" => :high_sierra
    sha256 "b94a1346afa38232cc8b03199cd013b37bbfb471d67b7e5123382c8ae1bce070" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"
  depends_on "libsodium"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_predicate testpath/"fwup-key.priv", :exist?, "Failed to create fwup-key.priv!"
    assert_predicate testpath/"fwup-key.pub", :exist?, "Failed to create fwup-key.pub!"
  end
end
