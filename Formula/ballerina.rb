class Ballerina < Formula
  desc "Programming Language for Network Distributed Applications"
  homepage "https://ballerina.io"
  url "https://dist.ballerina.io/downloads/2201.3.2/ballerina-2201.3.2-swan-lake.zip"
  sha256 "44fdf1059ee6d54f50ff0d6c61462cc60dee3e4f6a1ed66907c1ce06f10d5af1"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/ballerina-platform/ballerina-lang.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "73155be523be3130a75ba65bd76de702789e23d5d97a0390418536c484ce55d8"
  end

  depends_on "openjdk@11"

  def install
    # Remove Windows files
    rm Dir["bin/*.bat"]

    chmod 0755, "bin/bal"

    bin.install "bin/bal"
    libexec.install Dir["*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("11"))
  end

  test do
    (testpath/"helloWorld.bal").write <<~EOS
      import ballerina/io;
      public function main() {
        io:println("Hello, World!");
      }
    EOS
    output = shell_output("#{bin}/bal run helloWorld.bal")
    assert_equal "Hello, World!", output.chomp
  end
end
