class Arangodb < Formula
  desc "The Multi-Model NoSQL Database."
  homepage "https://www.arangodb.com/"
  url "https://www.arangodb.com/repositories/Source/ArangoDB-3.1.18.tar.gz"
  sha256 "59d30d1eceb24719e420c76c43a236695a89dd6d58c18b76fa44edbb70d1380c"
  head "https://github.com/arangodb/arangodb.git", :branch => "unstable"

  bottle do
    sha256 "397a2248ded9812ef37787c021d52af561d54e1f6c25bf0692c5a18e8fe4f7fb" => :sierra
    sha256 "02abab7711273d84ef69189ea04c5a87a5aa6f069e77dd2aa8b4beeb6bb621b0" => :el_capitan
    sha256 "dc4db4a43332a6bed2473d5ef8d567b56a7cf5e4422a004be5e6b17c89193262" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "openssl"

  needs :cxx11

  fails_with :clang do
    build 600
    cause "Fails with compile errors"
  end

  def install
    ENV.cxx11

    mkdir "build" do
      args = std_cmake_args + %W[
        -DHOMEBREW=ON
        -DUSE_OPTIMIZE_FOR_ARCHITECTURE=OFF
        -DASM_OPTIMIZATIONS=OFF
        -DCMAKE_INSTALL_DATADIR=#{share}
        -DCMAKE_INSTALL_DATAROOTDIR=#{share}
        -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
        -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      ]

      if ENV.compiler == "gcc-6"
        ENV.append "V8_CXXFLAGS", "-O3 -g -fno-delete-null-pointer-checks"
      end

      system "cmake", "..", *args
      system "make", "install"

      %w[arangod arango-dfdb arangosh foxx-manager].each do |f|
        inreplace etc/"arangodb3/#{f}.conf", pkgshare, opt_pkgshare
      end
    end
  end

  def post_install
    (var/"lib/arangodb3").mkpath
    (var/"log/arangodb3").mkpath
  end

  def caveats
    s = <<-EOS.undent
      An empty password has been set. Please change it by executing
        #{opt_sbin}/arango-secure-installation
    EOS

    s
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/arangodb/sbin/arangod"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_sbin}/arangod</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    testcase = "require('@arangodb').print('it works!')"
    output = shell_output("#{bin}/arangosh --server.password \"\" --javascript.execute-string \"#{testcase}\"")
    assert_equal "it works!", output.chomp
  end
end
