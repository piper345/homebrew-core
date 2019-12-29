class NodeAT10 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v10.18.0/node-v10.18.0.tar.gz"
  sha256 "f9c8785c5d5ba0e5412dada04a89ab3fe32531423c47232217aad79757a769e7"
  revision 1

  bottle do
    cellar :any
    sha256 "640394781eeabb4889c0d395324ee1b5bff45d69360de0f2811fb2c7326a66b1" => :catalina
    sha256 "2eb3d5cb338228e9e6cddaaaf33a0df63023902932739da86d4bb06692d979da" => :mojave
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  uses_from_macos "python@2" => :build

  # Fixes detecting Apple clang 11.
  patch do
    url "https://github.com/nodejs/node/commit/1f143b8625c2985b4317a40f279232f562417077.patch?full_index=1"
    sha256 "12d8af6647e9a5d81f68f610ad0ed17075bf14718f4d484788baac37a0d3f842"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-intl=system-icu"
    system "make", "install"
  end

  def post_install
    (lib/"node_modules/npm/npmrc").atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output
    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"en-EN\").format(1234.56))'").strip
    assert_equal "1,234.56", output

    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"de-DE\").format(1234.56))'").strip
    assert_equal "1.234,56", output

    # make sure npm can find node
    ENV.prepend_path "PATH", opt_bin
    ENV.delete "NVM_NODEJS_ORG_MIRROR"
    assert_equal which("node"), opt_bin/"node"
    assert_predicate bin/"npm", :exist?, "npm must exist"
    assert_predicate bin/"npm", :executable?, "npm must be executable"
    npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
    system "#{bin}/npm", *npm_args, "install", "npm@latest"
    system "#{bin}/npm", *npm_args, "install", "bignum"
    assert_predicate bin/"npx", :exist?, "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx cowsay hello")
  end
end
