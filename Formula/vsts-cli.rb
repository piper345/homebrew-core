class VstsCli < Formula
  include Language::Python::Virtualenv

  desc "Manage and work with VSTS/TFS resources from the command-line"
  homepage "https://docs.microsoft.com/en-us/cli/vsts"
  url "https://files.pythonhosted.org/packages/f9/c2/3ed698480ab30d2807fc961eef152099589aeaec3f1407945a4e07275de5/vsts-cli-0.1.4.tar.gz"
  sha256 "27defe1d8aaa1fcbc3517274c0fdbd42b5ebe2c1c40edfc133d98fe4bb7114de"
  license "MIT"
  revision 5

  bottle do
    sha256 cellar: :any, arm64_monterey: "4dc169e5bbff8bd9eaa9db72b8b2a83d83716e40202854906cd8ac59cdc0bc5c"
    sha256 cellar: :any, arm64_big_sur:  "752413507a6e22fe0b1a2c1ac153b71707d18cd169ae3449de5f273fd703b990"
    sha256 cellar: :any, monterey:       "d584b9d130263ae074a4c4c7332ecd46108c527939407dbef22a7d9cbb4b0126"
    sha256 cellar: :any, big_sur:        "d7efb21997c73cca1c609e1e720f7322ff5329961fb8908c4ad3d40370c167e8"
    sha256 cellar: :any, catalina:       "f77d99672e32d1b8a5fc5fc01d8dcc6a4959af4a369d67c32a595fc1503fdbaf"
  end

  # https://github.com/Azure/azure-devops-cli-extension/pull/219#issuecomment-456404611
  disable! date: "2022-05-27", because: :unsupported

  depends_on "rust" => :build
  depends_on "python@3.9"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/ea/8d/a7121ffe5f402dc015277d2d31eb82d2187334503a011c18f2e78ecbb9b2/entrypoints-0.4.tar.gz"
    sha256 "b706eddaa9218a19ebcd67b56818f05bb27589b1ca9e8d797b74affad4ccacd4"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/0d/2d/8cb8583e4dc4e44932460c88dbe1d7fde907df60589452342bc242ac7da0/humanfriendly-4.7.tar.gz"
    sha256 "ee071c8f6c7457db53472ae9974aaf561c95fdbe072e1f2a3ba29aaa6ca51098"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/a0/c9/c08bf10bd057293ff385abaef38e7e548549bbe81e95333157684e75ebc6/keyring-13.2.1.tar.gz"
    sha256 "6364bb8c233f28538df4928576f4e051229e0451651073ab20b315488da16a58"
  end

  resource "knack" do
    url "https://files.pythonhosted.org/packages/b5/58/2ba172d2ea8babae13a2a4d3fc0be810fd067429f990e850e4088f22494e/knack-0.4.1.tar.gz"
    sha256 "ba45fd69c2faf91fd3d6e95cec1c0ef7e0f4362e33c59bf5a260216ffcb859a0"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/bb/2c/e8ac4f491efd412d097d42c9eaf79bcaad698ba17ab6572fd756eb6bd8f8/msrest-0.6.21.tar.gz"
    sha256 "72661bc7bedc2dc2040e8f170b6e9ef226ee6d3892e01affd4d26b06474d68d8"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/da/6a/c427c06913204e24de28de5300d3f0e809933f376e0b7df95194b2bb3f71/Pygments-2.14.0.tar.gz"
    sha256 "b3ed06a9e8ac9a9aae5a6f5dbe78a8a58655d17b43b93c078f094ddc476ae297"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/a0/b0/a4e3241d2dee665fea11baec21389aec6886655cd4db7647ddf96c3fad15/python-dateutil-2.7.3.tar.gz"
    sha256 "e27001de32f627c22380a688bcc43ce83504a7bc5da472209b4c70f02829f0b8"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "vsts" do
    url "https://files.pythonhosted.org/packages/ce/fa/4405cdb2a6b0476a94b24254cdfb1df7ff43138a91ccc79cd6fc877177af/vsts-0.1.25.tar.gz"
    sha256 "da179160121f5b38be061dbff29cd2b60d5d029b2207102454d77a7114e64f97"
  end

  resource "vsts-cli-admin" do
    url "https://files.pythonhosted.org/packages/96/15/501240b53c6de9c81ba7c2c57e4a7227cc68eacb776a7b034178d7ffb56d/vsts-cli-admin-0.1.4.tar.gz"
    sha256 "d8a56dd57112a91818557043a8c1e98e26b8d9e793a448ceaa9df0439972cfd5"
  end

  resource "vsts-cli-admin-common" do
    url "https://files.pythonhosted.org/packages/fa/bc/13802bc886316f41f39ee47e086e60d1d2bf00b03399afbcb07bb8d3abd9/vsts-cli-admin-common-0.1.4.tar.gz"
    sha256 "6794d7b6d016b93e66613b84c31f67a90c2b296675b29b2ea9bbf1566e996f8a"
  end

  resource "vsts-cli-build" do
    url "https://files.pythonhosted.org/packages/69/8b/0b03651a621a8a1f438cbdad2023a6cf1bf83f528452ba628a33d773983f/vsts-cli-build-0.1.4.tar.gz"
    sha256 "e4152ead1961506371e8a17656b18bc8797034411c2b2d355b73250c86b27052"
  end

  resource "vsts-cli-build-common" do
    url "https://files.pythonhosted.org/packages/d9/2e/294931be3d181742362feb138084f2dfef4632aa6f9762e89c8e14b2d8a7/vsts-cli-build-common-0.1.4.tar.gz"
    sha256 "64fe48b944a04f2ae7df0afa9bfcd37b281d786d3558bb66c597c990f0745f08"
  end

  resource "vsts-cli-code" do
    url "https://files.pythonhosted.org/packages/98/ce/d2edb9adcb403b5abb76efcf6a9ae3c5e1943215a4fb1fa20062e3094853/vsts-cli-code-0.1.4.tar.gz"
    sha256 "2154f0769cdb694110886ef7859dda86f19c02f67d037dc592ae21772a51b938"
  end

  resource "vsts-cli-code-common" do
    url "https://files.pythonhosted.org/packages/63/8a/1afd03644034f2f81e912864f6f8457b7da95580e3319b45fe6e17d4dbb0/vsts-cli-code-common-0.1.4.tar.gz"
    sha256 "ed41220313ceb67612d6dc30596ef53cd2bbf1f55df826ca8cecd364a8a92130"
  end

  resource "vsts-cli-common" do
    url "https://files.pythonhosted.org/packages/d4/4e/58e5b3a1a36e2db2f032d26d3be78ef227467d69ac280f9d69d1abc514e6/vsts-cli-common-0.1.4.tar.gz"
    sha256 "a031ad9748b9dbd8552357b42a92363a641572fe1035540c2542b05078aa9005"
  end

  resource "vsts-cli-package" do
    url "https://files.pythonhosted.org/packages/2e/25/4c36f9d006c06fe0cf91694ec04ec68171492b9854e8e6ab5492c9db50c2/vsts-cli-package-0.1.4.tar.gz"
    sha256 "74ab09d40b2e3572518e618d0e46d227bfa3f5db999e936a04f590a4fc6ed1ec"
  end

  resource "vsts-cli-package-common" do
    url "https://files.pythonhosted.org/packages/26/d2/16071a391735a1d71d121fe0fb0789baedcb14192cda597027bc7538453f/vsts-cli-package-common-0.1.4.tar.gz"
    sha256 "07cbe4e4f6602b6ef7168a24110925433dbb357135c269952457c8c071ff877c"
  end

  resource "vsts-cli-release" do
    url "https://files.pythonhosted.org/packages/24/8e/245b35fc07684290628ed4cfd4e3821c8401c47091ce12f67efdc0cf81d9/vsts-cli-release-0.1.4.tar.gz"
    sha256 "9b82ed707da696c4708285e5f1ea4ff0f72a010c90e7c6d070267a8fb9343ca5"
  end

  resource "vsts-cli-release-common" do
    url "https://files.pythonhosted.org/packages/e5/2d/889686657c3d82b7768d95989fde922dddf64339735a3159848c5468f7d7/vsts-cli-release-common-0.1.4.tar.gz"
    sha256 "619022dd2e9092db941b6bb6dbc6958d1f5f2e6c41c67f015e181325a562e859"
  end

  resource "vsts-cli-team" do
    url "https://files.pythonhosted.org/packages/ed/7b/f6178e31d666257a80fd9ec8281809a4eead3de0f61c3031c4fad38f0c3c/vsts-cli-team-0.1.4.tar.gz"
    sha256 "ca966527eff69441d89a7aaa5758d53ab31d5d527acc064d29d72270f1b913a2"
  end

  resource "vsts-cli-team-common" do
    url "https://files.pythonhosted.org/packages/c6/d4/0d0d9b15d22e1a2044760152864279fc0c4054f8a0254e86529dad3fae53/vsts-cli-team-common-0.1.4.tar.gz"
    sha256 "57aab81b472d76ef010036ed90f7bd11fffb66c79c1991d64b0694a8b2f47c08"
  end

  resource "vsts-cli-work" do
    url "https://files.pythonhosted.org/packages/68/2d/547a18affb25bd1f8be2fdcec64df2a75fb5fb4377a5edd2432b522b46f6/vsts-cli-work-0.1.4.tar.gz"
    sha256 "dca2324f5445765a3ff4d9178d9b37c985b75e22c20660741d43ef24ac72ec74"
  end

  resource "vsts-cli-work-common" do
    url "https://files.pythonhosted.org/packages/36/51/d4b7accf6b9e009875f4a2c05ceba7ddd8936f99c2dde5f4308a40edc360/vsts-cli-work-common-0.1.4.tar.gz"
    sha256 "ec023e69d88292024e6bd5ac34b9d5913aa92c4ce148751c33fdf9da13e0d522"
  end

  resource "pycparser" do
    on_linux do
      url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz#sha256=a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
      sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
    end
  end

  resource "cffi" do
    on_linux do
      url "https://files.pythonhosted.org/packages/2d/bf/960e5a422db3ac1a5e612cb35ca436c3fc985ed4b7ed13a1b4879006f450/cffi-1.13.2.tar.gz#sha256=599a1e8ff057ac530c9ad1778293c665cb81a791421f46922d80a86473c13346"
      sha256 "599a1e8ff057ac530c9ad1778293c665cb81a791421f46922d80a86473c13346"
    end
  end

  resource "cryptography" do
    on_linux do
      url "https://files.pythonhosted.org/packages/be/60/da377e1bed002716fb2d5d1d1cab720f298cb33ecff7bf7adea72788e4e4/cryptography-2.8.tar.gz#sha256=3cda1f0ed8747339bbdf71b9f38ca74c7b592f24f65cdb3ab3765e4b02871651"
      sha256 "3cda1f0ed8747339bbdf71b9f38ca74c7b592f24f65cdb3ab3765e4b02871651"
    end
  end

  resource "jeepney" do
    on_linux do
      url "https://files.pythonhosted.org/packages/3a/b6/28c665d48e48b5b7e6a26853d6b4595c4031de7798a6c4985b14492ebd14/jeepney-0.4.1.tar.gz#sha256=13806f91a96e9b2623fd2a81b950d763ee471454aafd9eb6d75dbe7afce428fb"
      sha256 "13806f91a96e9b2623fd2a81b950d763ee471454aafd9eb6d75dbe7afce428fb"
    end
  end

  resource "secretstorage" do
    on_linux do
      url "https://files.pythonhosted.org/packages/a6/89/df343dbc2957a317127e7ff2983230dc5336273be34f2e1911519d85aeb5/SecretStorage-3.1.1.tar.gz#sha256=20c797ae48a4419f66f8d28fc221623f11fc45b6828f96bdb1ad9990acb59f92"
      sha256 "20c797ae48a4419f66f8d28fc221623f11fc45b6828f96bdb1ad9990acb59f92"
    end
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink "#{libexec}/bin/vsts" => "vsts"
  end

  test do
    system "#{bin}/vsts", "configure", "--help"
    output = shell_output("#{bin}/vsts logout 2>&1", 1)
    assert_equal "ERROR: The credential was not found", output.chomp
    output = shell_output("#{bin}/vsts work 2>&1", 2)
    assert_match "vsts work: error: the following arguments are required", output
  end
end
