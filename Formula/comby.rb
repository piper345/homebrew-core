class Comby < Formula
  desc "Tool for changing code across many languages"
  homepage "https://comby.dev"
  url "https://github.com/comby-tools/comby/archive/0.13.1.tar.gz"
  sha256 "b9d8592070ba9912c82ce9eaf620b78dd92717f422cd94df5d04c9fb443196bd"

  bottle do
    cellar :any
    sha256 "9af7377e3a37fbbc19896b40a61dc5718396a080d752c3a9557b0b3e3faf96d7" => :catalina
    sha256 "d1d4351daf973c806da71fa970986837a6bf2ed0897f6178ad6909a2bc089f78" => :mojave
    sha256 "2741164707a47a18d9a750420d306730825332098be73f7eb02f29530f8b74aa" => :high_sierra
  end

  depends_on "gmp" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pcre"
  depends_on "pkg-config"

  uses_from_macos "m4"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  def install
    ENV.deparallelize
    opamroot = buildpath/".opam"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    system "opam", "init", "--no-setup", "--disable-sandboxing"
    system "opam", "config", "exec", "--", "opam", "install", ".", "--deps-only", "-y"

    ENV.prepend_path "LIBRARY_PATH", opamroot/"default/lib/hack_parallel" # for -lhp
    system "opam", "config", "exec", "--", "make", "release"

    bin.install "_build/default/src/main.exe" => "comby"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/comby -version").strip

    expect = <<~EXPECT
      --- /dev/null
      +++ /dev/null
      @@ -1,3 +1,3 @@
       int main(void) {
      -  printf("hello world!");
      +  printf("comby, hello!");
       }
    EXPECT

    input = <<~INPUT
      EOF
      int main(void) {
        printf("hello world!");
      }
      EOF
    INPUT

    match = 'printf(":[1] :[2]!")'
    rewrite = 'printf("comby, :[1]!")'

    assert_equal expect, shell_output("#{bin}/comby '#{match}' '#{rewrite}' .c -stdin -diff << #{input}")
  end
end
