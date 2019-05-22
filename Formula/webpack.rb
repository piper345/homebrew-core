require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.32.1.tgz"
  sha256 "bce94158db75997ea7d56bb7f4d8f4ee8e98072dc9c0d8c588ea4f762054cc93"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "dc70c9b47c6d3191d9688510133c2cb1d47f0d827faad886877f8365161b5b76" => :mojave
    sha256 "9b134761ac9558b1641f65c2a7c79b22bef878d844b7f575bea9f0ec33dd2b94" => :high_sierra
    sha256 "c63ae5a87121144b31f962b6f1e55a5d27b156ce77d179d4382b4beb6d87f6f6" => :sierra
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.3.2.tgz"
    sha256 "dcb31e31e1ffe79e97d51782a38459785f2ded99bc15467ffe35f9ac33146df4"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundledDependencies"] = ["webpack"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"
  end

  test do
    (testpath/"index.js").write <<~EOS
      function component () {
        var element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "index.js", "--output=bundle.js"
    assert_predicate testpath/"bundle.js", :exist?, "bundle.js was not generated"
  end
end
