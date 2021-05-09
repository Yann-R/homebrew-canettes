cask "dnd-me1" do
  version "1.1.3,837:1611389306"
  sha256 "15edcec06d4f0d754c77e1e3aa0773410ecccc0766df3448ad2d638b5f626598"

  name "DND Me"
  desc "Activate Do Not Disturb for a few hours"
  homepage "https://runtimesharks.com/projects/dnd-me"

   url "https://dl.devmate.com/com.runtimesharks.dndme/#{version.after_comma.before_colon}/#{version.after_colon}/DNDMe-#{version.after_comma.before_colon}.dmg",
      verified: "dl.devmate.com/" # Exists also as .zip (zipped dmg)
      
    livecheck do
      url "https://updates.devmate.com/com.runtimesharks.dndme.xml"
      strategy :page_match do |page| # Avoids strategy :sparkle to target version 1.x in releases
        # e.g. url="https://dl.devmate.com/com.runtimesharks.dndme/837/1611389306/DNDMe-837.zip" length="10445785" type="application/octet-stream" sparkle:version="837" sparkle:shortVersionString="1.1.3"
        match = page.match(%r{url=.*?/(?<tag>\d+)/DNDMe-(?<version>\d+)\.[dmg|zip].*shortVersionString=\"(?<short_version>1(?:\.\d+)*)\"}i)
        "#{match[:short_version]},#{match[:version]}:#{match[:tag]}"
      end
    end

  depends_on macos: "<= :catalina"

  app "DND Me.app"

  uninstall login_item: "DND Me"

  zap trash: [
    "~/Library/Application Support/DND Me",
    "~/Library/Caches/com.runtimesharks.dndme",
    "~/Library/Preferences/com.runtimesharks.dndme.plist",
  ]

  caveats <<~EOS
    • Due to system limitations on Sierra–Catalina (v1.1.3), DND Me does not work if Do Not Disturb is scheduled in System Preferences -> Notifications.
  EOS
end
