cask "dell-dock-wd19" do
  version "01.00.36,01.00.20"
  sha256 "e65c07f1aab3e9834241d100d65fa611c73b1495ca39e84254b536ec206c52d0"

  url "https://dl.dell.com/FOLDER10996411M/1/DellDockFirmwarePackage_WD19_WD22_Series_HD22_01.00.20.exe"
  name "Dell Docking Station Firmware Update"
  desc "Dell Dock WD19 & WD22 Series Firmware Update Utility"
  homepage "https://www.dell.com/support/home/en-us/product-support/product/dell-wd19-130w-dock/drivers"

  livecheck do
    # url "https://www.dell.com/support/home/en-us/product-support/product/dell-wd19-130w-dock/drivers"
    # Actually not working since Dell website "hides" the subsections contents without manual click :-(
    # Then use the detail subpage instead (but url changes with each new release)
    # which gives dynamically the available other versions.
    url "https://www.dell.com/support/home/en-us/drivers/driversdetails?driverid=t8hfj&oscode=wt64a&productcode=dell-wd19-130w-dock"
    regex(/id=\"otherversion\" class=\"collapse\".+?>(?<num>\d+(:?\.\d+)*), (?<num2>\d+(:?\.\d+)*)</m) # Non-greedy after word collapse to get the 1st other version
    # e.g. id="otherversion" class="collapse"...>01.00.32, 01.00.16<...>01.00.25, 01.00.09<
    strategy :page_match do |page, regex|
      match = page.match(regex)
      otherversion = "#{match[:num]},#{match[:num2]}"
      (otherversion > version)? otherversion : version
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
