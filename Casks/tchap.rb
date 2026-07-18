cask "tchap" do
  version "4.20.0"
  sha256 "7a1aa5c510e32ef3077a8acbeaada65176cea69a3c103db2a2fe54fe9d8566b8"

  url "https://github.com/tchapgouv/tchap-desktop/releases/download/tchap-#{version}/Tchap-prod_#{version}_universal.dmg"
  name "Tchap"
  desc "Chat through the matrix protocol for the French public service"
  homepage "https://github.com/tchapgouv/tchap-desktop"

  livecheck do
    url :url
    strategy :github_latest
  end

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
