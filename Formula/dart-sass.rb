require "yaml"

class DartSass < Formula
  desc "Dart implementation of a Sass compiler"
  homepage "https://sass-lang.com"

  url "https://github.com/sass/dart-sass/archive/1.23.7.tar.gz"
  sha256 "1b73dec233a1cea21748b3f70bcdd46597a11951ec19d2c77a6e1e44446d1c37"

  bottle do
    cellar :any_skip_relocation
    sha256 "132f6f3232a75c468dd999a7b072816d0155414e95aa22f0a55f30923dad5f27" => :catalina
    sha256 "23fe7292d57c51da8725a61fc979d6ca70f5e8f53e26d36a10e33935330f0ceb" => :mojave
    sha256 "05cdefccde842c5b2536f03652cd894a61737d06f1cfb02ceed0cff5fdf8a1b2" => :high_sierra
  end

  depends_on "dart-lang/dart/dart" => :build

  def install
    dart = Formula["dart-lang/dart/dart"].opt_bin

    pubspec = YAML.safe_load(File.read("pubspec.yaml"))
    version = pubspec["version"]

    # Tell the pub server where these installations are coming from.
    ENV["PUB_ENVIRONMENT"] = "homebrew:sass"

    system dart/"pub", "get"
    if Hardware::CPU.is_64_bit?
      # Build a native-code executable on 64-bit systems only. 32-bit Dart
      # doesn't support this.
      system dart/"dart2native", "-Dversion=#{version}", "bin/sass.dart",
             "-o", "sass"
      bin.install "sass"
    else
      system dart/"dart",
             "--snapshot=sass.dart.app.snapshot",
             "--snapshot-kind=app-jit",
             "bin/sass.dart", "tool/app-snapshot-input.scss"
      lib.install "sass.dart.app.snapshot"

      # Copy the version of the Dart VM we used into our lib directory so that if
      # the user upgrades their Dart VM version it doesn't break Sass's snapshot,
      # which was compiled with an older version.
      cp dart/"dart", lib

      (bin/"sass").write <<~SH
        #!/bin/sh
        exec "#{lib}/dart" "-Dversion=#{version}" "#{lib}/sass.dart.app.snapshot" "$@"
      SH
    end
    chmod 0555, "#{bin}/sass"
  end

  test do
    (testpath/"test.scss").write(".class {property: 1 + 1}")
    assert_match "property: 2;", shell_output("#{bin}/sass test.scss 2>&1")
  end
end
