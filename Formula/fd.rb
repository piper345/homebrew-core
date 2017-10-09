class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find."
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v5.0.0.tar.gz"
  sha256 "9788597334912d65e32c7d57ef7a0294cb8976dc52538c9048a77fbb8d12f755"
  head "https://github.com/sharkdp/fd.git"

  bottle do
    sha256 "1a819bd842d2e715b6d0b1c3ae44c92fe13ba7c5cc38508373df9d620e72d4b3" => :high_sierra
    sha256 "b2f01250d8ef38bfe25b860ab0a8a9638fc7975ceb2dd6b054f0f3eba095afa2" => :sierra
    sha256 "0e3b69a28956e9cf91b043c6e1a66d74e14e41e70b2c02fc4836f77f722cf677" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--root", prefix

    man1.install "doc/fd.1"
    bash_completion.install "fd.bash-completion"
    fish_completion.install "fd.fish"
    zsh_completion.install "_fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
