cask "akku" do
  version "0.1.0-beta.11"
  sha256 "6e6a55ea5f70d060901d87fa8aa4d66b5f2a486760905e9946e277c01bf661f3"

  url "https://github.com/jariz/Akku/releases/download/#{version}/Akku.dmg",
      verified: "https://github.com/jariz/Akku/releases/download"
  name "Akku"
  desc "Missing bluetooth headset battery indicator app"
  homepage "https://akku.software/"

  livecheck do
    url "https://github.com/jariz/akku/releases"
    strategy :page_match
    regex(%r{href=.*?/releases/tag/(\d+(?:\.\d+)*(?:-beta\.\d+))}i)
    # e.g. https://github.com/jariz/Akku/releases/tag/0.1.0-beta.11
  end

  app "Akku.app"

  uninstall login_item: "Akku"

  zap trash: [
    "/Library/PrivilegedHelperTools/io.jari.AkkuHelper",
    "/Library/LaunchDaemons/io.jari.AkkuHelper.plist",
    "~/Library/Cache/Akku",
    "~/Library/Logs/Akku.log",
    "~/Library/Preferences/io.jari.Akku.plist",
  ]

  caveats <<~EOS
    Install issue on Catalina, hanging on after 1st install of the helper (and needing [Force Quit]): https://github.com/jariz/Akku/issues/33
  EOS
end
