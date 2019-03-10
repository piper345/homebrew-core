class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v1.24.0.tar.gz"
  version "1.24.0"
  sha256 "6ba812be47976ca49bc2f5ab888c44ef41b824dd20fa9be5687f4ff6d185c2b1"

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    dir = buildpath/"src/github.com/zricethezav/gitleaks"
    dir.install buildpath.children
    cd dir do
      system "dep", "ensure"
      system "go", "install"
    end
  end

  test do
    system "#{bin}/gitleaks", "-v"
  end
end
