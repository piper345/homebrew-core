class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "http://www.vervest.org/htp/"
  url "http://www.vervest.org/htp/archive/c/htpdate-1.2.2.tar.xz"
  sha256 "5f1f959877852abb3153fa407e8532161a7abe916aa635796ef93f8e4119f955"

  bottle do
    cellar :any_skip_relocation
    sha256 "d47cbbcdf265b8997e5d496851e5d30d010723950616c09cc1881830967a34cb" => :mojave
    sha256 "6c0525a59ea4312ade6e748dc4dab10798a918b1b978f0234637a95688f734f7" => :high_sierra
  end

  depends_on :macos => :high_sierra # needs <sys/timex.h>

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{bin}/htpdate", "-q", "-d", "-u", ENV["USER"], "example.org"
  end
end
