class Lilypond < Formula
  desc "Music engraving program"
  homepage "https://lilypond.org/"
  url "https://gitlab.com/lilypond/lilypond/-/releases/v2.24.1/downloads/lilypond-2.24.1-darwin-x86_64.tar.gz"
  version "2.24.1" # Necessary to avoid getting 86_64
  sha256 "4ea6c2013884677fde2d332864ec32ab6d04916f320a8d155c0d0b722275e2ea"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://lilypond.org/download.html"
    strategy :page_match
    regex(/macOS.*Lilypond (\d+(?:\.\d+)*)/i)
    # e.g. macOS x86_64: LilyPond 2.24.1
  end

  conflicts_with "homebrew/core/lilypond"

  def install
    # Moves all the distribution to #libexec
    libexec.install Dir["*"]
    # Creates symlinks in #bin to each #libexec/bin/
    Dir.mkdir bin
    Dir[libexec/"bin/*"].each do |name|
      f = File.basename(name)
      File.symlink libexec/"bin"/f, bin/f
    end
  end

  def caveats
    <<~EOS
      This Lilypond binary distribution assumes that a LaTeX distribution
      is also available on your system.
    EOS
  end

  test do
    system bin/"lilypond", "-v"
  end
end
