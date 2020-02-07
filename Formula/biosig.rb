class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.io"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig4c%2B%2B-1.9.5.src.tar.gz"
  sha256 "20e72a5a07d1bf8baa649efe437b4d3ed99944f0e4dfc1fbe23bfbe4d9749ed5"

  depends_on "gawk" => :build
  depends_on "gnu-sed" => :build
  depends_on "gnu-tar" => :build
  depends_on "pkg-config" => :build
  depends_on "wget" => :build
  depends_on "dcmtk"
  depends_on "libb64"
  depends_on "suite-sparse"
  depends_on "tinyxml"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make"
    system "make", "install"
  end

  test do
    assert_match "usage: save2gdf [OPTIONS] SOURCE DEST", shell_output("#{bin}/save2gdf -h").strip
    assert_match "mV\t4274\t0x10b2\t0.001\tV", shell_output("#{bin}/physicalunits mV").strip
    assert_match "biosig_fhir provides fhir binary template for biosignal data", shell_output("#{bin}/biosig_fhir 2>&1").strip
    file = Dir::Tmpname.create(['test','.gdf']) {}
    system "wget", "https://pub.ist.ac.at/~schloegl/download/TEST_44x86_e1.GDF", "-O", file
    assert_match "1", shell_output("#{bin}/save2gdf -json "+file+" |gawk -F\"[:, ]\" '/NumberOfChannels/ {N=$(NF-1)} /ChannelNumber/ {n++; } END {print n==N;}'").strip
    assert_match "1", shell_output("#{bin}/biosig_fhir "+file+" |gawk -F\"[:, ]\" '/NumberOfChannels/ {N=$(NF-1)} /ChannelNumber/ {n++; } END {print n==N;}'").strip
    system "rm", file
  end
end
