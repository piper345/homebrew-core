class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.13.0.tar.gz"
  sha256 "9528a0dedcb9db559c9973001787f474f87559366a2c7a2ff01148c5ab31eac1"

  bottle do
    cellar :any_skip_relocation
    sha256 "470f4170caf5590f33422645208b90331cc3470003e01cb60fdeb5f6f08160f5" => :mojave
    sha256 "d17910e867451523507d48a6e34bf06c54149ea4bf0589ddbe336c497df50215" => :high_sierra
    sha256 "1437cae51de6917f1490267462ee6a6c58c0a0a2a93f7911f0ee86cdb443c24d" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
