cask "dnd-me" do
  if MacOS.version <= :catalina
    version "1.1.3,837,1611389306"
    sha256 "15edcec06d4f0d754c77e1e3aa0773410ecccc0766df3448ad2d638b5f626598"
  else
    version "2.2.2,1684,1619161284"
    sha256 "14a0551eb86435356716600c747076148bbdc00014dc18fa5b9a4fea2f55cfcc"
  end

  url "https://dl.devmate.com/com.runtimesharks.dndme/#{version.csv.second}/#{version.csv.third}/DNDMe-#{version.csv.second}.dmg",
      verified: "dl.devmate.com/" # Exists also as .zip (zipped dmg)
  name "DND Me"
  desc "Activate Do Not Disturb for a few hours"
  homepage "https://runtimesharks.com/projects/dnd-me"

  livecheck do
    url "https://updates.devmate.com/com.runtimesharks.dndme.xml"
    strategy :sparkle do |item|
      # e.g. url="https://dl.devmate.com/com.runtimesharks.dndme/837/1611389306/DNDMe-837.zip"
      # length="10445785" type="application/octet-stream"
      # sparkle:version="837" sparkle:shortVersionString="1.1.3"
      "#{item.short_version},#{item.version},#{item.url[%r{/(\d+)/DNDMe-\d+\.[dmg|zip]}i, 1]}"
    end
  end

  depends_on macos: [
    :sierra,
    :high_sierra,
    :mojave,
    :catalina,
    :big_sur,
  ]

  app "DND Me.app"

  uninstall login_item: "DND Me"

  zap trash: [
    "~/Library/Application Support/DND Me",
    "~/Library/Caches/com.runtimesharks.dndme",
    "~/Library/Preferences/com.runtimesharks.dndme.plist",
  ]

  caveats <<~EOS
    • Due to system limitations, DND Me does not work on Monterey.
    • Due to system limitations on Big Sur (v2.0.0+), if a schedule is active, during those hours DND Me can not perform any actions, but it will update according to external changes.
    • Due to system limitations on Sierra–Catalina (v1.1.3), DND Me does not work if Do Not Disturb is scheduled in System Preferences -> Notifications.
  EOS
end
