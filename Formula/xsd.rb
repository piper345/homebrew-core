class Xsd < Formula
  desc "XML Data Binding for C++"
  homepage "https://www.codesynthesis.com/products/xsd/"
  url "https://www.codesynthesis.com/download/xsd/4.0/xsd-4.0.0+dep.tar.bz2"
  version "4.0.0"
  sha256 "eca52a9c8f52cdbe2ae4e364e4a909503493a0d51ea388fc6c9734565a859817"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "9ddc1f5fc81e2c034c479816439889c3daf69311d2bc4ef6f3a9363e83e999ec" => :catalina
    sha256 "c5392dc2a5daca8caf429c7a198374a35dbb540d4772ee2a463fa8b8be885bf0" => :mojave
    sha256 "ce215b2f2f5bd6536feded7c40733f7d4b51a7c0ea4aea523caca9efbc2eec7d" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "xerces-c"

  conflicts_with "mono", :because => "both install `xsd` binaries"

  # Patches:
  # 1. As of version 4.0.0, Clang fails to compile if the <iostream> header is
  #    not explicitly included. The developers are aware of this problem, see:
  #    https://www.codesynthesis.com/pipermail/xsd-users/2015-February/004522.html
  # 2. As of version 4.0.0, building fails because this makefile invokes find
  #    with action -printf, which GNU find supports but BSD find does not. There
  #    is no place to file a bug report upstream other than the xsd-users mailing
  #    list (xsd-users@codesynthesis.com). I have sent this patch there but have
  #    received no response (yet).
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/xsd/4.0.0.patch"
    sha256 "55a15b7a16404e659060cc2487f198a76d96da7ec74e2c0fac9e38f24b151fa7"
  end

  def install
    ENV.append "LDFLAGS", `pkg-config --libs --static xerces-c`.chomp
    ENV.cxx11
    system "make", "install", "install_prefix=#{prefix}"
  end

  test do
    schema = testpath/"meaningoflife.xsd"
    schema.write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified"
                 targetNamespace="https://brew.sh/XSDTest" xmlns="https://brew.sh/XSDTest">
          <xs:element name="MeaningOfLife" type="xs:positiveInteger"/>
      </xs:schema>
    EOS
    instance = testpath/"meaningoflife.xml"
    instance.write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <MeaningOfLife xmlns="https://brew.sh/XSDTest" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="https://brew.sh/XSDTest meaningoflife.xsd">
          42
      </MeaningOfLife>
    EOS
    xsdtest = testpath/"xsdtest.cxx"
    xsdtest.write <<~EOS
      #include <cassert>
      #include "meaningoflife.hxx"
      int main (int argc, char *argv[]) {
          assert(2==argc);
          std::auto_ptr< ::xml_schema::positive_integer> x = XSDTest::MeaningOfLife(argv[1]);
          assert(42==*x);
          return 0;
      }
    EOS
    system "#{bin}/xsd", "cxx-tree", schema
    assert_predicate testpath/"meaningoflife.hxx", :exist?
    assert_predicate testpath/"meaningoflife.cxx", :exist?
    system "c++", "-o", "xsdtest", "xsdtest.cxx", "meaningoflife.cxx",
                  "-L#{Formula["xerces-c"].opt_lib}", "-lxerces-c"
    assert_predicate testpath/"xsdtest", :exist?
    system testpath/"xsdtest", instance
  end
end
