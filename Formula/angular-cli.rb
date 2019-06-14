require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.0.3.tgz"
  sha256 "5e4b52bf5280598393697e050386612f541de9a5faf695628f1d4456539ca943"

  bottle do
    cellar :any_skip_relocation
    sha256 "71dad866c281669e21ccb8e051708217b3879586a494fcd6346db122c745578f" => :mojave
    sha256 "f6743cd774146b1712a2c6abffeb673add8f32217b8582937083f13103eeba56" => :high_sierra
    sha256 "a8aa3f333def1675e757e17dff29f55228871f9930383a2711e946bd7f1ede03" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
