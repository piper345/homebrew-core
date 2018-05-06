class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2018.04.13/kakoune-2018.04.13.tar.bz2"
  sha256 "cd8ccf8d833a7de8014b6d64f0c34105bc5996c3671275b00ced77996dd17fce"
  head "https://github.com/mawww/kakoune.git"

  option "with-debug", "Build with debugging symbols"

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    cd "src" do
      args = %W[PREFIX=#{prefix}]
      args << "debug=no" if build.without?("debug")
      system "make", "install", *args
    end
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"
  end
end
