cask "toshiba-e-studio" do
  version "7.115"
  sha256 "3af5a216e6fad1d19c86718edd4c70272e49d0b7b42121329732e427626173da"

  url "https://www.toshibatec.eu/publicsite-service/resource/download/pseu/en/81c15239-1ebb-44fb-a9df-169ca32cc9db/3f21beedad329ade6e84ca67e84004fe/TOSHIBA_e-STUDIO_MacPPD(10.12.x-)_v#{version}.zip"
  name "Toshiba e-STUDIO MacPPD"
  desc "Drivers (Color & Mono) for Multi-Function Printer Toshiba e-STUDIO Series"
  homepage "https://www.toshibatec.eu/products/multifunctional-systems-and-printers/"

  livecheck do
    url "https://www.toshibatec.eu/products/multifunctional-systems-and-printers/e-studio400ac/"
    strategy :page_match
    regex(/TOSHIBA e-STUDIO MacPPD.*v(\d+(?:\.\d+)*)/i)
    # e.g. TOSHIBA e-STUDIO MacPPD(10.7-) v7.111
  end

  # Installs the 1st pkg for Color MFP (in double-sided mode)
  container nested: "MacPPD/OSX10_12-/2-sided_default/TOSHIBA_ColorMFP.dmg.gz"

  pkg "TOSHIBA ColorMFP.pkg"

  postflight do
    # Installs the 2nd pkg for Monochrome MFP (in double-sided mode)
    container nested: "MacPPD/OSX10_7-/2-sided_default/TOSHIBA_MonoMFP.dmg.gz"
    pkg "TOSHIBA MonoMFP.pkg"
  end

  uninstall_postflight do
    uninstall pkgutil: "com.toshiba.pde.x7.monomfp"
  end

  uninstall pkgutil: "com.toshiba.pde.x7.colormfp"
end
