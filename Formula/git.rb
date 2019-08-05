class Git < Formula
  desc "Distributed revision control system"
  homepage "https://git-scm.com"
  url "https://www.kernel.org/pub/software/scm/git/git-2.22.0.tar.xz"
  sha256 "159e4b599f8af4612e70b666600a3139541f8bacc18124daf2cbe8d1b934f29f"
  revision 1
  head "https://github.com/git/git.git", :shallow => false

  bottle do
    rebuild 1
    sha256 "9b4702b89babe742e32eec08b45468c5f3c6ee783931486817ad154638038933" => :mojave
    sha256 "9952d963642201d12e72d1a10efdebb3cd38704d303501f85776f68a387dd799" => :high_sierra
    sha256 "75fad25e2cf7727c87bd73c9886d0d0979762d409509a66053b6a81367199827" => :sierra
  end

  depends_on "gettext"
  depends_on "pcre2"

  if MacOS.version < :yosemite
    depends_on "openssl"
    depends_on "curl"
  end

  resource "html" do
    url "https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.22.0.tar.xz"
    sha256 "5c7e010abfca5ff2eabf3616bf7216609cfb93dbc12b7c4e13f4ae3e539dbc79"
  end

  resource "man" do
    url "https://www.kernel.org/pub/software/scm/git/git-manpages-2.22.0.tar.xz"
    sha256 "4e2cfda33d8e86812bfcdb907478d1144412ce472c32edd0219b3c0201c7ee3a"
  end

  resource "Net::SMTP::SSL" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Net-SMTP-SSL-1.04.tar.gz"
    sha256 "7b29c45add19d3d5084b751f7ba89a8e40479a446ce21cfd9cc741e558332a00"
  end

  def install
    # If these things are installed, tell Git build system not to use them
    ENV["NO_FINK"] = "1"
    ENV["NO_DARWIN_PORTS"] = "1"
    ENV["NO_R_TO_GCC_LINKER"] = "1" # pass arguments to LD correctly
    ENV["PYTHON_PATH"] = which("python")
    ENV["PERL_PATH"] = which("perl")
    ENV["USE_LIBPCRE2"] = "1"
    ENV["INSTALL_SYMLINKS"] = "1"
    ENV["LIBPCREDIR"] = Formula["pcre2"].opt_prefix
    ENV["V"] = "1" # build verbosely

    perl_version = Utils.popen_read("perl --version")[/v(\d+\.\d+)(?:\.\d+)?/, 1]

    ENV["PERLLIB_EXTRA"] = %W[
      #{MacOS.active_developer_dir}
      /Library/Developer/CommandLineTools
      /Applications/Xcode.app/Contents/Developer
    ].uniq.map do |p|
      "#{p}/Library/Perl/#{perl_version}/darwin-thread-multi-2level"
    end.join(":")

    unless quiet_system ENV["PERL_PATH"], "-e", "use ExtUtils::MakeMaker"
      ENV["NO_PERL_MAKEMAKER"] = "1"
    end

    args = %W[
      prefix=#{prefix}
      sysconfdir=#{etc}
      CC=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      LDFLAGS=#{ENV.ldflags}
    ]

    if MacOS.version < :yosemite
      openssl_prefix = Formula["openssl"].opt_prefix
      args += %W[NO_APPLE_COMMON_CRYPTO=1 OPENSSLDIR=#{openssl_prefix}]
    else
      args += %w[NO_OPENSSL=1 APPLE_COMMON_CRYPTO=1]
    end

    system "make", "install", *args

    git_core = libexec/"git-core"

    # Install the macOS keychain credential helper
    cd "contrib/credential/osxkeychain" do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      git_core.install "git-credential-osxkeychain"
      system "make", "clean"
    end

    # Generate diff-highlight perl script executable
    cd "contrib/diff-highlight" do
      system "make"
    end

    # Install the netrc credential helper
    cd "contrib/credential/netrc" do
      system "make", "test"
      git_core.install "git-credential-netrc"
    end

    # Install git-subtree
    cd "contrib/subtree" do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      git_core.install "git-subtree"
    end

    # install the completion script first because it is inside "contrib"
    bash_completion.install "contrib/completion/git-completion.bash"
    bash_completion.install "contrib/completion/git-prompt.sh"
    zsh_completion.install "contrib/completion/git-completion.zsh" => "_git"
    cp "#{bash_completion}/git-completion.bash", zsh_completion

    elisp.install Dir["contrib/emacs/*.el"]
    (share/"git-core").install "contrib"

    # We could build the manpages ourselves, but the build process depends
    # on many other packages, and is somewhat crazy, this way is easier.
    man.install resource("man")
    (share/"doc/git-doc").install resource("html")

    # Make html docs world-readable
    chmod 0644, Dir["#{share}/doc/git-doc/**/*.{html,txt}"]
    chmod 0755, Dir["#{share}/doc/git-doc/{RelNotes,howto,technical}"]

    # To avoid this feature hooking into the system OpenSSL, remove it
    if MacOS.version >= :yosemite
      rm "#{libexec}/git-core/git-imap-send"
    end

    # git-send-email needs Net::SMTP::SSL
    resource("Net::SMTP::SSL").stage do
      (share/"perl5").install "lib/Net"
    end

    # This is only created when building against system Perl, but it isn't
    # purged by Homebrew's post-install cleaner because that doesn't check
    # "Library" directories. It is however pointless to keep around as it
    # only contains the perllocal.pod installation file.
    rm_rf prefix/"Library/Perl"

    # Set the macOS keychain credential helper by default
    # (as Apple's CLT's git also does this).
    (buildpath/"gitconfig").write <<~EOS
      [credential]
      \thelper = osxkeychain
    EOS
    etc.install "gitconfig"

    # Create a git-gui Wish wrapper that prefers the homebrew version of tlc-tk
    # https://github.com/Homebrew/homebrew-core/issues/36390
    gitgui_dir = share/"git-gui/lib/Git Gui.app/Contents/MacOS/"
    mv gitgui_dir/"Wish", gitgui_dir/"Wish.broken"
    (gitgui_dir/"Wish").write <<~EOS
      #!/bin/sh
      # Wrapper to invoke homebrew tcl-tk "wish" command instead of the version shipped
      # with macOS. See https://github.com/Homebrew/homebrew-core/issues/36390
      homebrew_wish=$(brew --prefix)/opt/tcl-tk/bin/wish
      # Note: calling brew --prefix tcl-tk takes 600ms so we use brew --prefix
      # since it takes 50ms. This is noticeably faster when running "git gui".
      # homebrew_wish=$(brew --prefix tcl-tk)/bin/wish
      if [ -x "$homebrew_wish" ]; then
        echo "Using homebrew version of tcl-tk to run git-gui."
        # Note: using an absolute path to wish does not work for some reason
        # and we have to invoke the binary in the Contents/MacOS directory.
        ln -sfn "$homebrew_wish" "${0}.homebrew"
        exec "${0}.homebrew" "$@"
      else
        echo "WARNING: git-gui does not work correctly with the default macOS tcl-tk."
        echo "Please install the homebrew version of tcl-tk to use git-gui."
        exec "${0}.broken" "$@"
      fi
    EOS
    (gitgui_dir/"Wish").chmod 0755
  end

  test do
    system bin/"git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system bin/"git", "add", "haunted", "house"
    system bin/"git", "commit", "-a", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("#{bin}/git ls-files").strip

    # Check Net::SMTP::SSL was installed correctly.
    %w[foo bar].each { |f| touch testpath/f }
    system bin/"git", "add", "foo", "bar"
    system bin/"git", "commit", "-a", "-m", "Second Commit"
    assert_match "Authentication Required", shell_output(
      "#{bin}/git send-email --to=dev@null.com --smtp-server=smtp.gmail.com " \
      "--smtp-encryption=tls --confirm=never HEAD^ 2>&1", 255
    )
  end
end
