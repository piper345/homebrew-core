class UrdfdomHeaders < Formula
  desc "Headers for URDF parsers "
  homepage "https://wiki.ros.org/urdfdom_headers"
  url "https://github.com/ros/urdfdom_headers/archive/1.0.0.tar.gz"
  sha256 "f341e9956d53dc7e713c577eb9a8a7ee4139c8b6f529ce0a501270a851673001"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <urdf_model/pose.h>
      int main() {
        double quat[4];
        urdf::Rotation rot;
        rot.getQuaternion(quat[0], quat[1], quat[2], quat[3]);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-lc++", "-std=c++11", "-o", "test"
    system "./test"
  end
end
