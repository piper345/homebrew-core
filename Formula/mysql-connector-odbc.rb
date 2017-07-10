class MysqlConnectorOdbc < Formula
  desc "Official MySQL ODBC driver"
  homepage "https://dev.mysql.com/downloads/connector/odbc/"
  url "https://dev.mysql.com/get/Downloads/Connector-ODBC/5.3/mysql-connector-odbc-5.3.8-src.tar.gz"
  sha256 "eca40e1ad359cd1d7e23b6692e60179c8e3daa66337e7a0232de4162664d9885"

  bottle do
    cellar :any
    sha256 "3f9ac396e784b46aebad81c6d792af1fb62536b0c0739fb4063ce1327677c6e8" => :sierra
    sha256 "4b4bc3eb7ea09acb95ba35d7a0ec0bdd42fc8bf5ab2cfc156f1edd137aadcff8" => :el_capitan
    sha256 "e39e2d78448bfbd90cac62b61cf669ac4d5440e6bf61638ff05a0804a5225ea9" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "mysql"
  depends_on "unixodbc"
  # implicit conflicts_with libiodbc, because unixodbc conflicts with libiodbc

  def install
    args = std_cmake_args
    args << "-DWITH_UNIXODBC=1"
    args << "-DMYSQL_DIR=#{Formula["mysql"].opt_prefix}"
    # NOTE : Some of the connector source code relies on functions that are
    #        implemented in the static libmysqlclient.
    #        Include the static library in the link as well:
    args << "-DMYSQL_EXTRA_LIBRARIES=#{Formula["mysql"].opt_lib}/libmysqlclient.a"

    system "cmake", ".", *args
    # There are parallel build issues for the tests, and there is no easy way
    # to disable to tests. Have to use a workaround...
    # Use separate invocations of make to build in the right order:
    system "make", "myodbc5a", "myodbc5w"
    system "make", "install"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].bin}/dltest #{lib}/libmyodbc5w.so")
    assert_equal "SUCCESS: Loaded #{lib}/libmyodbc5w.so\n", output
  end
end
