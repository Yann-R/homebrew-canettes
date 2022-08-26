cask "dell-dock-wd19" do
  version "01.00.25,01.00.09"
  sha256 "7681256847aa6cf2096ce2a2b6d5e7eca1bdaf208b7ac97f2dd50bbf476b2515"

  url "https://dl.dell.com/FOLDER08634239M/1/DellDockFirmwarePackage_WD19_WD22_HD22_Series_01.00.09.exe"
  name "Dell Docking Station Firmware Update"
  desc "Dell Dock WD19 & WD22 Series Firmware Update Utility"
  homepage "https://www.dell.com/support/home/en-us/product-support/product/dell-wd19-130w-dock/drivers"

  livecheck do
    # url "https://www.dell.com/support/home/en-us/product-support/product/dell-wd19-130w-dock/drivers"
    # Actually not working since Dell website "hides" the subsections contents without manual click :-(
    # Then use the detail subpage instead (but changes with each new release)
    url "https://www.dell.com/support/home/en-us/drivers/driversdetails?driverid=5x3w3&oscode=wt64a&productcode=dell-wd19-130w-dock"
    regex(/>(?<num>\d+(:?\.\d+)*), (?<tag>\d+(:?\.\d+)*)</i)
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
