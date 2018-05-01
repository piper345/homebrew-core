class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.0.0.tar.gz"
  sha256 "3c7281efb5dced04588dea2b943ebbe0cb5b1621eeea97f6c477713d79c7c1bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "97b5acb02255e465ff5a766176a90367b3f61056bca1ba4b8df09e48161b96aa" => :high_sierra
    sha256 "bc191f6c936af475f3117b066805d1d64de9619edb1209173ba27e92e59f8276" => :sierra
    sha256 "eb09248f87963fc8c88953f4a9c857b6e5bb9380f139a560dd2e95830ffbd88f" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rancher/cli/").install Dir["*"]
    system "go", "build", "-ldflags",
           "-w -X github.com/rancher/cli/version.VERSION=#{version}",
           "-o", "#{bin}/rancher",
           "-v", "github.com/rancher/cli/"
  end

  test do
    system bin/"rancher", "help"
  end
end
