class LibreadlineJava < Formula
  desc "Port of GNU readline for Java"
  homepage "https://java-readline.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/java-readline/java-readline/0.8.0/libreadline-java-0.8.0-src.tar.gz"
  sha256 "cdcfd9910bfe2dca4cd08b2462ec05efee7395e9b9c3efcb51e85fa70548c890"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "fec2136489ef325c60a6d3fd1eaaa5cba11799d8b58c6e6123e63028f4565671" => :high_sierra
    sha256 "143f234bbcca12371b77e2a41e7b135a18b771fbd9ae06abef0fb288f9404f72" => :sierra
    sha256 "03e3f8108389622d95c0ef67aa3700298d4376dc2c647aea8d35a727c297a788" => :el_capitan
  end

  depends_on "readline"
  depends_on :java => "1.8"

  # Fix "non-void function should return a value"-Error
  # https://sourceforge.net/p/java-readline/patches/2/
  patch :DATA

  def install
    java_home = ENV["JAVA_HOME"]

    # Reported 4th May 2016: https://sourceforge.net/p/java-readline/bugs/12/
    # JDK 8 doclint for Javadoc complains about minor HTML conformance issues
    if `javadoc -X`.include? "doclint"
      inreplace "Makefile",
        "-version -author org.gnu.readline test",
        "-version -author org.gnu.readline -Xdoclint:none test"
    end

    # Current Oracle JDKs put the jni.h and jni_md.h in a different place than the
    # original Apple/Sun JDK used to.
    if File.exist? "#{java_home}/include/jni.h"
      ENV["JAVAINCLUDE"] = "#{java_home}/include"
      ENV["JAVANATINC"]  = "#{java_home}/include/darwin"
    elsif File.exist? "/System/Library/Frameworks/JavaVM.framework/Versions/Current/Headers/jni.h"
      ENV["JAVAINCLUDE"] = "/System/Library/Frameworks/JavaVM.framework/Versions/Current/Headers/"
      ENV["JAVANATINC"]  = "/System/Library/Frameworks/JavaVM.framework/Versions/Current/Headers/"
    end

    # Take care of some hard-coded paths,
    # adjust postfix of jni libraries,
    # adjust gnu install parameters to bsd install
    inreplace "Makefile" do |s|
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "JAVALIBDIR", "$(PREFIX)/share/libreadline-java"
      s.change_make_var! "JAVAINCLUDE", ENV["JAVAINCLUDE"]
      s.change_make_var! "JAVANATINC", ENV["JAVANATINC"]
      s.gsub! "*.so", "*.jnilib"
      s.gsub! "install -D", "install -c"
    end

    # Take care of some hard-coded paths,
    # adjust CC variable,
    # adjust postfix of jni libraries
    inreplace "src/native/Makefile" do |s|
      readline = Formula["readline"]
      s.change_make_var! "INCLUDES", "-I $(JAVAINCLUDE) -I $(JAVANATINC) -I #{readline.opt_include}"
      s.change_make_var! "LIBPATH", "-L#{readline.opt_lib}"
      s.change_make_var! "CC", "cc"
      s.gsub! "LIB_EXT := so", "LIB_EXT := jnilib"
      s.gsub! "$(CC) -shared $(OBJECTS) $(LIBPATH) $($(TG)_LIBS) -o $@",
        "$(CC) -install_name #{HOMEBREW_PREFIX}/lib/$(LIB_PRE)$(TG).$(LIB_EXT) -dynamiclib $(OBJECTS) $(LIBPATH) $($(TG)_LIBS) -o $@"
    end

    pkgshare.mkpath

    system "make", "jar"
    system "make", "build-native"
    system "make", "install"

    doc.install "api"
  end

  def caveats; <<~EOS
    You may need to set JAVA_HOME:
      export JAVA_HOME="$(/usr/libexec/java_home)"
    EOS
  end

  # Testing libreadline-java (can we execute and exit libreadline without exceptions?)
  test do
    assert /Exception/ !~ pipe_output("java -Djava.library.path=#{lib} -cp #{pkgshare}/libreadline-java.jar test.ReadlineTest", "exit")
  end
end

__END__
diff --git a/src/native/org_gnu_readline_Readline.c b/src/native/org_gnu_readline_Readline.c
index f601c73..b26cafc 100644
--- a/src/native/org_gnu_readline_Readline.c
+++ b/src/native/org_gnu_readline_Readline.c
@@ -430,7 +430,7 @@ const char *java_completer(char *text, int state) {
   jtext = (*jniEnv)->NewStringUTF(jniEnv,text);

   if (jniMethodId == 0) {
-    return;
+    return ((const char *)NULL);
   }

   completion = (*jniEnv)->CallObjectMethod(jniEnv, jniObject,
