require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-1.16.4.tgz"
  sha256 "04fb74726f2a78b07072d45b9612d8f3f315fa206bd1494c5088c6ef24f7c18f"

  bottle do
    cellar :any_skip_relocation
    sha256 "f37b360631ee0de4d9f46476fafc3c553bfa0f03676155f4b4a16aaf1eb0f5b7" => :mojave
    sha256 "70cecb21e823d0b7ab5cf855c356328ddbf10794b61cec992fc397d48e55272c" => :high_sierra
    sha256 "ce1d7aea52d91ac150b7a83d537110abf83b59de8121c2808a83f69175f014b2" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    output = shell_output("#{bin}/prettier test.js")
    assert_equal "const arr = [1, 2];", output.chomp
  end
end
