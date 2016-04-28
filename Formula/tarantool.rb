class Tarantool < Formula
  desc "In-memory database and Lua application server."
  homepage "http://tarantool.org"
  url "http://tarantool.org/dist/1.6/tarantool-1.6.8.653.tar.gz"
  version "1.6.8-653"
  sha256 "1c7f210dfadb8660db6ddc4bb680cd167f37e93d3747d57989850eef7f17933e"
  head "https://github.com/tarantool/tarantool.git", :shallow => false, :branch => "1.7"

  bottle do
    sha256 "c0b9b071132bd59018e0e56d15e4fae5010ef57f7fe46ceeaced26ac98145527" => :el_capitan
    sha256 "a92ea313a32ca124f6b06cf5c572874df752c7631ddec50f108370f2c6626174" => :yosemite
    sha256 "036d44fd4111ef3a3f2c85e8ff3227188fcb5d90828449e57fe3887b595c26a8" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "readline"

  def install
    args = std_cmake_args
    args << "-DCMAKE_INSTALL_MANDIR=#{doc}"
    args << "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}"
    args << "-DCMAKE_INSTALL_LOCALSTATEDIR=#{var}"
    args << "-DENABLE_DIST=ON"
    args << "-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  def post_install
    local_user = ENV["USER"]
    inreplace etc/"default/tarantool", /(username\s*=).*/, "\\1 '#{local_user}'"

    (var/"lib/tarantool").mkpath
    (var/"log/tarantool").mkpath
    (var/"run/tarantool").mkpath
  end

  test do
    (testpath/"test.lua").write <<-EOS.undent
        box.cfg{}
        local s = box.schema.create_space("test")
        s:create_index("primary")
        local tup = {1, 2, 3, 4}
        s:insert(tup)
        local ret = s:get(tup[1])
        if (ret[3] ~= tup[3]) then
          os.exit(-1)
        end
        os.exit(0)
    EOS
    system bin/"tarantool", "#{testpath}/test.lua"
  end
end
