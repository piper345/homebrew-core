class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.9.4/php-cs-fixer.phar"
  sha256 "2a82db2a9eb9700d75cc408ab1535d31b36f5293097298b6c13bb19101fe4d70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "516eadea8ae01dfe3243fe5981e56bf588a775ea72bfaa9348a37d76d938cf45"
  end

  depends_on "php"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~EOS
      #!#{Formula["php"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    EOS
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php $this->foo(   'homebrew rox'   );
    EOS
    (testpath/"correct_test.php").write <<~EOS
      <?php

      $this->foo('homebrew rox');
    EOS

    system "#{bin}/php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
