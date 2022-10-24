cask "displaylink-manager-app" do
  version "1.8" # and "2022-10" to be inserted in the url hereunder
  sha256 "8cd7e7aeb393a707019a7222ce73f2abf2f662e8d1c00f5176b1f3b32ac7fb13"

  url "https://www.synaptics.com/sites/default/files/exe_files/2022-10/DisplayLink%20Manager%20Graphics%20Connectivity#{version}-EXE.pkg"
  name "DisplayLink Manager Graphics Connectivity"
  desc "DisplayLink solution to connect any display to any computer via USB or Wi-Fi"
  homepage "https://www.synaptics.com/products/displaylink-graphics"

  livecheck do
    url "https://www.synaptics.com/products/displaylink-graphics/downloads/macos"
    strategy :page_match
    regex(/DisplayLink Manager Graphics Connectivity.*\n.*\n.*Release: (\d+(?:\.\d+)*) \|/i)	# Avoids Alpha or non standard version
    # regex(/DisplayLink Manager Graphics Connectivity.*\n.*\n.*Release: (\d+(?:\.\d+)*)/i)   	# Any version, maybe ALpha
    # e.g. <h4>DisplayLink Manager Graphics Connectivity</h4><p>Monterey 12, Big Sur 11</p><p>Release: 1.6.1 | <time datetime="00Z">Feb 23, 2022</time>
  end

  depends_on macos: ">= :big_sur"

  conflicts_with cask: "displaylink"	# From homebrew/cask-drivers

  pkg "DisplayLink Manager Graphics Connectivity#{version}-EXE.pkg"

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
