class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.074.1.tar.gz"
    sha256 "1e4191beaa6cce4ebf1810e01884b646b3bac7b098e1ae577a7f55be59dfc336"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.074.1.tar.gz"
      sha256 "c1171677ed1a3803e751feeacd8df82288872f78a5170471b7ca7c61631348cd"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.074.1.tar.gz"
      sha256 "2bec9f067256c7a1a8fcf62f8a59ae82f094479cfac0e385280afc6af23cbea8"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.074.1.tar.gz"
      sha256 "2fbaf425554210786b865d1e468698d46c48462b118a25a201ce1865445b217b"
    end
  end

  bottle do
    rebuild 1
    sha256 "bb0c728fcd34d90c36c4bc215b9291092fc8929aa589f3fd4580abde00c08764" => :sierra
    sha256 "bd7dc4ab98eb74dc92d53977bba0a33a460918b3fe6aa920f9d277ddbcb764d0" => :el_capitan
    sha256 "0ea36562dce24a35cfb68bb207f04b0baa2a074e5768856256112013a31c734d" => :yosemite
  end

  devel do
    url "https://github.com/dlang/dmd/archive/v2.075.0-b3.tar.gz"
    version "2.075.0-b3"
    sha256 "441e7156138772f9091cd51ee4b6446966697a64e75222ff2e012baf310ce08b"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.075.0-b3.tar.gz"
      version "2.075.0-b3"
      sha256 "a800770c1d88c90093481851342e22945d0edf83267dcc94c915f219a22909d4"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.075.0-b3.tar.gz"
      version "2.075.0-b3"
      sha256 "15e25d8b17c4678516c97152ee7290ebea69d6c31ea51b72b488251ca4123832"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.075.0-b3.tar.gz"
      version "2.075.0-b3"
      sha256 "45cfe85beaa591196286e979877cb3d0442fadfe3258afdf805b0cf95efc1a0d"
    end
  end

  head do
    url "https://github.com/dlang/dmd.git"

    resource "druntime" do
      url "https://github.com/dlang/druntime.git"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos.git"
    end

    resource "tools" do
      url "https://github.com/dlang/tools.git"
    end
  end

  def install
    make_args = ["INSTALL_DIR=#{prefix}", "MODEL=#{Hardware::CPU.bits}", "-f", "posix.mak"]

    system "make", "SYSCONFDIR=#{etc}", "TARGET_CPU=X86", "AUTO_BOOTSTRAP=1", "RELEASE=1", *make_args

    bin.install "src/dmd"
    prefix.install "samples"
    man.install Dir["docs/man/*"]

    # A proper dmd.conf is required for later build steps:
    conf = buildpath/"dmd.conf"
    # Can't use opt_include or opt_lib here because dmd won't have been
    # linked into opt by the time this build runs:
    conf.write <<-EOS.undent
        [Environment]
        DFLAGS=-I#{include}/dlang/dmd -L-L#{lib}
        EOS
    etc.install conf
    install_new_dmd_conf

    make_args.unshift "DMD=#{bin}/dmd"

    (buildpath/"druntime").install resource("druntime")
    (buildpath/"phobos").install resource("phobos")

    system "make", "-C", "druntime", *make_args
    system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.a"]

    resource("tools").stage do
      inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
      system "make", "install", *make_args
    end
  end

  # Previous versions of this formula may have left in place an incorrect
  # dmd.conf.  If it differs from the newly generated one, move it out of place
  # and warn the user.
  # This must be idempotent because it may run from both install() and
  # post_install() if the user is running `brew install --build-from-source`.
  def install_new_dmd_conf
    conf = etc/"dmd.conf"

    # If the new file differs from conf, etc.install drops it here:
    new_conf = etc/"dmd.conf.default"
    # Else, we're already using the latest version:
    return unless new_conf.exist?

    backup = etc/"dmd.conf.old"
    opoo "An old dmd.conf was found and will be moved to #{backup}."
    mv conf, backup
    mv new_conf, conf
  end

  def post_install
    install_new_dmd_conf
  end

  test do
    system bin/"dmd", prefix/"samples/hello.d"
    system "./hello"
  end
end
