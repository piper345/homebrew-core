class AzureStorageCpp < Formula
  desc "Microsoft Azure Storage Client Library for C++"
  homepage "https://azure.github.io/azure-storage-cpp"
  url "https://github.com/Azure/azure-storage-cpp/archive/v6.1.0.tar.gz"
  sha256 "a0b6107372125f756783bf6e5d57d24e2c8330a4941f4c72e8ddcf13c31618ed"

  bottle do
    cellar :any
    sha256 "67d8e17e425da6eca509d52b5ebd7977e0481c9831af05dfa7b9d6872d1679eb" => :mojave
    sha256 "eb91ca1c57bf23e33f80e1f90bde5254dfd21ed134b9e2f4c8bf71edcd5d4a5d" => :high_sierra
    sha256 "6c0fc630ba5250923846dfcd2b91672962297f823866d21a047c80f771a81671" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cpprestsdk"
  depends_on "gettext"
  depends_on "openssl"

  # patch submitted upstream at https://github.com/Azure/azure-storage-cpp/pull/261
  patch :DATA

  def install
    system "cmake", "Microsoft.WindowsAzure.Storage",
                    "-DBUILD_SAMPLES=OFF",
                    "-DBUILD_TESTS=OFF",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <was/common.h>
      #include <was/storage_account.h>
      using namespace azure;
      int main() {
        utility::string_t storage_connection_string(_XPLATSTR("DefaultEndpointsProtocol=https;AccountName=myaccountname;AccountKey=myaccountkey"));
        try {
          azure::storage::cloud_storage_account storage_account = azure::storage::cloud_storage_account::parse(storage_connection_string);
          return 0;
        }
        catch(...){ return 1; }
      }
    EOS
    flags = ["-stdlib=libc++", "-std=c++11", "-I#{include}",
             "-I#{Formula["boost"].include}",
             "-I#{Formula["openssl"].include}",
             "-I#{Formula["cpprestsdk"].include}",
             "-L#{Formula["boost"].lib}",
             "-L#{Formula["cpprestsdk"].lib}",
             "-L#{Formula["openssl"].lib}",
             "-L#{lib}",
             "-lcpprest", "-lboost_system-mt", "-lssl", "-lcrypto", "-lazurestorage"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test_azurestoragecpp", "test.cpp", *flags
    system "./test_azurestoragecpp"
  end
end

__END__
diff --git a/Microsoft.WindowsAzure.Storage/cmake/Modules/FindUUID.cmake b/Microsoft.WindowsAzure.Storage/cmake/Modules/FindUUID.cmake
index 9171f8c..a427288 100644
--- a/Microsoft.WindowsAzure.Storage/cmake/Modules/FindUUID.cmake
+++ b/Microsoft.WindowsAzure.Storage/cmake/Modules/FindUUID.cmake
@@ -63,6 +63,12 @@ else (UUID_LIBRARIES AND UUID_INCLUDE_DIRS)
       /usr/freeware/lib64
   )

+  if (APPLE)
+    if (NOT UUID_LIBRARY)
+      set(UUID_LIBRARY  "")
+    endif (NOT UUID_LIBRARY)
+  endif (APPLE)
+
   find_library(UUID_LIBRARY_DEBUG
     NAMES
       uuidd
@@ -88,9 +94,9 @@ else (UUID_LIBRARIES AND UUID_INCLUDE_DIRS)
   set(UUID_INCLUDE_DIRS ${UUID_INCLUDE_DIR})
   set(UUID_LIBRARIES ${UUID_LIBRARY})

-  if (UUID_INCLUDE_DIRS AND UUID_LIBRARIES)
+  if (UUID_INCLUDE_DIRS AND (APPLE OR UUID_LIBRARIES))
      set(UUID_FOUND TRUE)
-  endif (UUID_INCLUDE_DIRS AND UUID_LIBRARIES)
+  endif (UUID_INCLUDE_DIRS AND (APPLE OR UUID_LIBRARIES))

   if (UUID_FOUND)
     if (NOT UUID_FIND_QUIETLY)

