class Historian < Formula
  desc "Command-line utility for managing shell history in a SQLite database."
  homepage "https://github.com/jcsalterego/historian"
  url "https://github.com/jcsalterego/historian/archive/0.0.2.tar.gz"
  sha256 "691b131290ddf06142a747755412115fec996cb9cc2ad8e8f728118788b3fe05"

  def install
    bin.install "hist"
  end

  test do
    ENV["HISTORIAN_SRC"] = "test_history"
    File.write("test_history", "brew update")
    system bin/"hist", "import"
  end
end
