class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.4.tar.gz"
  sha256 "907f9d9fba37ab5e13b38d42ba324c66e1d8db8fe138b9164a0c3d26e034225b"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b257bd6b073b460d73f1f84518b854438bebfb9da94b685bf4b08495c0b13374" => :sierra
    sha256 "c29efbba200ab8c7fcbe61f4118c74b68cbd7ee100b5d883cc5f077756e41727" => :el_capitan
    sha256 "64309c3b93372b8f63956c5f678c725d3949bd73c9430460388de257bb16fb06" => :yosemite
  end

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    mkdir_p buildpath/"src/github.com/gruntwork-io/"
    ln_s buildpath, buildpath/"src/github.com/gruntwork-io/terragrunt"
    system "glide", "install"
    system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=v#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
