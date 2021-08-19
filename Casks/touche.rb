cask "touche" do
  version "1.1.5"
  sha256 "1eb9d5af040bbb4182cddb619a3709fba812dfcbe5b0657afd3fd46ac3ab52f8"

  url "https://redsweater.com/touche/Touche#{version}.zip"
  name "Touché"
  desc "Touch Bar for everyone (Simulate, show and hide, take screen captures)"
  homepage "https://redsweater.com/touche/"

  livecheck do
    url :homepage
    strategy :page_match
    regex(/Touche(\d+(?:\.\d+)*)\.zip/i)
    # e.g. href="Touche1.1.4.zip"
  end

  depends_on macos: ">= :sierra"

  app "Touché.app"

  zap trash: [
    "~/Library/Application Scripts/com.red-sweater.touche",
    "~/Library/Containers/com.red-sweater.touche",
    "~/Library/Preferences/com.red-sweater.touche.plist",
  ]
end
