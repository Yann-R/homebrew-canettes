cask "dnd-me" do
  version "1.1.2"
  sha256 :no_check

  url "https://dl.devmate.com/com.runtimesharks.dndme/DNDMe.dmg",
      verified: "https://dl.devmate.com/"
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
