cask "toshiba-e-studio" do
  version :latest
  sha256 :no_check

  url "https://www.toshibatec.eu/products/multifunctional-systems-and-printers/"
  name "Toshiba e-STUDIO MacPPD for Color & Mono"
  desc "Drivers (Color & Mono) for Multi-Function Printer Toshiba e-STUDIO Series"
  homepage "https://www.toshibatec.eu/products/multifunctional-systems-and-printers/"

  livecheck do
    skip "This cask only installs 2 depending casks"
  end

  depends_on cask: "toshiba-color-mfp" # Cask from official brew
  depends_on cask: "toshiba-mono-mfp"

  stage_only true

  uninstall_preflight do
    system_command "#{HOMEBREW_PREFIX}/bin/brew", args: ["uninstall", "--force", "toshiba-mono-mfp"]
    system_command "#{HOMEBREW_PREFIX}/bin/brew", args: ["uninstall", "--force", "toshiba-color-mfp"]
  end
end
