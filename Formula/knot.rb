class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  revision 1

  stable do
    url "https://secure.nic.cz/files/knot-dns/knot-2.3.3.tar.xz"
    sha256 "a929bce3b957a81776b1db7b43b0e4473339bf16be8dbba5abb4b0593bf43c94"

    resource "fstrm" do
      url "https://github.com/farsightsec/fstrm/archive/v0.3.0.tar.gz"
      sha256 "531ef29ed2a15dfe4993448eb4e8463c5ed8eebf1472a5608c6ac0a6f62b3a12"
    end
  end

  bottle do
    sha256 "969c64f8596846e1f130912ffa2a143fa1d395ea627d74d488135d5cbf56dfa9" => :sierra
    sha256 "e1068c951462c69410949e08a7002b60257fcce3f1caa23b516ec4d6a1325bfc" => :el_capitan
    sha256 "57981e71eb5da0394796fdb6112eb8f783649fb3c536db2fb7af3db446aeb289" => :yosemite
  end

  head do
    url "https://gitlab.labs.nic.cz/labs/knot.git"

    resource "fstrm" do
      url "https://github.com/farsightsec/fstrm.git"
    end
  end

  # due to AT_REMOVEDIR
  depends_on :macos => :yosemite

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libidn"
  depends_on "nettle"
  depends_on "openssl"
  depends_on "userspace-rcu"
  depends_on "protobuf-c"
  depends_on "libevent"

  def install
    resource("fstrm").stage do
      system "autoreconf", "-fvi"
      system "./configure", "--prefix=#{libexec}/fstrm"
      system "make", "install"
    end

    ENV.append "CFLAGS", "-I#{libexec}/fstrm/include"
    ENV.append "LDFLAGS", "-L#{libexec}/fstrm/lib"
    ENV.append_path "PKG_CONFIG_PATH", "#{libexec}/fstrm/lib/pkgconfig"

    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-configdir=#{etc}",
                          "--with-storage=#{var}/knot",
                          "--with-rundir=#{var}/run/knot",
                          "--prefix=#{prefix}",
                          "--with-bash-completions=#{bash_completion}",
                          "--enable-dnstap"

    inreplace "samples/Makefile", "install-data-local:", "disable-install-data-local:"

    system "make"
    system "make", "check"
    system "make", "install"
    system "make", "install-singlehtml"

    (buildpath/"knot.conf").write(knot_conf)
    etc.install "knot.conf"
  end

  def post_install
    (var/"knot").mkpath
  end

  def knot_conf; <<-EOS.undent
    server:
      rundir: "#{var}/knot"
      listen: [ "0.0.0.0@53", "::@53" ]

    log:
      - target: "stderr"
        any: "error"

      - target: "syslog"
        server: "info"
        zone: "warning"
        any: "error"

    control:
      listen: "knot.sock"

    template:
      - id: "default"
        storage: "#{var}/knot"
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>EnableTransactions</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/knotd</string>
        <string>-c</string>
        <string>#{etc}/knot.conf</string>
      </array>
      <key>ServiceIPC</key>
      <false/>
    </dict>
    </plist>
    EOS
  end

  test do
    system bin/"kdig", "www.knot-dns.cz"
    system bin/"khost", "brew.sh"
    system sbin/"knotc", "-c", etc/"knot.conf", "conf-check"
  end
end
