class Infer < Formula
  desc "Static analyzer for Java, C, C++, and Objective-C"
  homepage "https://fbinfer.com/"
  # pull from git tag to get submodules
  url "https://github.com/facebook/infer.git",
      :tag => "v0.15.0",
      :revision => "8bda23fadcc51c6ed38a4c3a75be25a266e8f7b4"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e2078ff9abde6c7add2f9c1ae5e4f53d8a05e257ae09bd5076f54d48fb76e350" => :high_sierra
    sha256 "ea7875d9593b2fec217ec6652f1549ebb09d547e39d292f77dc6335219aab306" => :sierra
    sha256 "82944baee3bdcd35f637c6068a904fd20dd17ba6902bf2b93288936e22f9173f" => :el_capitan
  end

  option "without-clang", "Build without the C/C++/Objective-C analyzers"
  option "without-java", "Build without the Java analyzers"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on :java => ["1.7+", :build]
  depends_on "libtool" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pkg-config" => :build

  def install
    if build.without?("clang") && build.without?("java")
      odie "infer: --without-clang and --without-java are mutually exclusive"
    end

    if build.with?("clang")
      # needed to build clang
      ENV.permit_arch_flags
      # Apple's libstdc++ is too old to build LLVM
      ENV.libcxx if ENV.compiler == :clang
    end

    opamroot = buildpath/"opamroot"
    opamroot.mkpath
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    # do not attempt to use the clang in facebook-clang-plugins/ as it hasn't been built yet
    ENV["INFER_CONFIGURE_OPTS"] = "--prefix=#{prefix} --without-fcp-clang"

    target_platform = if build.without?("clang")
      "java"
    elsif build.without?("java")
      "clang"
    else
      "all"
    end

    llvm_args = %w[
      -DLLVM_INCLUDE_DOCS=OFF
      -DLLVM_INSTALL_UTILS=OFF
      -DLLVM_TARGETS_TO_BUILD=all
      -DLIBOMP_ARCH=x86_64
      -DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON
      -DLLVM_BUILD_LLVM_DYLIB=ON
    ]

    system "opam", "init", "--no-setup"
    ocaml_version = File.read("build-infer.sh").match(/OCAML_VERSION_DEFAULT=\"([^\"]+)\"/)[1]
    ocaml_version_number = ocaml_version.split("+", 2)[0]
    inreplace "#{opamroot}/compilers/#{ocaml_version_number}/#{ocaml_version}/#{ocaml_version}.comp",
      '["./configure"', '["./configure" "-no-graph"'
    # so that `infer --version` reports a release version number
    inreplace "infer/src/base/Version.ml.in", "let is_release = is_yes \"@IS_RELEASE_TREE@\"", "let is_release = true"
    inreplace "facebook-clang-plugins/clang/setup.sh", "CMAKE_ARGS=(", "CMAKE_ARGS=(\n  " + llvm_args.join("\n  ")
    system "./build-infer.sh", target_platform, "--yes"
    system "opam", "config", "exec", "--switch=infer-#{ocaml_version}", "--", "make", "install"
  end

  test do
    (testpath/"FailingTest.c").write <<~EOS
      #include <stdio.h>

      int main() {
        int *s = NULL;
        *s = 42;

        return 0;
      }
    EOS

    (testpath/"PassingTest.c").write <<~EOS
      #include <stdio.h>

      int main() {
        int *s = NULL;
        if (s != NULL) {
          *s = 42;
        }

        return 0;
      }
    EOS

    shell_output("#{bin}/infer --fail-on-issue -- clang -c FailingTest.c", 2)
    shell_output("#{bin}/infer --fail-on-issue -- clang -c PassingTest.c")

    (testpath/"FailingTest.java").write <<~EOS
      class FailingTest {

        String mayReturnNull(int i) {
          if (i > 0) {
            return "Hello, Infer!";
          }
          return null;
        }

        int mayCauseNPE() {
          String s = mayReturnNull(0);
          return s.length();
        }
      }
    EOS

    (testpath/"PassingTest.java").write <<~EOS
      class PassingTest {

        String mayReturnNull(int i) {
          if (i > 0) {
            return "Hello, Infer!";
          }
          return null;
        }

        int mayCauseNPE() {
          String s = mayReturnNull(0);
          return s == null ? 0 : s.length();
        }
      }
    EOS

    shell_output("#{bin}/infer --fail-on-issue -- javac FailingTest.java", 2)
    shell_output("#{bin}/infer --fail-on-issue -- javac PassingTest.java")
  end
end
