class Mill < Formula
  desc "Scala build tool"
  homepage "https://com-lihaoyi.github.io/mill/mill/Intro_to_Mill.html"
  url "https://github.com/com-lihaoyi/mill/releases/download/0.11.0-M3/0.11.0-M3-assembly"
  version "0.11.0-M3"
  sha256 "b319bfd31bca57473fe4fd2e79b9d304c9f7e6d000e5c26550f952f7eb62be6e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3dce0c38f4a4a108a42177f58d7a5dbc94771cd0eb73186346ac3a23958d04df"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"].shift => "mill"
    chmod 0555, libexec/"mill"
    (bin/"mill").write_env_script libexec/"mill", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"build.sc").write <<~EOS
      import mill._
      import mill.scalalib._
      object foo extends ScalaModule {
        def scalaVersion = "2.12.8"
      }
    EOS
    output = shell_output("#{bin}/mill resolve __.compile")
    assert_equal "foo.compile", output.lines.last.chomp
  end
end
