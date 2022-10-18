cask "displaylink-manager" do
  version "1.7.1,2022-07"
  sha256 "32e2c0dce4888895e59e50181f0e15118d8f066abb4568e994878ce0294d422c"

  url "https://www.synaptics.com/sites/default/files/exe_files/#{version.csv.second}/DisplayLink%20Manager%20Graphics%20Connectivity#{version.csv.first}-EXE.pkg"
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

  pkg "DisplayLink Manager Graphics Connectivity#{version.csv.first}-EXE.pkg"

  preflight do
    system_command "#{HOMEBREW_PREFIX}/bin/brew", args: ["uninstall", "--force", "displaylink-login-screen-ext"]
  end

  postflight do
    system_command "#{HOMEBREW_PREFIX}/bin/brew", args: ["install", "displaylink-login-screen-ext"]
  end

  uninstall_preflight do
    system_command "#{HOMEBREW_PREFIX}/bin/brew", args: ["uninstall", "--force", "displaylink-login-screen-ext"]
  end

  uninstall pkgutil: "com.displaylink.displaylinkmanagerapp"

  zap trash: [
    "~/Library/Application Scripts/com.displaylink.DisplayLinkUserAgent",
    "~/Library/Containers/com.displaylink.DisplayLinkUserAgent",
    "~/Library/Group Containers/*.com.displaylink.DisplayLinkShared",
  ]

  caveats do
    reboot
    license "https://www.synaptics.com/products/displaylink-graphics/downloads/macos-#{version.csv.first}"
  end
end
