require "language/node"
require "json"

class EtcherCli < Formula
  desc "Flash OS images to SD cards & USB drives, safely and easily"
  homepage "https://etcher.io/"
  url "https://github.com/resin-io/etcher/archive/v1.4.4.tar.gz"
  sha256 "02082bc1caac746e1cdcd95c2892c9b41ff8d45a672b52f8467548cad4850f5d"

  depends_on "python" => :build
  depends_on "node@8"

  def install
    # use npm from node@8 here, because we don't depend on node (can't use language/node)
    ENV.prepend_path "PATH", Formula["node@8"].bin
    system "npm", "install", "--production", "-ddd", "--build-from-source",
           "--#{Language::Node.npm_cache_config}"
    system "npm", "install", "pkg@4.3.0", "-ddd", "--build-from-source",
           "--#{Language::Node.npm_cache_config}", "--prefix=#{buildpath}/pkg"

    cd "pkg" do
      # get list of for the CLI required dependencies using pkg's AST tree walker
      (buildpath/"pkg/get-cli-deps.js").write <<~EOS
        const walker = require("pkg/lib-es5/walker.js").default;
        const cli_entrypoint = "../lib/cli/etcher.js";
        // get the list of file paths required by the cli entrypoint by running the ast walker on it
        var walk_ast = walker({config: {}, base: "../lib/cli", configPath: cli_entrypoint}, cli_entrypoint);
        walk_ast.then(ast_walker_results => {
          let required_paths = Object.keys(ast_walker_results.records);
          // run regex on the required paths to find out the top level dependencies they belong to
          let required_deps = required_paths.map(path => /\\/node_modules\\/([^\\/]*)\\//.exec(path));
          // filter out non matches (direct source files) and only use the actual parenthesized match
          required_deps = required_deps.filter(r => r !== null).map(r => r[1]);
          // dedupte results using a Set (we currently have one match for every source file)
          let unique_deps = new Set(required_deps);
          // log unique deps to console seperatey by a new line
          console.log(Array.from(unique_deps).join("\\n"));
        });
      EOS
      cli_deps = Utils.popen_read("node get-cli-deps.js").chomp.split("\n")

      # Patch package.json the generate cli build instead of electron build
      pkg_json = JSON.parse(IO.read("../package.json"))
      pkg_json["bin"] = { :etcher => "./bin/etcher" } # set bin entry point
      pkg_json["dependencies"].each do |dep, _| # ignore some electron releated dependencies
        pkg_json["dependencies"].delete(dep) unless cli_deps.include? dep
      end
      # bundle the already installed depedencies and ignore electron related source files
      pkg_json["bundledDependencies"] = pkg_json["dependencies"].keys
      pkg_json["files"] = %w[bin build lib/cli lib/sdk lib/shared binding.gyp]
      IO.write("../package.json", JSON.pretty_generate(pkg_json))
    end

    # remove shrinkwrap because it would override our patched package.json
    rm "npm-shrinkwrap.json"
    # patch shebang to always run againts our node@8
    inreplace "bin/etcher", "#!/usr/bin/env node", "#!#{Formula["node@8"].opt_bin}/node"

    # can't use language/node here, because we have to run with our node@8 here
    pack = Utils.popen_read("npm pack --ignore-scripts").lines.last.chomp
    system "npm", "install", "-ddd", "--global", "--production", "--build-from-source",
           "--#{Language::Node.npm_cache_config}", "--prefix=#{libexec}", buildpath/pack

    bin.install_symlink libexec/"bin/etcher"
  end

  test do
    # Writing a functionality test would require sudo and access to hdiutil,
    # which is both not possible inside brews sandbox. Manual test with:
    # $ curl -o /tmp/mini.iso http://archive.ubuntu.com/ubuntu/dists/xenial/main/installer-i386/current/images/netboot/mini.iso
    # $ hdiutil create -size 100m -fs HFS+ -volname Test /tmp/test.dmg
    # $ hdiutil attach -imagekey diskimage-class=CRawDiskImage -nomount /tmp/test.dmg
    # $ sudo etcher -d <devname> -cu /tmp/mini.iso
    # $ hdiutil detach <devname> && rm /tmp/{mini.iso,test.dmg}
    # (replace <devname> with first path printed by hdiutil attach)
    assert_equal pipe_output("#{bin}/etcher --version").chomp, version
  end
end
