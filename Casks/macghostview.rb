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

  shimscript = "#{staged_path}/gv_xdvi-motif_xpdf/gv.sh"
  app "MacGhostView.app"
  app "gv_xdvi-motif_xpdf/Dropscript-gv.app", target: "MacGhostView/Dropscript-gv.app"
  app "gv_xdvi-motif_xpdf/Dropscript-xdvim.app", target: "MacGhostView/Dropscript-xdvim.app"
  app "gv_xdvi-motif_xpdf/Dropscript-xpdf.app", target: "MacGhostView/Dropscript-xpdf.app"
  binary shimscript, target: "gv"
  binary "gv_xdvi-motif_xpdf/gv", target: "gv-bin"
  binary "gv_xdvi-motif_xpdf/xdvim for MacTeX 2020/xdvim"
  binary "gv_xdvi-motif_xpdf/xdvim for MacTeX 2020/xdvi-motif"
  binary "gv_xdvi-motif_xpdf/xpdf"
  binary "gv_xdvi-motif_xpdf/xpdf-bin"
  manpage "gv_xdvi-motif_xpdf/gv.1"
  manpage "gv_xdvi-motif_xpdf/xpdf.1"

  preflight do
    # Creates one more wrapper script to ensure command-line gv uses the supplied Ghostscript
    IO.write shimscript, <<~EOS
      #!/bin/sh
      # Ensures use of a compatible Ghostscript (supplied in the .app)
      export PATH=#{appdir}/MacGhostView.app/Contents/Resources/bings:$PATH
      exec gv-bin "$@"
    EOS
  end
  
  postflight do
    # Ensures the path to the installed commands inside Drop scripts.
    %w[gv xdvim xpdf].each do |script|
      system_command "sed", 
                     args: [
                       "-i",
                       "",
                       "s%/usr/local/bin%#{HOMEBREW_PREFIX}/bin%g", 
                       "/Applications/MacGhostView/Dropscript-#{script}.app/Contents/Resources/script",
                     ]
    end
  end

  uninstall delete: "/Applications/MacGhostView"

  zap trash: [
    "~/Library/Saved Application State/com.tkiffe.MacGhostView.savedState",
    "~/Library/Preferences/com.tkiffe.MacGhostView.plist",
  ]

  caveats <<~EOS
    Three Drop scripts are supplied for launching the terminal commands (gv, xdvi and xpdf)
    as applications from the Finder.
  EOS
end
