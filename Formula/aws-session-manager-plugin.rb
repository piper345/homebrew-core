class AwsSessionManagerPlugin < Formula
  desc "Official Amazon AWS session manager plugin"
  homepage "https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html"
  url "https://s3.amazonaws.com/session-manager-downloads/plugin/1.1.35.0/mac/sessionmanager-bundle.zip"
  version "1.1.35.0"
  sha256 "9aa7c6372a39285ece98ad0bc18b23cc0924c6f1d9fb67e1ef360eb65e0653a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "687e6fcd95376974e7306f42d98122234d571bfee09822a620325d1c7f141637" => :catalina
    sha256 "687e6fcd95376974e7306f42d98122234d571bfee09822a620325d1c7f141637" => :mojave
    sha256 "687e6fcd95376974e7306f42d98122234d571bfee09822a620325d1c7f141637" => :high_sierra
  end

  depends_on "awscli"

  def install
    bin.install "bin/session-manager-plugin"
    prefix.install %w[LICENSE VERSION]
  end

  test do
    system bin/"session-manager-plugin"
  end
end
