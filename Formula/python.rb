class Python < Formula
  desc "Interpreted, interactive, object-oriented programming language"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tar.xz"
  sha256 "159b932bf56aeaa76fd66e7420522d8c8853d486b8567c459b84fe2ed13bcaba"
  revision 3
  head "https://github.com/python/cpython.git"

  bottle do
    sha256 "4e05897c538937126494a2e611e109e95e761a333dc1911e4ea77171f7cf2e4d" => :high_sierra
    sha256 "0ac689593fa82905b69aacafc7bde61f88b54bdc36cacd4cfc2f315732eb60c4" => :sierra
    sha256 "bd8cbaf020a476bfd53c75538244520b7713554feafeac3f0d454f8fb92c1293" => :el_capitan
  end

  devel do
    url "https://www.python.org/ftp/python/3.7.0/Python-3.7.0b1.tar.xz"
    sha256 "2bee6320443ab475ecc9ee8b36e96230787eb12cdb336e3079dceef23039b970"
  end

  option "with-tcl-tk", "Use Homebrew's Tk instead of macOS Tk (has optional Cocoa and threads support)"
  option "with-quicktest", "Run `make quicktest` after the build"
  option "with-sphinx-doc", "Build HTML documentation"

  deprecated_option "quicktest" => "with-quicktest"
  deprecated_option "with-brewed-tk" => "with-tcl-tk"

  depends_on "pkg-config" => :build
  depends_on "readline" => :recommended
  depends_on "sqlite" => :recommended
  depends_on "gdbm" => :recommended
  depends_on "openssl"
  depends_on "xz" => :recommended # for the lzma module added in 3.3
  depends_on "tcl-tk" => :optional
  depends_on "sphinx-doc" => [:build, :optional]

  skip_clean "bin/pip3", "bin/pip-3.4", "bin/pip-3.5", "bin/pip-3.6"
  skip_clean "bin/easy_install3", "bin/easy_install-3.4", "bin/easy_install-3.5", "bin/easy_install-3.6"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6c/54/f7e9cea6897636a04e74c3954f0d8335cc38f7d01e27eec98026b049a300/setuptools-38.5.1.zip"
    sha256 "6425484c08e99a98a42209c25c3d325f749230b55284d66192784f941a7e6628"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/11/b6/abcb525026a4be042b486df43905d6893fb04f05aac21c32c638e939e447/pip-9.0.1.tar.gz"
    sha256 "09f243e1a7b461f654c26a725fa373211bb7ff17a9300058b205c61658ca940d"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/fa/b4/f9886517624a4dcb81a1d766f68034344b7565db69f13d52697222daeb72/wheel-0.30.0.tar.gz"
    sha256 "9515fe0a94e823fd90b08d22de45d7bde57c90edce705b22f5e1ecf7e1b653c8"
  end

  fails_with :clang do
    build 425
    cause "https://bugs.python.org/issue24844"
  end

  # Homebrew's tcl-tk is built in a standard unix fashion (due to link errors)
  # so we have to stop python from searching for frameworks and linking against
  # X11.
  patch :DATA if build.with? "tcl-tk"

  # setuptools remembers the build flags python is built with and uses them to
  # build packages later. Xcode-only systems need different flags.
  pour_bottle? do
    reason <<~EOS
      The bottle needs the Apple Command Line Tools to be installed.
        You can install them, if desired, with:
          xcode-select --install
    EOS
    satisfy { MacOS::CLT.installed? }
  end

  def install
    # Unset these so that installing pip and setuptools puts them where we want
    # and not into some other Python the user has installed.
    ENV["PYTHONHOME"] = nil
    ENV["PYTHONPATH"] = nil

    xy = (buildpath/"configure.ac").read.slice(/PYTHON_VERSION, (3\.\d)/, 1)
    lib_cellar = prefix/"Frameworks/Python.framework/Versions/#{xy}/lib/python#{xy}"

    args = %W[
      --prefix=#{prefix}
      --enable-ipv6
      --datarootdir=#{share}
      --datadir=#{share}
      --enable-framework=#{frameworks}
      --without-ensurepip
      --with-dtrace
    ]

    args << "--without-gcc" if ENV.compiler == :clang
    args << "--enable-loadable-sqlite-extensions" if build.with?("sqlite")

    cflags   = []
    ldflags  = []
    cppflags = []

    unless MacOS::CLT.installed?
      # Help Python's build system (setuptools/pip) to build things on Xcode-only systems
      # The setup.py looks at "-isysroot" to get the sysroot (and not at --sysroot)
      cflags   << "-isysroot #{MacOS.sdk_path}"
      ldflags  << "-isysroot #{MacOS.sdk_path}"
      cppflags << "-I#{MacOS.sdk_path}/usr/include" # find zlib
      # For the Xlib.h, Python needs this header dir with the system Tk
      if build.without? "tcl-tk"
        cflags << "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
      end
    end
    # Avoid linking to libgcc https://mail.python.org/pipermail/python-dev/2012-February/116205.html
    args << "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"

    # We want our readline! This is just to outsmart the detection code,
    # superenv makes cc always find includes/libs!
    inreplace "setup.py",
      "do_readline = self.compiler.find_library_file(lib_dirs, 'readline')",
      "do_readline = '#{Formula["readline"].opt_lib}/libhistory.dylib'"

    if build.stable?
      inreplace "setup.py", "/usr/local/ssl", Formula["openssl"].opt_prefix
    else
      args << "--with-openssl=#{Formula["openssl"].opt_prefix}"
    end

    if build.with? "sqlite"
      inreplace "setup.py" do |s|
        s.gsub! "sqlite_setup_debug = False", "sqlite_setup_debug = True"
        s.gsub! "for d_ in inc_dirs + sqlite_inc_paths:",
                "for d_ in ['#{Formula["sqlite"].opt_include}']:"
      end
    end

    # Allow python modules to use ctypes.find_library to find homebrew's stuff
    # even if homebrew is not a /usr/local/lib. Try this with:
    # `brew install enchant && pip install pyenchant`
    inreplace "./Lib/ctypes/macholib/dyld.py" do |f|
      f.gsub! "DEFAULT_LIBRARY_FALLBACK = [", "DEFAULT_LIBRARY_FALLBACK = [ '#{HOMEBREW_PREFIX}/lib',"
      f.gsub! "DEFAULT_FRAMEWORK_FALLBACK = [", "DEFAULT_FRAMEWORK_FALLBACK = [ '#{HOMEBREW_PREFIX}/Frameworks',"
    end

    if build.with? "tcl-tk"
      tcl_tk = Formula["tcl-tk"].opt_prefix
      cppflags << "-I#{tcl_tk}/include"
      ldflags  << "-L#{tcl_tk}/lib"
    end

    args << "CFLAGS=#{cflags.join(" ")}" unless cflags.empty?
    args << "LDFLAGS=#{ldflags.join(" ")}" unless ldflags.empty?
    args << "CPPFLAGS=#{cppflags.join(" ")}" unless cppflags.empty?

    system "./configure", *args

    system "make"
    if build.with?("quicktest")
      system "make", "quicktest", "TESTPYTHONOPTS=-s", "TESTOPTS=-j#{ENV.make_jobs} -w"
    end

    ENV.deparallelize do
      # Tell Python not to install into /Applications (default for framework builds)
      system "make", "install", "PYTHONAPPSDIR=#{prefix}"
      system "make", "frameworkinstallextras", "PYTHONAPPSDIR=#{pkgshare}"
    end

    # Prevent third-party packages from building against fragile Cellar paths
    inreplace Dir[lib_cellar/"**/_sysconfigdata_m_darwin_darwin.py",
                  lib_cellar/"config*/Makefile",
                  frameworks/"Python.framework/Versions/3*/lib/pkgconfig/python-3.?.pc"],
              prefix, opt_prefix

    # Help third-party packages find the Python framework
    inreplace Dir[lib_cellar/"config*/Makefile"],
              /^LINKFORSHARED=(.*)PYTHONFRAMEWORKDIR(.*)/,
              "LINKFORSHARED=\\1PYTHONFRAMEWORKINSTALLDIR\\2"

    # Fix for https://github.com/Homebrew/homebrew-core/issues/21212
    inreplace Dir[lib_cellar/"**/_sysconfigdata_m_darwin_darwin.py"],
              %r{('LINKFORSHARED': .*?)'(Python.framework/Versions/3.\d+/Python)'}m,
              "\\1'#{opt_prefix}/Frameworks/\\2'"

    # Symlink the pkgconfig files into HOMEBREW_PREFIX so they're accessible.
    (lib/"pkgconfig").install_symlink Dir["#{frameworks}/Python.framework/Versions/#{xy}/lib/pkgconfig/*"]

    # Remove the site-packages that Python created in its Cellar.
    (prefix/"Frameworks/Python.framework/Versions/#{xy}/lib/python#{xy}/site-packages").rmtree

    %w[setuptools pip wheel].each do |r|
      (libexec/r).install resource(r)
    end

    if build.with? "sphinx-doc"
      cd "Doc" do
        system "make", "html"
        doc.install Dir["build/html/*"]
      end
    end

    # Install unversioned symlinks.
    {
      "idle" => "idle3",
      "pydoc" => "pydoc3",
      "python" => "python3",
      "python-config" => "python3-config",
    }.each do |unversioned_name, versioned_name|
      bin.install_symlink (bin/versioned_name).realpath => unversioned_name
    end
    man1.install_symlink man1/"python#{xy}.1" => "python.1"
  end

  def post_install
    ENV.delete "PYTHONPATH"

    xy = (prefix/"Frameworks/Python.framework/Versions").children.first.basename.to_s
    site_packages = HOMEBREW_PREFIX/"lib/python#{xy}/site-packages"
    site_packages_cellar = prefix/"Frameworks/Python.framework/Versions/#{xy}/lib/python#{xy}/site-packages"

    # Fix up the site-packages so that user-installed Python software survives
    # minor updates, such as going from 3.3.2 to 3.3.3:

    # Create a site-packages in HOMEBREW_PREFIX/lib/python#{xy}/site-packages
    site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    site_packages_cellar.unlink if site_packages_cellar.exist?
    site_packages_cellar.parent.install_symlink site_packages

    # Write our sitecustomize.py
    rm_rf Dir["#{site_packages}/sitecustomize.py[co]"]
    (site_packages/"sitecustomize.py").atomic_write(sitecustomize)

    # Remove old setuptools installations that may still fly around and be
    # listed in the easy_install.pth. This can break setuptools build with
    # zipimport.ZipImportError: bad local file header
    # setuptools-0.9.8-py3.3.egg
    rm_rf Dir["#{site_packages}/setuptools*"]
    rm_rf Dir["#{site_packages}/distribute*"]
    rm_rf Dir["#{site_packages}/pip[-_.][0-9]*", "#{site_packages}/pip"]

    %w[setuptools pip wheel].each do |pkg|
      (libexec/pkg).cd do
        system bin/"python3", "-s", "setup.py", "--no-user-cfg", "install",
               "--force", "--verbose", "--install-scripts=#{bin}",
               "--install-lib=#{site_packages}",
               "--single-version-externally-managed",
               "--record=installed.txt"
      end
    end

    bin.install_symlink bin/"wheel" => "wheel3"

    # post_install happens after link
    %W[pip pip3 pip#{xy} easy_install easy_install-#{xy} wheel wheel3].each do |e|
      (HOMEBREW_PREFIX/"bin").install_symlink bin/e
    end

    # Help distutils find brewed stuff when building extensions
    include_dirs = [HOMEBREW_PREFIX/"include", Formula["openssl"].opt_include]
    library_dirs = [HOMEBREW_PREFIX/"lib", Formula["openssl"].opt_lib]

    if build.with? "sqlite"
      include_dirs << Formula["sqlite"].opt_include
      library_dirs << Formula["sqlite"].opt_lib
    end

    if build.with? "tcl-tk"
      include_dirs << Formula["tcl-tk"].opt_include
      library_dirs << Formula["tcl-tk"].opt_lib
    end

    cfg = prefix/"Frameworks/Python.framework/Versions/#{xy}/lib/python#{xy}/distutils/distutils.cfg"

    cfg.atomic_write <<~EOS
      [install]
      prefix=#{HOMEBREW_PREFIX}

      [build_ext]
      include_dirs=#{include_dirs.join ":"}
      library_dirs=#{library_dirs.join ":"}
    EOS
  end

  def sitecustomize
    xy = (prefix/"Frameworks/Python.framework/Versions").children.first.basename.to_s

    <<~EOS
      # This file is created by Homebrew and is executed on each python startup.
      # Don't print from here, or else python command line scripts may fail!
      # <https://docs.brew.sh/Homebrew-and-Python>
      import re
      import os
      import sys

      if sys.version_info[0] != 3:
          # This can only happen if the user has set the PYTHONPATH for 3.x and run Python 2.x or vice versa.
          # Every Python looks at the PYTHONPATH variable and we can't fix it here in sitecustomize.py,
          # because the PYTHONPATH is evaluated after the sitecustomize.py. Many modules (e.g. PyQt4) are
          # built only for a specific version of Python and will fail with cryptic error messages.
          # In the end this means: Don't set the PYTHONPATH permanently if you use different Python versions.
          exit('Your PYTHONPATH points to a site-packages dir for Python 3.x but you are running Python ' +
               str(sys.version_info[0]) + '.x!\\n     PYTHONPATH is currently: "' + str(os.environ['PYTHONPATH']) + '"\\n' +
               '     You should `unset PYTHONPATH` to fix this.')

      # Only do this for a brewed python:
      if os.path.realpath(sys.executable).startswith('#{rack}'):
          # Shuffle /Library site-packages to the end of sys.path
          library_site = '/Library/Python/#{xy}/site-packages'
          library_packages = [p for p in sys.path if p.startswith(library_site)]
          sys.path = [p for p in sys.path if not p.startswith(library_site)]
          # .pth files have already been processed so don't use addsitedir
          sys.path.extend(library_packages)

          # the Cellar site-packages is a symlink to the HOMEBREW_PREFIX
          # site_packages; prefer the shorter paths
          long_prefix = re.compile(r'#{rack}/[0-9\._abrc]+/Frameworks/Python\.framework/Versions/#{xy}/lib/python#{xy}/site-packages')
          sys.path = [long_prefix.sub('#{HOMEBREW_PREFIX/"lib/python#{xy}/site-packages"}', p) for p in sys.path]

          # Set the sys.executable to use the opt_prefix
          sys.executable = '#{opt_bin}/python#{xy}'
    EOS
  end

  def caveats
    if prefix.exist?
      xy = (prefix/"Frameworks/Python.framework/Versions").children.first.basename.to_s
    else
      xy = version.to_s.slice(/(3\.\d)/) || "3.6"
    end
    text = <<~EOS
      Pip, setuptools, and wheel have been installed. To update them
        pip3 install --upgrade pip setuptools wheel

      You can install Python packages with
        pip3 install <package>

      They will install into the site-package directory
        #{HOMEBREW_PREFIX/"lib/python#{xy}/site-packages"}

      See: https://docs.brew.sh/Homebrew-and-Python
    EOS

    # Tk warning only for 10.6
    tk_caveats = <<~EOS

      Apple's Tcl/Tk is not recommended for use with Python on Mac OS X 10.6.
      For more information see: https://www.python.org/download/mac/tcltk/
    EOS

    text += tk_caveats unless MacOS.version >= :lion
    text
  end

  test do
    # Check if sqlite is ok, because we build with --enable-loadable-sqlite-extensions
    # and it can occur that building sqlite silently fails if OSX's sqlite is used.
    system "#{bin}/python", "-c", "import sqlite3"
    # Check if some other modules import. Then the linked libs are working.
    system "#{bin}/python", "-c", "import tkinter; root = tkinter.Tk()"
    system "#{bin}/python", "-c", "import _gdbm"
    system bin/"pip", "list", "--format=columns"
  end
end

__END__
diff --git a/setup.py b/setup.py
index 2779658..902d0eb 100644
--- a/setup.py
+++ b/setup.py
@@ -1699,9 +1699,6 @@ class PyBuildExt(build_ext):
         # Rather than complicate the code below, detecting and building
         # AquaTk is a separate method. Only one Tkinter will be built on
         # Darwin - either AquaTk, if it is found, or X11 based Tk.
-        if (host_platform == 'darwin' and
-            self.detect_tkinter_darwin(inc_dirs, lib_dirs)):
-            return

         # Assume we haven't found any of the libraries or include files
         # The versions with dots are used on Unix, and the versions without
@@ -1747,22 +1744,6 @@ class PyBuildExt(build_ext):
             if dir not in include_dirs:
                 include_dirs.append(dir)

-        # Check for various platform-specific directories
-        if host_platform == 'sunos5':
-            include_dirs.append('/usr/openwin/include')
-            added_lib_dirs.append('/usr/openwin/lib')
-        elif os.path.exists('/usr/X11R6/include'):
-            include_dirs.append('/usr/X11R6/include')
-            added_lib_dirs.append('/usr/X11R6/lib64')
-            added_lib_dirs.append('/usr/X11R6/lib')
-        elif os.path.exists('/usr/X11R5/include'):
-            include_dirs.append('/usr/X11R5/include')
-            added_lib_dirs.append('/usr/X11R5/lib')
-        else:
-            # Assume default location for X11
-            include_dirs.append('/usr/X11/include')
-            added_lib_dirs.append('/usr/X11/lib')
-
         # If Cygwin, then verify that X is installed before proceeding
         if host_platform == 'cygwin':
             x11_inc = find_file('X11/Xlib.h', [], include_dirs)
@@ -1786,10 +1767,6 @@ class PyBuildExt(build_ext):
         if host_platform in ['aix3', 'aix4']:
             libs.append('ld')

-        # Finally, link with the X11 libraries (not appropriate on cygwin)
-        if host_platform != "cygwin":
-            libs.append('X11')
-
         ext = Extension('_tkinter', ['_tkinter.c', 'tkappinit.c'],
                         define_macros=[('WITH_APPINIT', 1)] + defs,
                         include_dirs = include_dirs,
