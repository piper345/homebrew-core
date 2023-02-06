class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/e7/7c/12bcf0aa9f564e5df663df93dacae6cbd67151df17c55f5f7d9640381a52/python-openstackclient-6.0.0.tar.gz"
  sha256 "91c3ac12da4b423c16b3917616f84a23e2961e750fce590d409ecc50ee0431ce"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "b3f851a97b9dd555314540d4fc0e04fa653318f45d49e32fc8292d008094999b"
    sha256 cellar: :any,                 arm64_monterey: "8418903ff38439bf797392bb5883cd876ce5bca1e7f690fd4aea3ca97bf66555"
    sha256 cellar: :any,                 arm64_big_sur:  "a77672b932ac3aba3d3ecbc16610ea9a34af9336a30dc3a1d3828f5918becf01"
    sha256 cellar: :any,                 ventura:        "c87a1d8a2838c27531046d9f1f6e17e517599db06e2fccf91d9dcf1813e8d77a"
    sha256 cellar: :any,                 monterey:       "fd428dae7e397eff176bf12b21e488351053ce740a3eb114295f371abeca66cb"
    sha256 cellar: :any,                 big_sur:        "c95d3a10609da60564e192fc99300159a2c310dd1686a37e92e66f0d2a2f334f"
    sha256 cellar: :any,                 catalina:       "93caa1f18daf27a0fb73d36aadc4145bc4976e7a79f4cf330c39cfa84a67a3d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3dd6f55727a668439495e384656b13b6a8d4922593f7d6ec1a27b11c57455d6"
  end

  depends_on "rust" => :build
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/36/b1/e5a1c2ebeb64ccc9c2a4ae133f5955d9824482628ed4bf0331c73323f0de/autopage-0.5.1.tar.gz"
    sha256 "01be3ee61bb714e9090fcc5c10f4cf546c396331c620c6ae50a2321b28ed3199"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/ff/80/45b42203ecc32c8de281f52e3ec81cb5e4ef16127e9e8543089d8b1649fb/Babel-2.11.0.tar.gz"
    sha256 "5ef4b3226b0180dedded4229651c8b0e1a3a6a2837d45a073272f313e4cf97f6"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/b2/4c/3cfdb24a1db87b00ed3d1818ae0e32d51733f21aae3da6508091a392f5aa/cliff-4.1.0.tar.gz"
    sha256 "bbee82127308472a3123ed10b5289616cb2c435074656dd072e55363053d091c"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/13/04/b85213575a7bf31cbf1d699cc7d5500d8ca8e52cbd1f3569a753a5376d5c/cmd2-2.4.3.tar.gz"
    sha256 "71873c11f72bd19e2b1db578214716f0d4f7c8fa250093c601265a9a717dee52"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/12/e3/c46c274cf466b24e5d44df5d5cd31a31ff23e57f074a2bb30931a8c9b01a/cryptography-39.0.0.tar.gz"
    sha256 "f964c7dcf7802d133e8dbd1565914fa0194f9d683d82411989889ecd701e8adf"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/c8/7d/904f64535d04f754c20a02a296de0bf3fb02be8ff5274155e41c89ae211a/debtcollector-2.5.0.tar.gz"
    sha256 "dc9d1ad3f745c43f4bbedbca30f9ffe8905a8c028c9926e61077847d5ea257ab"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/e4/11/c5c200e774fb6cca03288c25cdb600fb8c41f2ace38a7ebfedfd3de3c3e1/dogpile.cache-1.1.8.tar.gz"
    sha256 "d844e8bb638cc4f544a4c89a834dfd36fe935400b71a16cbd744ebdfb720fd4e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/90/07/6397ad02d31bddf1841c9ad3ec30a693a3ff208e09c2ef45c9a8a5f85156/importlib_metadata-6.0.0.tar.gz"
    sha256 "e354bedeb60efa6affdcc8ae121b73544a7aa74156d047311948f6d711cd378d"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/31/8c/1c342fdd2f4af0857684d16af766201393ef53318c15fa785fcb6c3b7c32/iso8601-1.1.0.tar.gz"
    sha256 "32811e7b81deee2063ea6d2e94f8819a86d1f3811e49d23623a41fa832bef03f"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/21/67/83452af2a6db7c4596d1e2ecaa841b9a900980103013b867f2865e5e1cf0/jsonpatch-1.32.tar.gz"
    sha256 "b6ddfe6c3db30d81a96aaeceb6baf916094ffa23d7dd5fa2c13e13f8b6e600c2"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/a0/6c/c52556b957a0f904e7c45585444feef206fe5cb1ff656303a1d6d922a53b/jsonpointer-2.3.tar.gz"
    sha256 "97cba51526c829282218feb99dab1b1e6bdf8efd1c43dc9d57be093c0d69c99a"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/25/b8/bd7525863b70ad2f7c74c5b0105e1a0270f44ff86d2c61d8cd6b3a5c72ab/keystoneauth1-5.1.1.tar.gz"
    sha256 "8ca23b5bf9cb6bc2c836790326505c85c01ad78d707b43d6b766197bdb26d1d3"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/22/44/0829b19ac243211d1d2bd759999aa92196c546518b0be91de9cacc98122a/msgpack-1.0.4.tar.gz"
    sha256 "f5d869c18f030202eb412f08b28d2afeea553d6613aee89e200d7aca7ef01f5f"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/c3/3b/fe5bda7a3e927d9008c897cf1a0858a9ba9924a6b4750ec1824c9e617587/netaddr-0.8.0.tar.gz"
    sha256 "d6cc57c7a07b1d9d2e917aa8b36ae8ce61c35ba3fcd1b83ca31c5a0ee2b5a243"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a6/91/86a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73/netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/2c/34/83a6dd5c0b954719fcf68be612e64617a8e78a216930b56820fe45ffc36a/openstacksdk-1.0.0.tar.gz"
    sha256 "cf6bd519e301f784bfe756c1f937f8ec1caf3fd0564354f3407a45192f0547cc"
  end

  resource "os-client-config" do
    url "https://files.pythonhosted.org/packages/58/be/ba2e4d71dd57653c8fefe8577ade06bf5f87826e835b3c7d5bb513225227/os-client-config-2.1.0.tar.gz"
    sha256 "abc38a351f8c006d34f7ee5f3f648de5e3ecf6455cc5d76cfd889d291cdf3f4e"
  end

  resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/58/3f/09e93eb484b69d2a0d31361962fb667591a850630c8ce47bb177324910ec/os-service-types-1.7.0.tar.gz"
    sha256 "31800299a82239363995b91f1ebf9106ac7758542a1e4ef6dc737a5932878c6c"
  end

  resource "osc-lib" do
    url "https://files.pythonhosted.org/packages/87/ea/06418a0b00ffc10577ba8c840c6ab05ca542ee2d5bb1078789c68d12c918/osc-lib-2.6.2.tar.gz"
    sha256 "879b6c5a142f3294464748ab14adde0cba0a14a5f704a0d840c9e92144489dba"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/ce/e3/ef9a432d8bf61f1077d3b5cf7ab68e0b9047a773208dce017004d2b9ccd4/oslo.config-9.1.0.tar.gz"
    sha256 "85342c1c4ba658781673f57da0260c4831045353cad2df325fd374e1783d2a6b"
  end

  resource "oslo.context" do
    url "https://files.pythonhosted.org/packages/96/e1/7bac157e4a828b1d64510ba0b4362a74b4c68ecc8c8588d6d22145b0f4a8/oslo.context-5.0.0.tar.gz"
    sha256 "88c0c6d076681c60d560f7d66565e42ac116c5aa8a28a04db7c0ac0025133224"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/7c/d8/a56cdadc3eb21f399327c45662e96479cb73beee0d602769b7847e857e7d/oslo.i18n-5.1.0.tar.gz"
    sha256 "6bf111a6357d5449640852de4640eae4159b5562bbba4c90febb0034abc095d0"
  end

  resource "oslo.log" do
    url "https://files.pythonhosted.org/packages/4a/08/e2d77dba0f47664b75a0cd0431e08cb1636b3096cd6aeba77a0c1c68190b/oslo.log-5.0.2.tar.gz"
    sha256 "e45e7312aa71528a16736ce45152be3f1af123f5ef62aa81da046805584fcca3"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/c0/00/166651f281396a57d5342f1d8be772c7f54bbb128b6753ee8bf3943ad7e6/oslo.serialization-5.0.0.tar.gz"
    sha256 "2845328d0f47dc8a23fed2a82253e90acff0aa731dbd24f379cf8e50e6cc66ba"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/f7/49/7f6790af38e9ce1a1418dd74c7d07492d711384269b1cecc69bef136b033/oslo.utils-6.1.0.tar.gz"
    sha256 "76bc0108d50aca972b68fec8298e791b5fbcbeb9a51a27c6986b41b0a6a62eeb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/ba/b6/8e78337766d4c324ac22cb887ecc19487531f508dbf17d922b91492d55bb/prettytable-3.6.0.tar.gz"
    sha256 "2e0026af955b4ea67b22122f310b90eae890738c08cb0458693a49b6221530ac"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/9d/f6/b32f1ff535052aa763ea05f87ad4df2d4b55b8ba84b3ba03bfa0f73bef18/python-cinderclient-9.2.0.tar.gz"
    sha256 "aa762875a270af49057caca87d5b034e630b3180dec6a193cfcb9279f3d63df4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/ec/a4/79af46d8213e0a70c768a35cc4ec9eb06a854baf4bf61488da1e9e643684/python-heatclient-3.1.0.tar.gz"
    sha256 "fd25bc8518f9f3c37efb80aecfb7a56d4d2a3befb82619b5bdad3af499cd999a"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/a0/dd/81d3d89231a09445e4b2a13a374aeed8f3abb82ff7c0ecb5da87bebb6790/python-keystoneclient-5.0.1.tar.gz"
    sha256 "a8bbf671f56c24aa5a37a225b98f2994b82063d73e3486657eb500a33a406d29"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/02/b3/0c7942e654eec1428544237e1e0911c792e5abf763403bd825ce0c3bef07/python-neutronclient-8.2.1.tar.gz"
    sha256 "0161ef1bb0a2191022436790b529da6bd930f054a0501f5a8fb77413ed333976"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/33/42/cb56ec08f381ef2f3c130c86893a7602522df0f4901c87998a6dcb3d15fe/python-novaclient-18.2.0.tar.gz"
    sha256 "185bbf2cafb5f3d761f272e3e184a700cc7ba5cf7d51619065be7f5c4b5b7cf4"
  end

  resource "python-octaviaclient" do
    url "https://files.pythonhosted.org/packages/db/ab/6e8ddee53ee67d8382d6a238acbc30645a598b47b954da19e6959fa349c3/python-octaviaclient-3.2.0.tar.gz"
    sha256 "d4bde8457c9d976598d719c5eddc56589d67bd2bd09dcb8493e3c07e9c0067a0"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/93/bc/e9fa2d72443623df0561d86f576aeadc1cd95a8dfe551d2724c4f6da2552/python-swiftclient-4.1.0.tar.gz"
    sha256 "f82298e4a48f7cbdd680f2638c85d1ca7ae1a76edbe30036d21b4cd7a29c09eb"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/03/3e/dc5c793b62c60d0ca0b7e58f1fdd84d5aaa9f8df23e7589b39cc9ce20a03/pytz-2022.7.1.tar.gz"
    sha256 "01a0681c4b9684a28304615eba55d1ab31ae00bf68ec157ec3708a8182dbbcd0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/b1/86/a67f6f595c5da14fa80bb4a8f7084c391ac1bfd3208ea4906307afc2b181/simplejson-3.18.3.tar.gz"
    sha256 "ebb53837c5ffcb6100646018565d3f1afed6f4b185b14b2c9cbccf874fe40157"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/66/c0/26afabea111a642f33cfd15f54b3dbe9334679294ad5c0423c556b75eba2/stevedore-4.1.1.tar.gz"
    sha256 "7f8aeb6e3f90f96832c301bff21a7eb5eefbe894c88c506483d355565d88cc1a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/1f/29/54ba1934c45af649698410456fa8a78a475c82efd5c562e51011079458d1/zipp-3.12.1.tar.gz"
    sha256 "a3cac813d40993596b39ea9e93a18e8a2076d5c378b8bc88ec32ab264e04ad02"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"openstack", "-h"
    openstack_subcommands = [
      "server list",
      "stack list",
      "loadbalancer list",
    ]
    openstack_subcommands.each do |subcommand|
      output = shell_output("#{bin}/openstack #{subcommand} 2>&1", 1)
      assert_match "Missing value auth-url required", output
    end
  end
end
