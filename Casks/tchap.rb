cask "tchap" do
  version "4.21.4"
  sha256 "5ce070af11956a83f68a10373494240bd08f849fbfdcebad954a69d3b3afd52a"

  url "https://github.com/tchapgouv/tchap-desktop/releases/download/tchap-#{version}/Tchap-prod_#{version}_universal.dmg"
  name "Tchap"
  desc "Chat through the matrix protocol for the French public service"
  homepage "https://github.com/tchapgouv/tchap-desktop"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on :macos

  app "Tchap.app"

  postflight do
    app_path = appdir/"Tchap.app"
    next unless app_path.exist?

    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", app_path]
  end

  zap trash: [
    "~/Library/Application Support/fr.gouv.beta.tchap-desktop",
    "~/Library/Caches/fr.gouv.beta.tchap-desktop",
    "~/Library/HTTPStorages/fr.gouv.beta.tchap-desktop.binarycookies",
    "~/Library/Preferences/fr.gouv.beta.tchap-desktop.plist",
    "~/Library/WebKit/fr.gouv.beta.tchap-desktop",
  ]

  caveats <<~EOS
    license "https://github.com/tchapgouv/tchap-desktop/blob/master/LICENCE"
  EOS
end
