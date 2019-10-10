class BoostPython3 < Formula
  desc "C++ library for C++/Python3 interoperability"
  homepage "https://www.boost.org/"
  url "https://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.bz2"
  sha256 "d73a8da01e8bf8c7eda40b4c84915071a8c8a0df4a6734537ddde4a8580524ee"
  revision 1
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any
    sha256 "df8408fcf0b39d564ad7e7b926255becc52f00c87db0655c37000f50632ad231" => :catalina
    sha256 "030715604eb213ac9154c7e8e60f189d52f839fc87a580416c7e6088722d7e1a" => :mojave
    sha256 "ec1ebb266260e7f488caccb09c2ae87af5b7d2c1b137033bc7d365165d14eeef" => :high_sierra
    sha256 "66cfacedfd90dd4b88d5d3f990c3f81bf314417376380ed8d9b9d464e4f5a884" => :sierra
  end

  depends_on "numpy" => :build
  depends_on "boost"
  depends_on "python"

  def install
    # "layout" should be synchronized with boost
    args = %W[
      -d2
      -j#{ENV.make_jobs}
      --layout=tagged-1.66
      --user-config=user-config.jam
      install
      threading=multi,single
      link=shared,static
    ]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++14"
    if ENV.compiler == :clang
      args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
    end

    # disable python detection in bootstrap.sh; it guesses the wrong include
    # directory for Python 3 headers, so we configure python manually in
    # user-config.jam below.
    inreplace "bootstrap.sh", "using python", "#using python"

    pyver = Language::Python.major_minor_version "python3"
    py_prefix = Formula["python3"].opt_frameworks/"Python.framework/Versions/#{pyver}"

    # Force boost to compile with the desired compiler
    (buildpath/"user-config.jam").write <<~EOS
      using darwin : : #{ENV.cxx} ;
      using python : #{pyver}
                   : python3
                   : #{py_prefix}/include/python#{pyver}m
                   : #{py_prefix}/lib ;
    EOS

    system "./bootstrap.sh", "--prefix=#{prefix}", "--libdir=#{lib}",
                             "--with-libraries=python", "--with-python=python3",
                             "--with-python-root=#{py_prefix}"

    system "./b2", "--build-dir=build-python3",
                   "--stagedir=stage-python3",
                   "--libdir=install-python3/lib",
                   "--prefix=install-python3",
                   "python=#{pyver}",
                   *args

    lib.install Dir["install-python3/lib/*.*"]
    (lib/"cmake").install Dir["install-python3/lib/cmake/boost_python*"]
    (lib/"cmake").install Dir["install-python3/lib/cmake/boost_numpy*"]
    doc.install Dir["libs/python/doc/*"]
  end

  test do
    (testpath/"hello.cpp").write <<~EOS
      #include <boost/python.hpp>
      char const* greet() {
        return "Hello, world!";
      }
      BOOST_PYTHON_MODULE(hello)
      {
        boost::python::def("greet", greet);
      }
    EOS

    pyincludes = Utils.popen_read("python3-config --includes").chomp.split(" ")
    pylib = Utils.popen_read("python3-config --ldflags").chomp.split(" ")
    pyver = Language::Python.major_minor_version("python3").to_s.delete(".")

    system ENV.cxx, "-shared", "hello.cpp", "-L#{lib}", "-lboost_python#{pyver}", "-o",
           "hello.so", *pyincludes, *pylib

    output = <<~EOS
      import hello
      print(hello.greet())
    EOS
    assert_match "Hello, world!", pipe_output("python3", output, 0)
  end
end
