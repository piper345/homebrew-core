class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle.git",
      :tag      => "v0.9.0",
      :revision => "8fad4bdb3f6bf30408543f7b1c2b590f09ca6b39"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd88afef20d985377465de1422be8235fd9f04a82dfad5f147442f7b9400d286" => :mojave
    sha256 "138dc120fa48d6ff1dcfa002e4b1dd3ca701c1b2b9412e03a454119abd31568c" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "6.0"

  def install
    system "make", "install", "BINARY_FOLDER_PREFIX=#{prefix}"
  end

  test do
    assert_match #{version}, shell_output("#{bin}/needle version")
  end
end
