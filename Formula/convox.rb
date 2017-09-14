class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170913220722.tar.gz"
  sha256 "982a6a863c1bf4db9e3d96d5cab0347512583947cdbdee04c5a6c7dbab67fcea"

  bottle do
    cellar :any_skip_relocation
    sha256 "cce89ad8b4ee3f0811bf25174398d26ef6558aa5d879b24facf33f5f2a35a089" => :sierra
    sha256 "d6dde46e25045c48592871bb505181221aea67758dd861f3f133a55b6ce2db79" => :el_capitan
    sha256 "802c252e1f4c41a2a513118385875e6f292028e5d8b47e663852a547f20b3e4c" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.Version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
  end

  test do
    system bin/"convox"
  end
end
