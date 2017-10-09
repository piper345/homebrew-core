class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.43.0/meson-0.43.0.tar.gz"
  sha256 "c513eca90e0d70bf14cd1eaafea2fa91cf40a73326a7ff61f08a005048057340"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b29b8e4a61308d73c4744200a7aee75f0c3389d2359b29993a7c8cb6e4a680e2" => :high_sierra
    sha256 "b29b8e4a61308d73c4744200a7aee75f0c3389d2359b29993a7c8cb6e4a680e2" => :sierra
    sha256 "b29b8e4a61308d73c4744200a7aee75f0c3389d2359b29993a7c8cb6e4a680e2" => :el_capitan
  end

  depends_on :python3
  depends_on "ninja"

  def install
    version = Language::Python.major_minor_version("python3")
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"helloworld.c").write <<-EOS.undent
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<-EOS.undent
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system "#{bin}/meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end
