cask "dnd-me" do
  if MacOS.version <= :catalina
    version "1.1.2,837:1611389306"
    sha256 "09681028eb5f6651ddee6113733cc8a7813212246ecca236b698dda253a173d4"
  else
    version "2.0.0,1372:1614616878"
    sha256 "6132b35ed84ceae921c1e9be077fa7e6c3822ff915469a219358d8b6a7e8699c"
  end

  url "https://dl.devmate.com/com.runtimesharks.dndme/#{version.after_comma.before_colon}/#{version.after_colon}/DNDMe-#{version.after_comma.before_colon}.zip",
      verified: "https://dl.devmate.com/"
  appcast "https://updates.devmate.com/com.runtimesharks.dndme.xml"
  name "DND Me"
  desc "Activate Do Not Disturb for a few hours"
  homepage "https://runtimesharks.com/projects/dnd-me"

  depends_on macos: ">= :sierra"

  app "DND Me.app"

  uninstall login_item: "DND Me"

  zap trash: [
    "~/Library/Application Support/DND Me",
    "~/Library/Caches/com.runtimesharks.dndme",
    "~/Library/Preferences/com.runtimesharks.dndme.plist",
  ]

  caveats <<~EOS
    • Due to system limitations on Big Sur (v2.0.0+), if a schedule is active, during those hours DND Me can not perform any actions, but it will update according to external changes.
    • Due to system limitations on Sierra–Catalina (v1.1.3), DND Me does not work if Do Not Disturb is scheduled in System Preferences -> Notifications.
  EOS
end
