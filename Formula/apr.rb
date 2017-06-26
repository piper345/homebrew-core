class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-1.6.2.tar.bz2"
  sha256 "09109cea377bab0028bba19a92b5b0e89603df9eab05c0f7dbd4dd83d48dcebd"

  bottle do
    cellar :any
    sha256 "e0910c1ed5f30fce7f5217df336266cb756f1029ec03b182275d545c45227683" => :sierra
    sha256 "139b7ebcd78d7bb48bb7bdf4899b8aad58b533a4d030c921b3f642ac88c242ac" => :el_capitan
    sha256 "f9b1df884df3f058c58bb80fe0bb58d5c45a1122288c7281a801dcc771b2e804" => :yosemite
  end

  keg_only :provided_by_osx, "Apple's CLT package contains apr"

  def install
    ENV["SED"] = "sed" # prevent libtool from hardcoding sed path from superenv

    # https://bz.apache.org/bugzilla/show_bug.cgi?id=57359
    # The internal libtool throws an enormous strop if we don't do...
    ENV.deparallelize

    # Stick it in libexec otherwise it pollutes lib with a .exp file.
    system "./configure", "--prefix=#{libexec}"
    system "make", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # No need for this to point to the versioned path.
    inreplace libexec/"bin/apr-1-config", libexec, opt_libexec
  end

  test do
    assert_match opt_libexec.to_s, shell_output("#{bin}/apr-1-config --prefix")
  end
end
