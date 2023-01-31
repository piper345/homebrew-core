require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.56.tgz"
  sha256 "ea19a29a80c6ecb1aaef30bef62238d0328317c1e50d35cb8cd72aa33c206f09"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b3bf6adb052c30dbff73220cac4bcf500c1d45edfa88aef2cc66ce78d71bc4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b3bf6adb052c30dbff73220cac4bcf500c1d45edfa88aef2cc66ce78d71bc4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b3bf6adb052c30dbff73220cac4bcf500c1d45edfa88aef2cc66ce78d71bc4e"
    sha256 cellar: :any_skip_relocation, ventura:        "569e0189907b8d503b16eb80c38328c1c3238e992700d4328a412851e5f9441a"
    sha256 cellar: :any_skip_relocation, monterey:       "569e0189907b8d503b16eb80c38328c1c3238e992700d4328a412851e5f9441a"
    sha256 cellar: :any_skip_relocation, big_sur:        "569e0189907b8d503b16eb80c38328c1c3238e992700d4328a412851e5f9441a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b3bf6adb052c30dbff73220cac4bcf500c1d45edfa88aef2cc66ce78d71bc4e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
