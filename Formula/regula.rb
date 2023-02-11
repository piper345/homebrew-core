class Regula < Formula
  desc "Checks infrastructure as code templates using Open Policy Agent/Rego"
  homepage "https://regula.dev/"
  url "https://github.com/fugue/regula.git",
      tag:      "v3.1.0",
      revision: "0f4961dfb17ae33f5a4f22885dc9c3c3c651b551"
  license "Apache-2.0"
  head "https://github.com/fugue/regula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "debf42eae0e68f52bd45b73c4eda056f66e202af5b141671c2d304f21c28dd01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8068da4f0e4cad6912a9e18b00770b951012ed7c00beea5db3733410ea8f93cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5cbbf6fc86cc66d28da52af69fd299f124648cfb6e63d3036d39c5653e44b74"
    sha256 cellar: :any_skip_relocation, ventura:        "86d0415a33cfa6288f79e9b7e6b8df2b4b8e945bd599e5ca197ab03e749a1ec6"
    sha256 cellar: :any_skip_relocation, monterey:       "670bed6d1fcef896930fbcc5e216ace5953c6acd0205d8add45afebf794c8310"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd64202f54b3b1fa797aed93061b1247f97c1ee55e52f8f2dac165a84cb7b2b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "332300a56cdc24da379dee3a56d7bbcf4c692587cd9d3f75de04910df63832d6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/fugue/regula/v3/pkg/version.Version=#{version}
      -X github.com/fugue/regula/v3/pkg/version.GitCommit=#{Utils.git_short_head}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"regula", "completion")
  end

  test do
    (testpath/"infra/test.tf").write <<~EOS
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        versioning {
          enabled = true
        }
      }
    EOS

    assert_match "Found 10 problems", shell_output(bin/"regula run infra", 1)

    assert_match version.to_s, shell_output(bin/"regula version")
  end
end
