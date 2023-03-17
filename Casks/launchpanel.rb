cask "launchpanel" do
  version "1.8,80"
  sha256 "1b1d17e2c2558eb5626977d0054ff4337eb73d080160878fd7aa01ce3626bd26"

  url "https://noteifyapp.com/download/LaunchPanel.dmg"
  name "LaunchPanel"
  desc "Panel to quickly launch applications, open files and folders"
  homepage "https://noteifyapp.com/launchpanel/"

  livecheck do
    url :url
    strategy :extract_plist
  end

  app "LaunchPanel.app"

  zap trash: [
    "/Users/Shared/LaunchPanel",
    "~/Library/Application Support/LaunchPanel",
    "~/Library/HTTPStorages/com.sergey-gerasimenko.LaunchPanel",
    "~/Library/Preferences/com.sergey-gerasimenko.LaunchPanel.plist",
    "~/Library/Saved Application State/com.sergey-gerasimenko.LaunchPanel.savedState",
  ]
end
