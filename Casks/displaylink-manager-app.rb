cask "displaylink-manager-app" do
  version "1.8.1,2023-03"
  sha256 "5b8ab02a2c205d9592aa3e4aa40d37223092d7db2b2d92d1ad42b275b9d159fe"

  url "https://www.synaptics.com/sites/default/files/exe_files/#{version.csv.second}/DisplayLink%20Manager%20Graphics%20Connectivity#{version.csv.first}-EXE.pkg"

  name "DisplayLink Manager Graphics Connectivity"
  desc "DisplayLink solution to connect any display to any computer via USB or Wi-Fi"
  homepage "https://www.synaptics.com/products/displaylink-graphics"

  livecheck do
    url "https://www.synaptics.com/products/displaylink-graphics/downloads/macos"
    strategy :page_match
    regex(/DisplayLink Manager Graphics Connectivity.*\n.*\n.*Release: (\d+(?:\.\d+)*) \|/i)	# Avoids Alpha or non standard version
    # regex(/DisplayLink Manager Graphics Connectivity.*\n.*\n.*Release: (\d+(?:\.\d+)*)/i)   	# Any version, maybe Alpha
    # e.g. <h4>DisplayLink Manager Graphics Connectivity</h4><p>Monterey 12, Big Sur 11</p><p>Release: 1.6.1 | <time datetime="00Z">Feb 23, 2022</time>
  end

  depends_on macos: ">= :big_sur"

  conflicts_with cask: "displaylink"	# From homebrew/cask-drivers

  pkg "DisplayLink Manager Graphics Connectivity#{version.csv.first}-EXE.pkg"

  uninstall pkgutil: "com.displaylink.displaylinkmanagerapp"

  zap trash: [
    "~/Library/Application Scripts/com.displaylink.DisplayLinkUserAgent",
    "~/Library/Containers/com.displaylink.DisplayLinkUserAgent",
    "~/Library/Group Containers/*.com.displaylink.DisplayLinkShared",
  ]

  caveats do
    reboot
  end
end
