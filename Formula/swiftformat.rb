class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.35.8.tar.gz"
  sha256 "114cb224b1eec1df1eb5a60a625a49de8608557cb895b73d181981037621b98e"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "dc983f84a8127ebcc1a083f3601bbafdad28dd677d99de34987309dad20cdb04" => :mojave
    sha256 "e1d09d6736f0fef0f10658af3faa6827faabc3e95f1b379c667edbf9448ce6ed" => :high_sierra
    sha256 "d79edea1420ceb73d028e546bbc46366db38c6116560a1ba31d6b6842edf4c9b" => :sierra
  end

  depends_on :xcode => ["9.2", :build]

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
