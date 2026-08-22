cask "tchap" do
  version "4.21.3"
  sha256 "79ce114f81f81bd1aa1f670d4a52415a193244baf8c4b7c2cf5eb58bb7d653bf"

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
