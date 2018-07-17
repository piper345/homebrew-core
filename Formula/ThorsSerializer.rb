class Thorsserializer < Formula
  desc "Declarative Serialization Library (Json/Yaml) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git", :tag => "1.5.7"

  ENV["COV"] = "gcov"

  depends_on "libyaml"

  def install
    system "./configure", "--disable-binary", "--disable-vera", "--with-thor-build-on-travis", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "ThorSerialize/JsonThor.h"
      #include "ThorSerialize/SerUtil.h"
      #include <sstream>
      #include <iostream>
      #include <string>

      struct Block
      {
          std::string             key;
          int                     code;
      };
      ThorsAnvil_MakeTrait(Block, key, code);

      int main()
      {
          using ThorsAnvil::Serialize::jsonImport;
          using ThorsAnvil::Serialize::jsonExport;

          std::stringstream   inputData(R"({"key":"XYZ","code":37373})");

          Block    object;
          inputData >> jsonImport(object);

          if (object.key != "XYZ" || object.code != 37373) {
              std::cerr << "Fail\n";
              return 1;
          }
          std::cerr << "OK\n";
          return 0;
      }
    EOS
    system ENV.cc, "-std=c++14", "test.cpp", "-o", "test",
                   "-I#{include}",
                   "-L#{lib}",
                   "-lThorSerialize17"
    system "./test"
  end
end
