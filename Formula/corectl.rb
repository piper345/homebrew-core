class Corectl < Formula
  desc "CoreOS over OS X made very simple"
  homepage "https://github.com/TheNewNormal/corectl"
  url "https://github.com/TheNewNormal/corectl/archive/v0.7.13.tar.gz"
  sha256 "2fefce853a39b00722c2e2b50b5cde106328915e367f5c8e2e8c216a7d721e0b"
  head "https://github.com/TheNewNormal/corectl.git", :branch => "golang"

  bottle do
    cellar :any_skip_relocation
    sha256 "abc5239afa2baed2c13c8c6202e41fb4f8e34a8e0bcbb1496d2e5b3dc350734d" => :el_capitan
    sha256 "f63e731861bf5f59bdb8f1297c8d1b55347cd3262c569081ce244c49099b872d" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on :macos => :yosemite

  def install
    ENV["GOPATH"] = buildpath

    opamroot = buildpath/"opamroot"
    opamroot.mkpath
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    path = buildpath/"src/github.com/TheNewNormal/#{name}"
    path.install Dir["*"]

    args = []
    args << "VERSION=#{version}" if build.stable?

    cd path do
      system "opam", "init", "--no-setup"
      qcow_format_revision = build.head? ? "master" : "96db516d97b1c3ef2c7bccdac8fb6cfdcb667a04"
      system "opam", "pin", "add", "qcow-format",
        "https://github.com/mirage/ocaml-qcow.git##{qcow_format_revision}"
      system "opam", "install", "uri", "qcow-format", "ocamlfind"

      system "make", "tarball", *args

      bin.install Dir["bin/*"]

      man1.install Dir["documentation/man/*.1"]
      pkgshare.install "examples"
    end
  end

  def caveats; <<-EOS.undent
    Starting with 0.7 "corectl" has a client/server architecture. So before you
    can use the "corectl" cli, you have to start the server daemon:

    $ corectld start

    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/corectl version")
  end
end
