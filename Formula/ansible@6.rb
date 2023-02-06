class AnsibleAT6 < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://files.pythonhosted.org/packages/f5/8c/a4e46c1621e6f95559bb59a28cd62f817581c3d591db1353496f6a80eebd/ansible-6.7.0.tar.gz"
  sha256 "c188f3ac8a8583794aadcff0bea87895ead58c19d6f244cd0c342562706e176c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4eef44d32ee4a9bf33589d86636eba0d32cec5827f601bda54abc9f4b2de5279"
    sha256 cellar: :any,                 arm64_monterey: "aa37bda45dd7bae690b7be3043f7c1018fe1c8ea39eb3bc8adee4e533bc852df"
    sha256 cellar: :any,                 arm64_big_sur:  "831da82b09e7673adc5554e423bf7571c954a4a16923fc26075104591026525a"
    sha256 cellar: :any,                 ventura:        "abe382530dadfa29070b4606b204ad9cfe2842d0e89c2d7cee54ad2d63c71314"
    sha256 cellar: :any,                 monterey:       "0620043ecc0b1242a0f2b9962226c826f995222a7f274236c8a48a82d038f485"
    sha256 cellar: :any,                 big_sur:        "4b72dc1b4477a5e28f4875871405617ea4c1e7097acfc48539ff606b1ef5ecd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4798045e9dd2987d57190c3835c7dd673560b418acbce956148346f4c877ffa"
  end

  keg_only :versioned_formula

  # https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html#ansible-community-package-release-cycle
  deprecate! date: "2022-12-24", because: :unmaintained

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "krb5"
  uses_from_macos "libffi"
  uses_from_macos "libxslt"

  # This will collect requirements from:
  #   ansible
  #   docker
  #   python-neutronclient (OpenStack)
  #   shade (OpenStack)
  #   pywinrm (Windows)
  #   kerberos (Windows)
  #   boto3 (AWS)
  #   apache-libcloud (Google GCE)
  #   passlib (htpasswd core module)
  #   zabbix-api (Zabbix extras module)
  #   junos-eznc (Juniper device support)
  #   jxmlease (Juniper device support)
  #   dnspython (DNS Lookup - dig)
  #   pysphere3 (VMware vSphere support)
  #   python-consul (Consul support)
  #   requests-credssp (CredSSP support for windows hosts)
  #   openshift (k8s module support)
  #   pexpect (expect module support)
  #   ntc-templates (Parsing semi-structured text)
  #   proxmoxer (Proxmox VE support)

  # Automatically updated resources
  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/68/c9/ddab83ed69c3ce120af4f064bc56976442e4d1d595a787131e4b14cf6468/ansible-core-2.13.7.tar.gz"
    sha256 "a9d5f942ff0dcbeec3d7183a898ea4f656d233d6055d4bc8e22e37b013b1881a"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/12/e3/c46c274cf466b24e5d44df5d5cd31a31ff23e57f074a2bb30931a8c9b01a/cryptography-39.0.0.tar.gz"
    sha256 "f964c7dcf7802d133e8dbd1565914fa0194f9d683d82411989889ecd701e8adf"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/ac/20/9541749d77aebf66dd92e2b803f38a50e3a5c76e7876f45eb2b37e758d82/resolvelib-0.8.1.tar.gz"
    sha256 "c6ea56732e9fb6fca1b2acc2ccc68a0b6b8c566d8f3e78e0443310ede61dbd37"
  end

  def install
    venv = virtualenv_create(libexec, "python3.10")
    # Install all of the resources declared on the formula into the virtualenv.
    resources.each do |r|
      # ansible-core provides all ansible binaries
      if r.name == "ansible-core"
        venv.pip_install_and_link r
      else
        venv.pip_install r
      end
    end
    venv.pip_install_and_link buildpath

    resource("ansible-core").stage do
      man1.install Pathname.glob("docs/man/man1/*.1")
    end
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<~EOS
      ---
      - hosts: all
        gather_facts: False
        tasks:
        - name: ping
          ping:
    EOS
    (testpath/"hosts.ini").write [
      "localhost ansible_connection=local",
      " ansible_python_interpreter=#{Formula["python@3.10"].opt_bin}/python3.10",
      "\n",
    ].join
    system bin/"ansible-playbook", testpath/"playbook.yml", "-i", testpath/"hosts.ini"

    # Ensure requests[security] is activated
    script = "import requests as r; r.get('https://mozilla-modern.badssl.com')"
    system libexec/"bin/python", "-c", script

    # Ensure ansible-vault can encrypt/decrypt files.
    (testpath/"vault-password.txt").write("12345678")
    (testpath/"vault-test-file.txt").write <<~EOS
      ---
      content:
        hello: world
    EOS
    system bin/"ansible-vault", "encrypt",
           "--vault-password-file", testpath/"vault-password.txt",
           testpath/"vault-test-file.txt"
    system bin/"ansible-vault", "decrypt",
           "--vault-password-file", testpath/"vault-password.txt",
           testpath/"vault-test-file.txt"
  end
end
