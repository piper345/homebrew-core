class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v0.6.0.tar.gz"
  sha256 "1226240f8ed7f5faafbff6d93e5802c7959c4b40f9212ac6f020d67ef3aa599e"
  head "https://github.com/janet-lang/janet.git"

  def install
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
  end
end
