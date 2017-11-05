class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/debian/lbdb_0.45.tar.xz"
  sha256 "1109a787e1f0088c8b137ddf17e385ab73817132a54e4c8d6b6bd5e40c2079c2"

  bottle do
    cellar :any_skip_relocation
    sha256 "feef625ac2655df3ca39490ec70b9438aa54528ad4e48fdb52332e0ea9344995" => :high_sierra
    sha256 "24db89a55a82dbf157ce5f99f8c1da681afd0a3de32e887f0c93c756b9bf3be1" => :sierra
    sha256 "92aaed0bf05120218462c9e72bb9cf6b1f5b016621d798a29462b6679f8c99aa" => :el_capitan
  end

  depends_on "abook" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}/lbdb"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lbdbq -v")
  end
end
