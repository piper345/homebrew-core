class Node < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v10.4.0/node-v10.4.0.tar.xz"
  sha256 "b58f5a39253921c668eb7678679df36f9fb5e46c885242d20f13168973603762"
  head "https://github.com/nodejs/node.git"

  bottle do
    rebuild 1
    sha256 "e4c55b236692737f91adeba8bd3c9e63ba4e302bfdc08df75c3d2c875ea1fedf" => :high_sierra
    sha256 "bfb01c304ab31351d4e4fbfe2017ecc87f8c9e9fd12dc1179f3d779bbe5d8284" => :sierra
    sha256 "4f10dbb44206c8adc57574cab0c2669f52ad23fd89754a4935ad3adedcd1cfa4" => :el_capitan
  end

  option "with-debug", "Build with debugger hooks"
  option "with-openssl@1.1", "Build against Homebrew's OpenSSL instead of the bundled OpenSSL"
  option "without-npm", "npm will not be installed"
  option "without-completion", "npm bash completion will not be installed"
  option "without-icu4c", "Build with small-icu (English only) instead of system-icu (all locales)"

  deprecated_option "enable-debug" => "with-debug"
  deprecated_option "with-openssl" => "with-openssl@1.1"

  depends_on "python@2" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended
  depends_on "openssl@1.1" => :optional

  # Per upstream - "Need g++ 4.8 or clang++ 3.4".
  fails_with :clang if MacOS.version <= :snow_leopard
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.7").each do |n|
    fails_with :gcc => n
  end

  # We track major/minor from upstream Node releases.
  # We will accept *important* npm patch releases when necessary.
  resource "npm" do
    url "https://registry.npmjs.org/npm/-/npm-6.1.0.tgz"
    sha256 "be8bb5fdb52e5af8a62988ad32f51c688d1327f62412c4410b30c29c8d66a85f"
  end

  # Patch node-gyp to support detecting double-digit Xcode versions
  patch do
    url "https://github.com/nodejs/node/commit/a9e70d7d0b50ed615428e8344d510effb6713f02.patch?full_index=1"
    sha256 "e6c2a617f7550c1c6b36809ddea4a40a9f4ec612fe853c460b98368f72c646b2"
  end

  # Patch configure to support detecting double-digit Xcode versions
  patch do
    url "https://github.com/nodejs/node/commit/400df22c6bfefc3c3f54ebd7c5fd0d38f5137841.patch?full_index=1"
    sha256 "a1ac0e2589c8b9e98bf4712723a6ef28bc23dcd1aa1891d045b5a5e3a329cb36"
  end

  # Patch configure to fix a buggy compiler version comparison
  patch do
    url "https://github.com/nodejs/node/commit/641d4a4159aaa96eece8356e03ec6c7248ae3e73.patch?full_index=1"
    sha256 "c193ab8edf2084a94265762d9ace419c0680eda87986e30dc7325df55044cb1b"
  end

  def install
    # Never install the bundled "npm", always prefer our
    # installation from tarball for better packaging control.
    args = %W[--prefix=#{prefix} --without-npm]
    args << "--debug" if build.with? "debug"
    args << "--with-intl=system-icu" if build.with? "icu4c"
    args << "--shared-openssl" if build.with? "openssl@1.1"
    args << "--tag=head" if build.head?

    system "./configure", *args
    system "make", "install"

    if build.with? "npm"
      # Allow npm to find Node before installation has completed.
      ENV.prepend_path "PATH", bin

      bootstrap = buildpath/"npm_bootstrap"
      bootstrap.install resource("npm")
      system "node", bootstrap/"bin/npm-cli.js", "install", "-ddd", "--global",
             "--prefix=#{libexec}", resource("npm").cached_download

      # The `package.json` stores integrity information about the above passed
      # in `cached_download` npm resource, which breaks `npm -g outdated npm`.
      # This copies back over the vanilla `package.json` to fix this issue.
      cp bootstrap/"package.json", libexec/"lib/node_modules/npm"
      # These symlinks are never used & they've caused issues in the past.
      rm_rf libexec/"share"

      # suppress incorrect node 10 incompatibility warning from npm
      # remove during next npm upgrade (to npm 5.9+ or npm 6.0+)
      inreplace libexec/"lib/node_modules/npm/lib/utils/unsupported.js",
        "{ver: '9', min: '9.0.0'}",
        "{ver: '9', min: '9.0.0'}, {ver: '10', min: '10.0.0'}"

      if build.with? "completion"
        bash_completion.install \
          bootstrap/"lib/utils/completion.sh" => "npm"
      end
    end
  end

  def post_install
    return if build.without? "npm"

    node_modules = HOMEBREW_PREFIX/"lib/node_modules"
    node_modules.mkpath
    # Kill npm but preserve all other modules across node updates/upgrades.
    rm_rf node_modules/"npm"

    cp_r libexec/"lib/node_modules/npm", node_modules
    # This symlink doesn't hop into homebrew_prefix/bin automatically so
    # we make our own. This is a small consequence of our
    # bottle-npm-and-retain-a-private-copy-in-libexec setup
    # All other installs **do** symlink to homebrew_prefix/bin correctly.
    # We ln rather than cp this because doing so mimics npm's normal install.
    ln_sf node_modules/"npm/bin/npm-cli.js", HOMEBREW_PREFIX/"bin/npm"
    ln_sf node_modules/"npm/bin/npx-cli.js", HOMEBREW_PREFIX/"bin/npx"

    # Let's do the manpage dance. It's just a jump to the left.
    # And then a step to the right, with your hand on rm_f.
    %w[man1 man5 man7].each do |man|
      # Dirs must exist first: https://github.com/Homebrew/legacy-homebrew/issues/35969
      mkdir_p HOMEBREW_PREFIX/"share/man/#{man}"
      rm_f Dir[HOMEBREW_PREFIX/"share/man/#{man}/{npm.,npm-,npmrc.,package.json.,npx.}*"]
      cp Dir[libexec/"lib/node_modules/npm/man/#{man}/{npm,package.json,npx}*"], HOMEBREW_PREFIX/"share/man/#{man}"
    end

    (node_modules/"npm/npmrc").atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  def caveats
    if build.without? "npm"
      <<~EOS
        Homebrew has NOT installed npm. If you later install it, you should supplement
        your NODE_PATH with the npm module folder:
          #{HOMEBREW_PREFIX}/lib/node_modules
      EOS
    end
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output
    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"en-EN\").format(1234.56))'").strip
    assert_equal "1,234.56", output
    if build.with? "icu4c"
      output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"de-DE\").format(1234.56))'").strip
      assert_equal "1.234,56", output
    end

    if build.with? "npm"
      # make sure npm can find node
      ENV.prepend_path "PATH", opt_bin
      ENV.delete "NVM_NODEJS_ORG_MIRROR"
      assert_equal which("node"), opt_bin/"node"
      assert_predicate HOMEBREW_PREFIX/"bin/npm", :exist?, "npm must exist"
      assert_predicate HOMEBREW_PREFIX/"bin/npm", :executable?, "npm must be executable"
      npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
      system "#{HOMEBREW_PREFIX}/bin/npm", *npm_args, "install", "npm@latest"
      system "#{HOMEBREW_PREFIX}/bin/npm", *npm_args, "install", "bufferutil" unless head?
      assert_predicate HOMEBREW_PREFIX/"bin/npx", :exist?, "npx must exist"
      assert_predicate HOMEBREW_PREFIX/"bin/npx", :executable?, "npx must be executable"
      assert_match "< hello >", shell_output("#{HOMEBREW_PREFIX}/bin/npx cowsay hello")
    end
  end
end
