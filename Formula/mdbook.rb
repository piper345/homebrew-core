class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang-nursery/mdBook/archive/v0.3.5.tar.gz"
  sha256 "73258ba3713004e06675ef2a1fbd3e7b48eb144db37c5ac1e2b96086b51a6e87"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "653a644e869dc4416eea183c203f2e85189d02835dab29aedad70268e1c8730e" => :catalina
    sha256 "cb341f1231e146408d19ed63a6e313af57a20bac85f95c8673f19e70d8ab1e90" => :mojave
    sha256 "f1c95b99c7a5b372da9687983d6244955abb8aeb3295c3b26d52a18a97ca1283" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system "#{bin}/mdbook", "build"
  end
end
