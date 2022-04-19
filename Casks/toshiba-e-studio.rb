cask "toshiba-e-studio" do
  version "7.113.0.4"
  sha256 "256cfedba3fc6500789b1ebcd2a9a4a9cc441557967ea442b134cbca8339e6a4"

  url "https://www.toshibatec.eu/publicsite-service/resource/download/pseu/en/82d76edc-94ac-4be3-bff8-5df869227837/a9d700ac68ca348fcd83adea3b3b2bac/TOSHIBA%20e-STUDIO%20MacPPD(10.7.x-11.x)%20v#{version}.zip"
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
  container nested: "MacPPD/OSX10_7-/2-sided_default/TOSHIBA_ColorMFP.dmg.gz"

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
