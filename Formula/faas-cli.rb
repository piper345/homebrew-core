class FaasCli < Formula
  desc "CLI for templating and/or deploying FaaS functions"
  homepage "https://docs.get-faas.com/"
  url "https://github.com/openfaas/faas-cli.git",
      :tag => "0.6.10",
      :revision => "999a6669148c30adeb64400609953cf59db2fb64"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6b6801950ef0b953a20b159bdb425bdd5520c6f345ec35b4e9bdab8876c54b3" => :high_sierra
    sha256 "7157f43dfec44e5150e07c75d32fdae174da426c9af3139f92cd947d70922eaa" => :sierra
    sha256 "ab431d86269870fa330509a4a9735ec5f16c4972b2fdef55a42e256b486c92bf" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/openfaas/faas-cli").install buildpath.children
    cd "src/github.com/openfaas/faas-cli" do
      project = "github.com/openfaas/faas-cli"
      commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
      system "go", "build", "-ldflags",
             "-s -w -X #{project}/version.GitCommit=#{commit} -X #{project}/version.Version=#{version}", "-a",
             "-installsuffix", "cgo", "-o", bin/"faas-cli"
      bin.install_symlink "faas-cli" => "faas"
      pkgshare.install "template"
      prefix.install_metafiles
    end
  end

  test do
    require "socket"

    server = TCPServer.new("localhost", 0)
    port = server.addr[1]
    pid = fork do
      loop do
        socket = server.accept
        response = "OK"
        socket.print "HTTP/1.1 200 OK\r\n" \
                    "Content-Length: #{response.bytesize}\r\n" \
                    "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end

    (testpath/"test.yml").write <<~EOS
      provider:
        name: faas
        gateway: http://localhost:#{port}
        network: "func_functions"

      functions:
        dummy_function:
          lang: python
          handler: ./dummy_function
          image: dummy_image
    EOS

    expected = <<~EOS
      Deploying: dummy_function.
      Function dummy_function already exists, attempting rolling-update.

      Deployed. 200 OK.
      URL: http://localhost:#{port}/function/dummy_function
    EOS

    begin
      cp_r pkgshare/"template", testpath

      output = shell_output("#{bin}/faas-cli deploy -yaml test.yml")
      assert_equal expected, output.chomp

      rm_rf "template"

      output = shell_output("#{bin}/faas-cli deploy -yaml test.yml 2>&1", 1)
      assert_match "stat ./template/python/template.yml", output

      assert_match "ruby", shell_output("#{bin}/faas-cli template pull 2>&1")
      assert_match "node", shell_output("#{bin}/faas-cli new --list")

      output = shell_output("#{bin}/faas-cli deploy -yaml test.yml")
      assert_equal expected, output.chomp

      stable_resource = stable.instance_variable_get(:@resource)
      commit = stable_resource.instance_variable_get(:@specs)[:revision]
      faas_cli_version = shell_output("#{bin}/faas-cli version")
      assert_match /\s#{commit}$/, faas_cli_version
      assert_match /\s#{version}$/, faas_cli_version
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
