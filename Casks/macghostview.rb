cask "macghostview" do
  version "6.1"
  sha256 "b20270fffea09bb4ca6c19fa41a18e8ef0071402a4b8ba17927f3da3c6f848d3"

  url "https://www.math.tamu.edu/~tkiffe/tex/programs/MacGhostView#{version.no_dots}.dmg.zip"
  appcast "https://www.math.tamu.edu/~tkiffe/macghostview.html"
  name "MacGhostView"
  desc "Preview and conversion of Postscript files (with gv, xdvi-motif and xpdf)"
  homepage "https://www.math.tamu.edu/~tkiffe/macghostview.html"

  app "MacGhostView.app"
  app "gv_xdvi-motif_xpdf/Dropscript-gv.app"
  app "gv_xdvi-motif_xpdf/Dropscript-xdvim.app"
  app "gv_xdvi-motif_xpdf/Dropscript-xpdf.app"
  binary "gv_xdvi-motif_xpdf/gv"
  binary "gv_xdvi-motif_xpdf/xdvim"
  binary "gv_xdvi-motif_xpdf/xdvi-motif"
  binary "gv_xdvi-motif_xpdf/xpdf"
  binary "gv_xdvi-motif_xpdf/xpdf-bin"
  manpage "gv_xdvi-motif_xpdf/gv.1"
  manpage "gv_xdvi-motif_xpdf/xpdf.1"

  zap trash: [
    "~/Library/Saved Application State/com.tkiffe.MacGhostView.savedState",
    "~/Library/Preferences/com.tkiffe.MacGhostView.plist",
  ]

  caveats <<~EOS
    Three Drop scripts are supplied for launching the terminal commands (gv, xdvi and xdvi)
    as applications from the Finder.
  EOS
end
