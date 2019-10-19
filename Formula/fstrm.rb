class Fstrm < Formula
  desc "Frame Streams implementation in C"
  homepage "https://github.com/farsightsec/fstrm"
  url "https://dl.farsightsecurity.com/dist/fstrm/fstrm-0.6.0.tar.gz"
  sha256 "a7049089eb0861ecaa21150a05613caa6dee4e8545b91191eff2269caa923910"

  bottle do
    cellar :any
    sha256 "86ae7db5981369a29e64cc87dcd6bfd953825c27fb123eb194ae8cb0f35e34a7" => :catalina
    sha256 "4359da87e49dfec39cc7eebed229674ae8c250803a67c9a89eaa0fa0e4d64a05" => :mojave
    sha256 "a38b141706f100183e174cff8ad5f671a15d1df2091d9d920b734bf677636075" => :high_sierra
    sha256 "8a099ab2ee34e901c0349119aa03f380c81f9b55f320e4fa48ed7015f5e4cc49" => :sierra
  end

  head do
    url "https://github.com/farsightsec/fstrm.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    job = fork do
      exec bin/"fstrm_capture", "-t", "protobuf:dnstap.Dnstap",
           "-u", "dnstap.sock", "-w", "capture.fstrm", "-dddd"
    end
    sleep 2
    Process.kill("TERM", job)
    system "#{bin}/fstrm_dump", "capture.fstrm"
  end
end
