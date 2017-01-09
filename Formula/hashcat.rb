class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-3.30.tar.gz"
  sha256 "3acd1d783f13183c57383069403de0554534ac2b06a30e7e078544e524f940d2"

  bottle do
    sha256 "7b3326c6130d3a9efece4fea418653e3a1519ace066fe808a4ee172036cb9b92" => :sierra
    sha256 "8b949ce43ea720d7556ab6bea03193c9b7d680e5139fe813192330d2b9b6138a" => :el_capitan
    sha256 "779e7022d29291278cff532258596b74586a134d64819869854d3f5cb333ee50" => :yosemite
  end

  depends_on "gnu-sed" => :build

  # Upstream could not fix OpenCL issue on Mavericks.
  # https://github.com/hashcat/hashcat/issues/366
  # https://github.com/Homebrew/homebrew-core/pull/4395
  depends_on :macos => :yosemite

  def install
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    #
    # General test settings
    #

    binary    = "./hashcat"
    pass      = "hash234"
    hash_type = "500" # -m 500 = md5crypt, MD5(Unix), FreeBSD MD5, Cisco-IOS MD5

    dict_file = "example.dict"
    hash_file = "example#{hash_type}.hash"

    additional_args = " --force" +         # shouldn't be needed with a correct OpenCL installation
                      " --quiet" +         # we only need the hash:pass pair in the output
                      " --potfile-disable" # we do not need to check or write the hashcat.potfile

    #
    # Copy some files to the test folder
    #

    # copy all files from share to the test folder
    cp_r pkgshare.children, testpath

    # copy the example hash and the dictionary file to the test folder
    cp "#{doc}/#{hash_file}", testpath
    cp "#{doc}/#{dict_file}", testpath

    # copy the hashcat binary to the test folder
    cp "#{bin}/#{binary}", testpath

    #
    # Test 1 (dictionary attack, -a 0):
    #

    hash = File.open(hash_file, "rb").read.strip

    attack_mode = "0"

    cmd = binary + " -m " + hash_type + " -a " + attack_mode + additional_args + " " + hash_file + " " + dict_file

    # suppress STDERR output
    cmd += " 2>/dev/null"

    assert_equal "#{hash}:#{pass}", shell_output(cmd).strip

    #
    # Test 2 (combinator attack, -a 1):
    #

    attack_mode = "1"

    dict1 = "dict1.txt"
    dict2 = "dict2.txt"

    File.write(dict1, pass[0..3])
    File.write(dict2, pass[4..-1])

    cmd = binary + " -m " + hash_type + " -a " + attack_mode + additional_args + " " + hash_file + " " + dict1 + " " + dict2

    # suppress STDERR output
    cmd += " 2>/dev/null"

    assert_equal "#{hash}:#{pass}", shell_output(cmd).strip

    #
    # Test 3 (mask attack, -a 3):
    #

    attack_mode = "3"

    mask = "?l?l?l" + pass[3..-1]

    cmd = binary + " -m " + hash_type + " -a " + attack_mode + additional_args + " " + hash_file + " " + mask

    # suppress STDERR output
    cmd += " 2>/dev/null"

    assert_equal "#{hash}:#{pass}", shell_output(cmd).strip

    #
    # Test 4 (hybrid attack, dict + mask, -a 6):
    #

    attack_mode = "6"

    mask = "?d?d?d"

    cmd = binary + " -m " + hash_type + " -a " + attack_mode + additional_args + " " + hash_file + " " + dict1 + " " + mask

    # suppress STDERR output
    cmd += " 2>/dev/null"

    assert_equal "#{hash}:#{pass}", shell_output(cmd).strip

    #
    # Test 5 (hybrid attack, mask + dict, -a 7):
    #

    attack_mode = "7"

    mask = "?l?l" + pass[2..3]

    cmd = binary + " -m " + hash_type + " -a " + attack_mode + additional_args + " " + hash_file + " " + mask + " " + dict2

    # suppress STDERR output
    cmd += " 2>/dev/null"

    assert_equal "#{hash}:#{pass}", shell_output(cmd).strip
  end
end
