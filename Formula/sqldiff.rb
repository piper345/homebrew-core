class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://sqlite.org/2019/sqlite-src-3270200.zip"
  version "3.27.2"
  sha256 "15bd4286f2310f5fae085a1e03d9e6a5a0bb7373dcf8d4020868792e840fdf0a"

  bottle do
    cellar :any_skip_relocation
    sha256 "823599205a00dfa3f3afb0d280b8ccf4426e5a18253a09ddb994826319cbee2c" => :mojave
    sha256 "909b22329df785cd71ca7763f0f0047123c68f5d415fe01fdf4f88ea5099a04d" => :high_sierra
    sha256 "4b9ba18d7cdd507b7061cc814777def029b74d32c82dbbc6a1b2579e7ae3e8c1" => :sierra
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "sqldiff"
    bin.install "sqldiff"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged",
                 shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end
