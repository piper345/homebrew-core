class GstPython < Formula
  desc "Python overrides for gobject-introspection-based pygst bindings"
  homepage "https://gstreamer.freedesktop.org/modules/gst-python.html"
  url "https://gstreamer.freedesktop.org/src/gst-python/gst-python-1.12.4.tar.xz"
  sha256 "20ce6af6615c9a440c1928c31259a78226516d06bf1a65f888c6d109826fa3ea"

  bottle do
    rebuild 1
    sha256 "7d18eefe40d417f7fea402cd09defc78c5b78829b7672519839b87d2505ed068" => :high_sierra
    sha256 "42f98521a665e5cc8660bc50510292c374a28243f1c906875667e53730afba31" => :sierra
    sha256 "987ce3b8f75f04c22dfb065032e4f9244b5154a06b19f07d29fa307b82622c84" => :el_capitan
  end

  option "without-python", "Build without python 2 support"

  depends_on "python3" => :optional
  depends_on "gst-plugins-base"

  depends_on "pygobject3" if build.with? "python"
  depends_on "pygobject3" => "with-python3" if build.with? "python3"

  link_overwrite "lib/python2.7/site-packages/gi/overrides"

  def install
    if build.with?("python") && build.with?("python3")
      # Upstream does not support having both Python2 and Python3 versions
      # of the plugin installed because apparently you can load only one
      # per process, so GStreamer does not know which to load.
      odie "Options --with-python and --with-python3 are mutually exclusive."
    end

    Language::Python.each_python(build) do |python, version|
      # pygi-overrides-dir switch ensures files don't break out of sandbox.
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}",
                            "--with-pygi-overrides-dir=#{lib}/python#{version}/site-packages/gi/overrides",
                            "PYTHON=#{python}"
      system "make", "install"
    end
  end

  test do
    system "#{Formula["gstreamer"].opt_bin}/gst-inspect-1.0", "python"
    Language::Python.each_python(build) do |python, _version|
      # Without gst-python raises "TypeError: object() takes no parameters"
      system python, "-c", <<~EOS
        import gi
        gi.require_version('Gst', '1.0')
        from gi.repository import Gst
        print (Gst.Fraction(num=3, denom=5))
        EOS
    end
  end
end
