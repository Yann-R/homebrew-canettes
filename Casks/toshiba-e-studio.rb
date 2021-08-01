ask "toshiba-e-studio" do
  version "7.111"
  sha256 "75ae436dad384e21ae14c540457f3b202229b958ce53475c68b92988da9b8515"

  url "https://toshibatec.eu/publicsite-service/resource/download/pseu/en/fea19da2-6b22-41d4-901c-76a352873e2a/8abbae3793dca9cf3b659837ab8958d9/TOSHIBA_e-STUDIO_MacPPD_10.7-__v7.111.zip"
  name "Toshiba e-STUDIO MacPPD"
  desc "Driver for Multi-Function Printer Toshiba e-STUDIO Series on macOS"
  homepage "https://www.toshibatec.eu/support/drivers/SearchDriver?searchString=e-studio2505"

  livecheck do
    url :homepage
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
  
  uninstall pkgutil: "com.toshiba.pde.x7.colormfp"

  uninstall_postflight do
    uninstall pkgutil: "com.toshiba.pde.x7.monomfp"
  end
end
