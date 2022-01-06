cask "pygmentize-tex" do
  version "1"
  sha256 :no_check

  url "https://github.com/gpoore/minted/releases/latest"
  name "Pygmentize TeX"
  desc "Access to pygments from LaTeX documents (e.g. with package minted)"
  homepage "https://github.com/gpoore/minted"

  # depends_on cask: "mactex"     # e.g. Contains minted, that requires pygmentize
  depends_on formula: "pygments"  # Provides pygmentize executable

  shimscript = "#{staged_path}/script.sh"

  installer script: {
    executable: shimscript,
    sudo:       true,
  }

  preflight do
    # Creates a script for sudo
    File.write shimscript, <<~EOS
      #!/bin/sh
      # Adds a link to pygmentize within the TeX binaries:
      ln -s #{HOMEBREW_PREFIX}/pygmentize /Library/TeX/texbin/pygmentize
    EOS
  end

  uninstall_preflight do
    # Creates a script for sudo
    File.write shimscript, <<~EOS
      #!/bin/sh
      # Removes the added link to pygmentize within the TeX binaries:
      rm /Library/TeX/texbin/pygmentize
    EOS
  end

  uninstall script: {
    executable: shimscript,
    sudo:       true,
  }

  caveats <<~EOS
    Don't forget to use option --shell-escape when invoking LaTeX from the command line,
    or Add this option in your GUI front-end settings:
    e.g. TexShop > Preferences > Engine > Latex: add the option at the end of field.fox
  EOS
end
