class ApibuilderCli < Formula
  desc "Command-line interface to generate clients for api builder"
  homepage "https://www.apibuilder.io"
  url "https://github.com/apicollective/apibuilder-cli/archive/0.1.7.tar.gz"
  sha256 "69a828ebb11270fbc507042d140c54a46ba8050b723fc75f55104f78abc13be9"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d76d7c779ca31f4d1fa5e76fcb1c9719fca10b32bcad088d2488e8b6d22ba39" => :sierra
    sha256 "5d76d7c779ca31f4d1fa5e76fcb1c9719fca10b32bcad088d2488e8b6d22ba39" => :el_capitan
    sha256 "5d76d7c779ca31f4d1fa5e76fcb1c9719fca10b32bcad088d2488e8b6d22ba39" => :yosemite
  end

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"config").write <<-EOS.undent
      [default]
      token = abcd1234
    EOS
    assert_match "Profile default:", shell_output("#{bin}/read-config --path config")
    assert_match "**ERROR** Could not find apibuilder configuration directory. Expected at: ~/.apibuilder\n",
      shell_output("#{bin}/apibuilder", 1)
  end
end
