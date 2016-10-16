class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"

  stable do
    url "https://github.com/nabla-c0d3/sslyze/archive/0.14.1.tar.gz"
    sha256 "af432ab4254dd8d2c0d3aa514bb83db3d1b3e602e8c29e1aa6a233890f0f8658"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/0.14.1.tar.gz"
      sha256 "2bd2f42f4c3144c2834e96e3e0d4ad2f158ee2a8655f2ba649b7aa41c8840baa"
    end

    resource "openssl" do
      url "https://github.com/PeterMosmans/openssl.git",
          :revision => "b5caa78f0c54e7f7746b2c3bbfd1d786c8fd21f9"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "309240b841786862dfaea4f3fd026541807e9b6afc05e4e99f01abee2f453c1c" => :sierra
    sha256 "8628558f0114cf3329859a056a8fc619de5388732b57553157041f363c563e32" => :el_capitan
    sha256 "95f5f3bd69bbf9cb1a4780da906fd2cd11d2d467633080c9ddcaa5976edbed48" => :yosemite
  end

  head do
    url "https://github.com/nabla-c0d3/sslyze.git"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl.git"
    end

    resource "openssl" do
      url "https://github.com/PeterMosmans/openssl.git",
          :branch => "1.0.2-chacha"
    end
  end

  depends_on :arch => :x86_64
  depends_on :python if MacOS.version <= :snow_leopard

  resource "zlib" do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/z/zlib/zlib_1.2.8.dfsg.orig.tar.gz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/z/zlib/zlib_1.2.8.dfsg.orig.tar.gz"
    version "1.2.8"
    sha256 "2caecc2c3f1ef8b87b8f72b128a03e61c307e8c14f5ec9b422ef7914ba75cf9f"
  end

  def install
    venv = virtualenv_create(libexec)
    resource("nassl").stage do
      nassl_path = Pathname.pwd
      # openssl fails on parallel build. Related issues:
      # - https://rt.openssl.org/Ticket/Display.html?id=3736&user=guest&pass=guest
      # - https://rt.openssl.org/Ticket/Display.html?id=3737&user=guest&pass=guest
      ENV.deparallelize do
        mv "bin/openssl/include", "nassl_openssl_include"
        rm_rf "bin" # make sure we don't use the prebuilt binaries
        (nassl_path/"bin/openssl").install "nassl_openssl_include" => "include"
        (nassl_path/"zlib-#{resource("zlib").version}").install resource("zlib")
        (nassl_path/"openssl").install resource("openssl")
        system "python", "build_from_scratch.py"
      end
      system "python", "run_tests.py"
      venv.pip_install nassl_path
    end
    venv.pip_install_and_link buildpath

    ENV.prepend "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", "run_tests.py"
  end

  test do
    assert_match "SCAN COMPLETED", shell_output("#{bin}/sslyze --regular google.com")
  end
end
