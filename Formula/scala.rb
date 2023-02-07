class Scala < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://github.com/lampepfl/dotty/releases/download/3.3.0-RC2/scala3-3.3.0-RC2.tar.gz"
  sha256 "3bbd0ed7478cf4cfcc538c6a06fa2eea16661fbb858e941fefe0eaa65815d483"
  license "Apache-2.0"

  livecheck do
    url "https://www.scala-lang.org/download/"
    regex(%r{href=.*?download/v?(\d+(?:\.\d+)+)\.html}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5b522d89c3cb6fdc86fea19d376a18d45072731dec5e2390fb45f885c4a07f71"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"]
    libexec.install "lib"
    prefix.install "bin"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/"idea"
    idea.install_symlink libexec/"lib"
  end

  def caveats
    <<~EOS
      To use with IntelliJ, set the Scala home to:
        #{opt_prefix}/idea
    EOS
  end

  test do
    file = testpath/"Test.scala"
    file.write <<~EOS
      object Test {
        def main(args: Array[String]): Unit = {
          println(s"${2 + 2}")
        }
      }
    EOS

    out = shell_output("#{bin}/scala #{file}").strip

    assert_equal "4", out
  end
end
