class Lilypond < Formula
  desc "Music engraving program"
  homepage "https://lilypond.org/"
  url "https://gitlab.com/lilypond/lilypond/-/releases/v2.24.4/downloads/lilypond-2.24.4-darwin-x86_64.tar.gz"
  version "2.24.4" # Necessary to avoid automatically getting 86_64 from filename instead
  sha256 "84a1e6173afd8f1eda1e39c610a498c41aa20975b4ffaad2e2b2810a52da90b8"
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
