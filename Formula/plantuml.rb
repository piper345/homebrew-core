class Plantuml < Formula
  desc "Draw UML diagrams"
  homepage "https://plantuml.com/"
  url "https://downloads.sourceforge.net/project/plantuml/1.2022.4/plantuml.1.2022.4.jar"
  sha256 "c04c3dbf03aa434573868c080dc9e00184088380fc5acaa5605366c2d7dc0691"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    regex(%r{url=.*?/plantuml[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71606d1619f38fe9a1006cf1bc996c0a85a01b32a8d6da4ce68b6d227e4e1298"
  end

  depends_on "graphviz"
  depends_on "openjdk"

  def install
    jar = "plantuml.jar"
    libexec.install "plantuml.#{version}.jar" => jar
    (bin/"plantuml").write <<~EOS
      #!/bin/bash
      if [[ "$*" != *"-gui"* ]]; then
        VMARGS="-Djava.awt.headless=true"
      fi
      GRAPHVIZ_DOT="#{Formula["graphviz"].opt_bin}/dot" exec "#{Formula["openjdk"].opt_bin}/java" $VMARGS -jar #{libexec}/#{jar} "$@"
    EOS
    chmod 0755, bin/"plantuml"
  end

  test do
    system bin/"plantuml", "-testdot"
  end
end
