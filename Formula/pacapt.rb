class Pacapt < Formula
  desc "Package manager in the style or Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v2.3.8.tar.gz"
  sha256 "6ac7d16cf225a4fc625da40776577b62b44c6b83fe3a2e5b33fe3db467c1dd7e"

  bottle do
    cellar :any_skip_relocation
    sha256 "b467fc10b95da7d063f8057a1ae7ef7e726c585396ab930b62f9189ad4c88cbe" => :el_capitan
    sha256 "a25829c85af35900e5f49bc26736c4ab6e49774c39bfd7bb6d4849db192d4370" => :yosemite
    sha256 "ea5c2cae36f7e3080835cf843e91c61ce5b47d47a7ada8a6ec7c577e9047b096" => :mavericks
  end

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}", "VERSION=#{version}"
  end

  test do
    system "#{bin}/pacapt", "-Ss", "wget"
  end
end
