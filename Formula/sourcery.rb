class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code."
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/Antondomashnev/Sourcery/archive/0.7.3.tar.gz"
  sha256 "f8dd2dfb5457c35f443435a5cd3fef52721aaf11fccfa17151551e7f1d725e34"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    cellar :any
    sha256 "be0bc3455738f797ee6d025544d36a3987d4246f80e514bad59642098a635546" => :sierra
  end

  depends_on :xcode => ["6.0", :run]
  depends_on :xcode => ["8.3", :build]

  def install
    ENV.delete("CC")
    ENV["SDKROOT"] = MacOS.sdk_path
    system "swift", "build", "-c", "release", "-Xswiftc", "-static-stdlib"
    bin.install ".build/release/sourcery"
    lib.install Dir[".build/release/*.dylib"]
  end

  test do
    # Tests are temporarily disabled because of sandbox issues,
    # as Sourcery tries to write to ~/Library/Caches/Sourcery
    # See https://github.com/krzysztofzablocki/Sourcery/pull/133
    #
    # Remove this test once the PR has been merged and been tagged with a release
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp

    # Re-enable these tests when the issue has been closed
    #
    # (testpath/"Test.swift").write <<-TEST_SWIFT
    # enum One { }
    # enum Two { }
    # TEST_SWIFT
    #
    # (testpath/"Test.stencil").write <<-TEST_STENCIL
    # // Found {{ types.all.count }} Types
    # // {% for type in types.all %}{{ type.name }}, {% endfor %}
    # TEST_STENCIL

    # system "#{bin}/sourcery", testpath/"Test.swift", testpath/"Test.stencil", testpath/"Generated.swift"

    # expected = <<-GENERATED_SWIFT
    # // Generated using Sourcery 0.5.3 - https://github.com/krzysztofzablocki/Sourcery
    # // DO NOT EDIT
    #
    #
    # // Found 2 Types
    # // One, Two,
    # GENERATED_SWIFT
    # assert_match expected, (testpath/"Generated.swift").read, "sourcery generation failed"
  end
end
