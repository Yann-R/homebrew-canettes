class Teyjus < Formula
  desc "Efficient implementation of the programming language Lambda Prolog"
  homepage "http://teyjus.cs.umn.edu/"
  url "https://github.com/teyjus/teyjus/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "a8fafe8ab7cd857a3f46ab8e4a7f76f9f3fac2169fdb72f95b84d1d0bcdf66f9"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "dune" => :build
  depends_on "ocaml" => :build
  uses_from_macos "bison"
  uses_from_macos "flex"

  def install
    system "make", "all"
    # bin.install Dir["_build/install/default/bin/*"] # Does not work since it's a set of links
    # Then redo the links proposed in bin/ after build
    bin.install "_build/default/source/front/compilerfront.exe" => "tjcc"
    bin.install "_build/default/source/front/dependfront.exe" => "tjdepend"
    bin.install "_build/default/source/front/disassemblerfront.exe" => "tjdis"
    bin.install "_build/default/source/front/linkerfront.exe" => "tjlink"
    bin.install "_build/default/source/front/parsefront.exe" => "tjparse"
    bin.install "_build/default/source/front/simulatorfront.exe" => "tjsim"
  end

  test do
    system bin/"tjcc", "-v"
  end
end
