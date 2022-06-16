cask "dell-dock-wd19" do
  version "01.00.24,A07"
  sha256 "55ae7b65cc23f803c080a4962e23e2e225368319f1189396930481772ce7f132"

  url "https://dl.dell.com/FOLDER08239444M/1/DellDockFirmwarePackage_WD19_WD22_Series_01.00.24.exe"
  name "Dell Docking Station Firmware Update"
  desc "Dell Dock WD19 & WD22 Series Firmware Update Utility"
  homepage "https://www.dell.com/support/home/en-us/drivers/driversdetails?driverid=dptw0&oscode=wt64a&productcode=dell-wd19-130w-dock"

  livecheck do
    # Actually not working since Dell website "hides" the subsections contents without manual click :-(
    url "https://www.dell.com/support/home/en-us/product-support/product/dell-wd19-130w-dock/drivers"
    regex(/>(?<num>\d+(:?\.\d+)*), (?<tag>A\d+)</i)
    # e.g. >01.00.21.01, A06<
    strategy :page_match do |page, regex|
      match = page.match(regex)
      "#{match[:num]},#{match[:tag]}"
    end
  end

  installer manual: File.basename("#{url}")

  # Not actually necessary, since it would be deleted anyway.
  # Just to make clear an uninstall stanza was not forgotten:
  uninstall delete: "#{staged_path}/" + File.basename("#{url}")

  caveats <<~EOS
    The update utility of the connected dock is not available for macOS.
    This file format consists of a BIOS executable file. The Universal (Windows/MS DOS) format can be used to install from any Windows or MS DOS environment.
  EOS
end
