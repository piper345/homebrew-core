class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.47.1.tar.gz"
  sha256 "1c47fef843812c5e2621f28bde445117bc90413e3221f72800512ed82db94c5f"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f69463f8842eb535b63779f58e44f580ae433218d393302ad27d8b474b9d2e54" => :mojave
    sha256 "07643f528ce42d579fd5ae80e8d014e48754750cab8ce654ef4a8fe473964d0b" => :high_sierra
    sha256 "17e34c5edbd3b8b6099cc49a10e444e249b1c10712160ca0e54a567b35620641" => :sierra
    sha256 "b920309a8fc5bbb53184febbaecaaae68aab68901649a049d2e09b2e3d84f052" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children
    cd "src/github.com/gohugoio/hugo" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"hugo", "-tags", "extended", "main.go"

      # Build bash completion
      system bin/"hugo", "gen", "autocomplete", "--completionfile=hugo.sh"
      bash_completion.install "hugo.sh"

      # Build man pages; target dir man/ is hardcoded :(
      (Pathname.pwd/"man").mkpath
      system bin/"hugo", "gen", "man"
      man1.install Dir["man/*.1"]

      prefix.install_metafiles
    end
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
