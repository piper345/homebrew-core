class GoAT111 < Formula
  desc "Go programming environment (1.11)"
  homepage "https://golang.org"
  url "https://dl.google.com/go/go1.11.5.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.11.5.src.tar.gz"
  sha256 "bc1ef02bb1668835db1390a2e478dcbccb5dd16911691af9d75184bbe5aa943e"

  bottle do
    sha256 "5e5bbea84806419db205b7ce36f0869fe1680e467750f302fdfbcafbe7e4c577" => :mojave
    sha256 "dd25182bb8e6322842448e953693f2027f5102d8fcddee0714aa71217d0c4a32" => :high_sierra
    sha256 "583bfb93a21ca0c0d672cc3123d925b30b33299ba6843ef91585727f4d8efef2" => :sierra
  end

  keg_only :versioned_formula

  resource "gotools" do
    url "https://go.googlesource.com/tools.git",
        :branch => "release-branch.go1.11"
  end

  # Don't update this unless this version cannot bootstrap the new version.
  resource "gobootstrap" do
    url "https://storage.googleapis.com/golang/go1.7.darwin-amd64.tar.gz"
    version "1.7"
    sha256 "51d905e0b43b3d0ed41aaf23e19001ab4bc3f96c3ca134b48f7892485fc52961"
  end

  def install
    # Temporary workaround for garbage folders which were included in the 1.11.5 release tarball
    mv Dir.glob("go/*"), "./"
    rm_rf "go"
    rm_rf "gocache"
    rm_rf "tmp"

    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      ENV["GOOS"]         = "darwin"
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "-race", "std"

    # Build and install godoc
    ENV.prepend_path "PATH", bin
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/golang.org/x/tools").install resource("gotools")
    cd "src/golang.org/x/tools/cmd/godoc/" do
      system "go", "build"
      (libexec/"bin").install "godoc"
    end
    bin.install_symlink libexec/"bin/godoc"
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    EOS
    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    # godoc was installed
    assert_predicate libexec/"bin/godoc", :exist?
    assert_predicate libexec/"bin/godoc", :executable?

    ENV["GOOS"] = "freebsd"
    system bin/"go", "build", "hello.go"
  end
end
