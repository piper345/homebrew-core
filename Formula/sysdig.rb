class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  license "Apache-2.0"

  stable do
    url "https://github.com/draios/sysdig/archive/0.30.0.tar.gz"
    sha256 "df0220e8ca7729e7d2b47a2187bf20ca89091059af50bfeb3f27e602101ad0e2"

    # Update to value of FALCOSECURITY_LIBS_VERSION found in
    # https://github.com/draios/sysdig/blob/#{version}/cmake/modules/falcosecurity-libs.cmake
    resource "falcosecurity-libs" do
      url "https://github.com/falcosecurity/libs/archive/4e218b3a072f2e0377804ed317e09de99445589f.tar.gz"
      sha256 "29c52303744d40847292f00d4ce7cd1e97f97a81aa5d38674949cf38118d4315"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "315364f0af6cd1d6e54f86a4eab6c8b4503ce9981e6d866f93f3bda63aacfd55"
    sha256                               arm64_big_sur:  "efb7f3d2ae23f61a8991c268e8f352dfdb4f2bddddb23f7e8903a09b7c6619f4"
    sha256                               monterey:       "f1954c1ab3dd7287b310170ec51389907e65f48b6b5d2d9038cd68161c029cbd"
    sha256                               big_sur:        "0098dd2527d0bbe8b3f3381e7403f28010cbb86f5eddb3951216666402024b66"
    sha256                               catalina:       "3fddb3ce68bdba1acb488363546bfc0e1f68fec1795c027c083eff5a1b5299f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e89f2fc153b56fa79ed3d86f7f53834dee1cfdbdb9530bdb046e8d7cf029df4b"
  end

  head do
    url "https://github.com/draios/sysdig.git", branch: "dev"

    resource "falcosecurity-libs" do
      url "https://github.com/falcosecurity/libs.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "openssl@1.1"
  depends_on "tbb"
  depends_on "yaml-cpp"

  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libb64" => :build
    depends_on "elfutils"
    depends_on "grpc"
    depends_on "jq"
    depends_on "protobuf"
  end

  fails_with gcc: "5" # C++17

  # More info on https://gist.github.com/juniorz/9986999
  resource "homebrew-sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    (buildpath/"falcosecurity-libs").install resource("falcosecurity-libs")

    # These flags are not needed for LuaJIT 2.1 (Ref: https://luajit.org/install.html).
    # On Apple ARM, the flags results in broken binaries and need to be removed.
    inreplace "CMakeLists.txt", "set(CMAKE_EXE_LINKER_FLAGS \"-pagezero_size 10000 -image_base 100000000\")", ""

    args = std_cmake_args + %W[
      -DSYSDIG_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
      -DCREATE_TEST_TARGETS=OFF
      -DBUILD_LIBSCAP_EXAMPLES=OFF
      -DDIR_ETC=#{etc}
      -DFALCOSECURITY_LIBS_SOURCE_DIR=#{buildpath}/falcosecurity-libs
    ]

    # `USE_BUNDLED_*=OFF` flags are implied by `USE_BUNDLED_DEPS=OFF`, but let's be explicit.
    %w[LUAJIT JSONCPP ZLIB TBB JQ NCURSES B64 OPENSSL CURL CARES PROTOBUF GRPC].each do |dep|
      args << "-DUSE_BUNDLED_#{dep}=OFF"
    end

    args << "-DBUILD_DRIVER=OFF" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"demos").install resource("homebrew-sample_file").files("sample.scap")
  end

  test do
    output = shell_output("#{bin}/sysdig -r #{pkgshare}/demos/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end
