cask "touche" do
  version "1.1.4"
  sha256 "275a2885214befd088fe20707f306d3ad1743cf8181334ed4ef976391fff6c7f"

  url "https://redsweater.com/touche/Touche#{version}.zip"
  name "Touché"
  desc "Touch Bar for everyone (Simulate, show and hide, take screen captures)"
  homepage "https://redsweater.com/touche/"

  livecheck do
    url :homepage
    strategy :page_match
    regex(/Touche(\d+(?:\.\d+)*)\.zip/i)
  end

  depends_on macos: ">= :sierra"

  app "Touché.app"

  zap trash: [
    "~/Library/Application Scripts/com.red-sweater.touche",
    "~/Library/Containers/com.red-sweater.touche",
    "~/Library/Preferences/com.red-sweater.touche.plist",
  ]
end
