cask "macghostview" do
  version "6.1"
  sha256 "48d318a53d5876bf359da281ab3966258fe2eb43f3b1c7ccb90d88b63d9be2be"

  url "https://www.math.tamu.edu/~tkiffe/tex/programs/MacGhostView#{version.no_dots}.dmg.zip"
  name "MacGhostView"
  desc "Preview and conversion of Postscript files (with gv, xdvi-motif and xpdf)"
  homepage "https://www.math.tamu.edu/~tkiffe/macghostview.html"

  livecheck do
    url :homepage
    strategy :page_match
    regex(/MacGhostView (\d+(?:\.\d+)*)/i)
  end

  app "MacGhostView.app"
  app "gv_xdvi-motif_xpdf/Dropscript-gv.app"
  app "gv_xdvi-motif_xpdf/Dropscript-xdvim.app"
  app "gv_xdvi-motif_xpdf/Dropscript-xpdf.app"
  binary "gv_xdvi-motif_xpdf/gv"
  binary "gv_xdvi-motif_xpdf/xdvim for MacTeX 2020/xdvim"
  binary "gv_xdvi-motif_xpdf/xdvim for MacTeX 2020/xdvi-motif"
  binary "gv_xdvi-motif_xpdf/xpdf"
  binary "gv_xdvi-motif_xpdf/xpdf-bin"
  manpage "gv_xdvi-motif_xpdf/gv.1"
  manpage "gv_xdvi-motif_xpdf/xpdf.1"

  zap trash: [
    "~/Library/Saved Application State/com.tkiffe.MacGhostView.savedState",
    "~/Library/Preferences/com.tkiffe.MacGhostView.plist",
  ]

  caveats <<~EOS
    Three Drop scripts are supplied for launching the terminal commands (gv, xdvi and xpdf)
    as applications from the Finder.
  EOS
end
