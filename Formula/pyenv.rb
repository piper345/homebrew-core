class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.14.tar.gz"
  sha256 "3062c104b200d8c572d185b54e73a94bf66d5d46cc789717c372d2941c314a93"
  head "https://github.com/pyenv/pyenv.git"

  bottle do
    cellar :any
    sha256 "01fdb41c98605423a79ef671b1a40b8cd37e94250333aec8b72eb8189c24c76d" => :catalina
    sha256 "02ca7b702210e4ff420e6bab6248487537a09c843e495042e569d784607056e6" => :mojave
    sha256 "fc4e014627b4a42b647c61219a7cf7882bca797104a2cc15d6243529593ee2eb" => :high_sierra
    sha256 "c863f6b200535131653787ee07647f9a042b44bfd54d3d065366542dd9b0be3a" => :sierra
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "readline"

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end

    # Do not manually install shell completions. See:
    #   - https://github.com/pyenv/pyenv/issues/1056#issuecomment-356818337
    #   - https://github.com/Homebrew/homebrew-core/pull/22727
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
