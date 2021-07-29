class Teyjus < Formula
  desc "Efficient implementation of the programming language Lambda Prolog"
  homepage "http://teyjus.cs.umn.edu/"
  url "https://github.com/teyjus/teyjus/releases/download/v2.1/teyjus-osx-binaries.tar.gz"
  sha256 "22a1ecdfc0a2b13a4be7db88ad5dc3cee922a99ceceedf415385b4e4b212b0ce"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install Dir["*"]
  end

  test do
    system bin/"tjcc", "-v"
  end
end
