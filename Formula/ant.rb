class Ant < Formula
  desc "Java build tool"
  homepage "https://ant.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=ant/binaries/apache-ant-1.10.1-bin.tar.xz"
  sha256 "51dd6b4ec740013dc5ad71812ce5d727a9956aa3a56de7164c76cbd70d015d79"
  revision 1
  head "https://git-wip-us.apache.org/repos/asf/ant.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "63799966f2b50a3192da9a11f6bb23c22a391490a4cb3d1b654a2c5dd5be60bd" => :high_sierra
    sha256 "7a98be29b1905c8c90217d795d4f61408fecd642cee2e9266b360b836097171c" => :sierra
    sha256 "7a98be29b1905c8c90217d795d4f61408fecd642cee2e9266b360b836097171c" => :el_capitan
  end

  keg_only :provided_by_osx if MacOS.version < :mavericks

  option "with-bcel", "Install Byte Code Engineering Library"

  depends_on :java => "1.8+"

  resource "bcel" do
    url "https://search.maven.org/remotecontent?filepath=org/apache/bcel/bcel/6.0/bcel-6.0.jar"
    sha256 "7eb80fdb30034dda26ba109a1b76af8dae0782c8cd27db32f1775086482d5bd0"
  end

  def install
    rm Dir["bin/*.{bat,cmd,dll,exe}"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
    rm bin/"ant"
    (bin/"ant").write <<~EOS
      #!/bin/sh
      #{libexec}/bin/ant -lib #{HOMEBREW_PREFIX}/share/ant "$@"
    EOS
    if build.with? "bcel"
      resource("bcel").stage do
        (libexec/"lib").install Dir["bcel-*.jar"]
      end
    end
  end

  def caveats; <<~EOS
    option "--with-ivy" was removed. Please use Formula "ivy" to install ivy if you need.
    EOS
  end

  test do
    (testpath/"build.xml").write <<~EOS
      <project name="HomebrewTest" basedir=".">
        <property name="src" location="src"/>
        <property name="build" location="build"/>
        <target name="init">
          <mkdir dir="${build}"/>
        </target>
        <target name="compile" depends="init">
          <javac srcdir="${src}" destdir="${build}"/>
        </target>
      </project>
    EOS
    (testpath/"src/main/java/org/homebrew/AntTest.java").write <<~EOS
      package org.homebrew;
      public class AntTest {
        public static void main(String[] args) {
          System.out.println("Testing Ant with Homebrew!");
        }
      }
    EOS
    system "#{bin}/ant", "compile"
  end
end
