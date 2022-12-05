class AnsibleLint < Formula
  include Language::Python::Virtualenv

  desc "Checks ansible playbooks for practices and behaviour"
  homepage "https://github.com/ansible/ansible-lint/"
  url "https://files.pythonhosted.org/packages/fb/c0/915c941753e6ef9ca998621a5ee07a812a07d674cf5bb759de0488f1325d/ansible-lint-6.9.1.tar.gz"
  sha256 "4c85f0d61700042cab964dd7bdc9227137ba5490249f705acfd9de46eb00a07f"
  license all_of: ["MIT", "GPL-3.0-or-later"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49fdbcbb8cfb8e1861533282a94ba5c6a2ec5800cf37d6d7a39687c3d1d0bd28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cdec386d2c774e6d9a12cc70707c2f1fc940f8435685902864244878cb576d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8f38c8993b86c1035d4d089a5c6f3453dcf7c58b0fea0ff15b22b1e990f36da"
    sha256 cellar: :any_skip_relocation, ventura:        "ad2d249b924afd1f4ed33948a4cf3f854738651e09bc888d0de5d958a5607775"
    sha256 cellar: :any_skip_relocation, monterey:       "f7afb651f7070fd9b745f1293dacb97db4313acc6072a3e0a7b2d392f9e36e48"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7e3244cf8026507f2eba78f129b93d0bfaf8f5a41c1c43a2952e5252761f47b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d68b34845596efd8a05efb633d95548b1187b05b47d0c0e8be3237cd1f9e11c"
  end

  depends_on "pkg-config" => :build
  depends_on "ansible"
  depends_on "black"
  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "yamllint"

  resource "ansible-compat" do
    url "https://files.pythonhosted.org/packages/e6/1b/ec4cab729bea3531ad4368d1b66858f9cbee5edd84a32a9830ef7da1f1d2/ansible-compat-2.2.6.tar.gz"
    sha256 "8bb3488327125a0948d38b766389a4819573343d5673aa78a7bed23eb9d5b28d"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/b3/96/d53e290ddf6215cfb24f93449a1835eff566f79a1f332cf046a978df0c9e/bracex-2.3.post1.tar.gz"
    sha256 "e7b23fc8b2cd06d3dec0692baabecb249dda94e06a617901ff03a6c56fd71693"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/95/55/b897882bffb8213456363e646bf9e9fa704ffda5a7d140edf935a9e02c7b/filelock-3.8.0.tar.gz"
    sha256 "55447caa666f2198c5b6b13a26d2084d26fa5b115c00d065664b2124680c4edc"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/b8/ef/325da441a385a8a931b3eeb70db23cb52da42799691988d8d943c5237f10/pyrsistent-0.19.2.tar.gz"
    sha256 "bfa0351be89c9fcbcb8c9879b826f4353be10f58f8a677efab0c017bf7137ec2"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "subprocess-tee" do
    url "https://files.pythonhosted.org/packages/76/1b/653bc93bf15738ab2fe83a875d28354cbe7402b12e22801d35e5461fe3f2/subprocess-tee-0.4.0.tar.gz"
    sha256 "7ea885ff32cdb2b2d3b2a6c464492f2ee1ebbf324e50598d75de4f6f3ea0f149"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/b7/94/5dd083fc972655f6689587c3af705aabc8b8e781bacdf22d6d2282fe6142/wcmatch-8.4.1.tar.gz"
    sha256 "b1f042a899ea4c458b7321da1b5e3331e3e0ec781583434de1301946ceadb943"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.11")
    %w[ansible black yamllint].each do |package_name|
      package = Formula[package_name].opt_libexec
      (libexec/site_packages/"homebrew-#{package_name}.pth").write package/site_packages
    end
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<~EOS
      ---
      - hosts: all
        gather_facts: false
        tasks:
        - name: ping
          ansible.builtin.ping:
    EOS
    system bin/"ansible-lint", testpath/"playbook.yml"
  end
end
