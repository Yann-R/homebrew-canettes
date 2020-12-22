cask "dnd-me" do
  version "1.1.2,833:1585769858"
  sha256 "219eb70be0091ec70b13480547cdd0843cd33c68ae94d8b860248a0fb53d90bc"

  url "https://dl.devmate.com/com.runtimesharks.dndme/#{version.after_comma.before_colon}/#{version.after_colon}/DNDMe-#{version.after_comma.before_colon}.zip",
      verified: "https://dl.devmate.com/"
  appcast "https://updates.devmate.com/com.runtimesharks.dndme.xml"
  name "DND Me"
  desc "Activate Do Not Disturb for a few hours"
  homepage "https://runtimesharks.com/projects/dnd-me"

  depends_on macos: "< :big_sur"

  app "DND Me.app"

  uninstall login_item: "DND Me"

  zap trash: [
    "~/Library/Application Support/DND Me",
    "~/Library/Caches/com.runtimesharks.dndme",
    "~/Library/Preferences/com.runtimesharks.dndme.plist",
  ]

  caveats <<~EOS
    • Due to system limitations, DND Me does not work if Do Not Disturb is scheduled in System Preferences -> Notifications.
    • Currently not working on macOS Big Sur.
  EOS
end
