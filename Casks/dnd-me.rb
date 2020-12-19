cask "dnd-me" do
  version "1.1.2"
  sha256 "d57e89a8c6c569fd9fc3daa2335011253694b7b5b6521b33e744360a42b4009b"

  url "https://dl.devmate.com/com.runtimesharks.dndme/DNDMe.dmg",
      verified: "https://dl.devmate.com/"
  appcast "https://runtimesharks.com/projects/dnd-me"
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
