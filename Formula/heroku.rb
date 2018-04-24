require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku/-/heroku-7.0.12.tgz"
  sha256 "894cc48db3128b2cc899f808d7098f5d0937936aef64105034c3b69576b449a7"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "47e8b57aa17f0abb3371181205c9a9db3a3d08e3223de394afdc1fec52e32f18" => :high_sierra
    sha256 "a9df852e3633aaf2edcb193656cd7eea3e42673a8e724583a02d2863ab723425" => :sierra
    sha256 "cee4a014f503bae259f0274800d644bcd8ddf0c3b8ba4f843e7ef34c5cb6611c" => :el_capitan
  end

  depends_on "node"

  def install
    inreplace "bin/run", "#!/usr/bin/env node",
                         "#!#{Formula["node"].opt_bin}/node"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"heroku", "version"
  end
end
