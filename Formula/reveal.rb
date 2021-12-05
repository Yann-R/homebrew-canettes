class Reveal < Formula
  desc "Script to reveal files and folders in the Finder from the Terminal application"
  homepage "http://yost.com/computers/MacStuff/reveal/"
  url "http://yost.com/computers/MacStuff/reveal/reveal"
  version "1.3"
  sha256 "419a88302ef987bfefb3818ed3509e844571b47b5100557b7550682444f0ce74"

  livecheck do
    # url :homepage # For looking into homepage to find among published versions
    # regex(/\d{4,4}-\d{2,2}-\d{2,2} (\d+(?:\.\d+))/i)
    # e.g. 2002-12-06 1.0
    url :stable # For looking into script to get documented version
    # e.g. Version 1.0
    regex(/Version (\d+(?:\.\d+))/i)
    strategy :page_match
  end

  uses_from_macos "zsh"

  def install
    bin.install "reveal"
  end
end
