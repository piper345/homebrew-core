class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "http://jonas.nitro.dk/tig/"
  url "http://jonas.nitro.dk/tig/releases/tig-2.2.tar.gz"
  sha256 "8f5213d3abb45ca9a79810b8d2a2a12d941112bc4682bcfa91f34db74942754c"

  bottle do
    cellar :any
    revision 2
    sha256 "b5337100fab8fd51091f78990b2115611c052eceb29ebc37d82b9fd19eb97306" => :el_capitan
    sha256 "9b832275bee0497273da009f73620a63ceba99aa97c624827e45443a74f1fcfe" => :yosemite
    sha256 "94eb8a861d4de55088d47e626201ebe7c1f3687db11f6a689c55181a141ff78d" => :mavericks
  end

  head do
    url "https://github.com/jonas/tig.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-docs", "Build man pages using asciidoc and xmlto"

  if build.with? "docs"
    depends_on "asciidoc"
    depends_on "xmlto"
  end

  depends_on "readline" => :recommended

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    # Ensure the configured `sysconfdir` is used during runtime by
    # installing in a separate step.
    system "make", "install", "sysconfdir=#{pkgshare}/examples"
    system "make", "install-doc-man" if build.with? "docs"
    bash_completion.install "contrib/tig-completion.bash"
    zsh_completion.install "contrib/tig-completion.zsh" => "_tig"
    cp "#{bash_completion}/tig-completion.bash", zsh_completion
  end

  def caveats; <<-EOS.undent
    A sample of the default configuration has been installed to:
      #{opt_pkgshare}/examples/tigrc
    to override the system-wide default configuration, copy the sample to:
      #{etc}/tigrc
    EOS
  end
end
