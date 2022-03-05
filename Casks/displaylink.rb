cask "displaylink" do
  version "1.6.1"
  sha256 "b38e4c7e69072e1f443c4778477cd69d56aee1430f659c097dcaefb56807ae42"

  url "https://www.synaptics.com/sites/default/files/exe_files/2022-02/DisplayLink%20Manager%20Graphics%20Connectivity#{version}-EXE.pkg"
  name "DisplayLink Manager Graphics Connectivity"
  desc "Solution of DisplayLink to connect any display to any computer that supports USB or Wi-Fi"
  homepage "https://www.synaptics.com/products/displaylink-graphics"

  livecheck do
    url "https://www.synaptics.com/products/displaylink-graphics/downloads/macos"
    strategy :page_match
    regex(/DisplayLink Manager Graphics Connectivity.*\n.*\n.*Release: (\d+(?:\.\d+)*)/i)
    # e.g. <h4>DisplayLink Manager Graphics Connectivity</h4><p>Monterey 12, Big Sur 11</p><p>Release: 1.6.1 | <time datetime="00Z">Feb 23, 2022</time>
  end

  depends_on macos: ">= :big_sur"

  pkg "DisplayLink Manager Graphics Connectivity#{version}-EXE.pkg"

  uninstall pkgutil: "com.displaylink.displaylinkmanagerapp"

  zap trash: [
    "~/Library/Application Scripts/com.displaylink.DisplayLinkUserAgent",
    "~/Library/Containers/com.displaylink.DisplayLinkUserAgent",
    "~/Library/Group Containers/*.com.displaylink.DisplayLinkShared",
  ]
end
