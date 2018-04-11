class Theharvester < Formula
  desc "Gather materials from public sources (for pen testers)"
  homepage "http://www.edge-security.com/theharvester.php"
  url "https://github.com/laramies/theHarvester/archive/2.7.tar.gz"
  sha256 "dc0ff455ac5c41d53709cfc1de65dac7e96d2d9c33f9706789cca106d5a5ee76"
  head "https://github.com/laramies/theHarvester.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "189846a319f00910dc6e4b7312886bc9df9a6fc8eddca6378ed7d1aab200a8a2" => :high_sierra
    sha256 "189846a319f00910dc6e4b7312886bc9df9a6fc8eddca6378ed7d1aab200a8a2" => :sierra
    sha256 "189846a319f00910dc6e4b7312886bc9df9a6fc8eddca6378ed7d1aab200a8a2" => :el_capitan
  end

  depends_on "python@2"

  resource "requests" do
    url "https://files.pythonhosted.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
    sha256 "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    libexec.install Dir["*"]
    (libexec/"theHarvester.py").chmod 0755
    (bin/"theharvester").write_env_script("#{libexec}/theHarvester.py", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    output = shell_output("#{bin}/theharvester -d brew.sh -l 1 -b all 2>&1")
    assert_match "security@brew.sh", output
  end
end
