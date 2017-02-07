class AbiComplianceChecker < Formula
  desc "Check binary and source compatibility for C/C++"
  homepage "http://ispras.linuxbase.org/index.php/ABI_compliance_checker"
  url "https://github.com/lvc/abi-compliance-checker/archive/2.0.tar.gz"
  sha256 "73194c9c00853c761b8c7c0e6fc581ae92e586884a5a7dcce2c5b556b437b6e1"

  bottle do
    cellar :any_skip_relocation
    sha256 "2dc2a2081b6429c9ea6414b2f0d44ac678e4d4163f98b5503f32f8a9776c8f6d" => :sierra
    sha256 "2dc2a2081b6429c9ea6414b2f0d44ac678e4d4163f98b5503f32f8a9776c8f6d" => :el_capitan
    sha256 "2dc2a2081b6429c9ea6414b2f0d44ac678e4d4163f98b5503f32f8a9776c8f6d" => :yosemite
  end

  depends_on "ctags"
  depends_on "gcc" => :run

  def install
    system "perl", "Makefile.pl", "-install", "--prefix=#{prefix}"
    rm bin/"abi-compliance-checker.cmd"
  end

  test do
    (testpath/"test.xml").write <<-EOS.undent
      <version>1.0</version>
      <headers>#{Formula["ctags"].include}</headers>
      <libs>/usr/lib/system</libs>
    EOS
    gcc_suffix = Formula["gcc"].version.to_s.slice(/\d/)
    system bin/"abi-compliance-checker", "-cross-gcc", "gcc-" + gcc_suffix,
                                         "-lib", "ctags",
                                         "-old", testpath/"test.xml",
                                         "-new", testpath/"test.xml"
  end
end
