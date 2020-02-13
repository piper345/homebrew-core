class B3sum < Formula
  desc "The BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/0.2.0.tar.gz"
  sha256 "62aa27ef51f2cad6ffa49d311bf29d7d0e293f7a04f3cc07ce78bc6ad8e84db7"

  bottle do
    cellar :any_skip_relocation
    sha256 "479c9b7a5c7d0af3ed8a405abe275584e44586a87c9d74ba4bdad110afaf2ab3" => :catalina
    sha256 "42938edd2110cd65cab1451492734fbcae87e30d6cf41884cfe0cace42d66e94" => :mojave
    sha256 "0dbce5bea8f31c28aae9a4842366bfebce1755f0334c41e51ddf005ba77378d1" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "./b3sum/"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}/b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end
