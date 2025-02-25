cask "toshiba-mono-mfp" do
  version "7.117.3"
  sha256 "49049891f55eb61e177b4f97cd106339f395134e98c7d8e30ca388d6c3b1e054"

  url "https://downloads.toshibatec.eu/publicsite-service/resource/download/pseu/en/81c15239-1ebb-44fb-a9df-169ca32cc9db/7ca8208c71dc180b271cba91a1f0b7c4/TOSHIBA%20e-STUDIO%20MacPPD%20(10.12-latest)%20v#{version}.zip"
  name "Toshiba MonoMFP Drivers"
  desc "Drivers (Monochrome only) for Multi-Function Printer Toshiba e-STUDIO Series"
  homepage "https://www.toshibatec.eu/products/multifunctional-systems-and-printers/"

  livecheck do
    url "https://www.toshibatec.eu/products/multifunctional-systems-and-printers/e-studio400ac/"
    strategy :page_match
    regex(/TOSHIBA e-STUDIO MacPPD.*v(\d+(?:\.\d+)*)/i)
    # e.g. TOSHIBA e-STUDIO MacPPD(10.7-) v7.111
  end

  # Installs the 1st pkg for Monochrome MFP (in double-sided mode)
  container nested: "OSX10.12-latest/2-sided_default/TOSHIBA_MonoMFP.dmg.gz"

  pkg "TOSHIBA MonoMFP.pkg"

#  # No longer possible to handle a second container
#  postflight do
#    # Installs the 2nd pkg for Color MFP (in double-sided mode)
#    container nested: "OSX10.12-latest/2-sided_default/TOSHIBA_ColorMFP.dmg.gz"
#    pkg "TOSHIBA ColorMFP.pkg"
#  end
#
#  uninstall_postflight do
#    uninstall pkgutil: "com.toshiba.pde.x7.colormfp"
#  end

  uninstall pkgutil: "com.toshiba.pde.x7.monomfp"
end
