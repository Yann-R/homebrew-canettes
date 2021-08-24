cask "touche" do
  version "1.1.6"
  sha256 "3375ddea98abe00209d3be6bc135dde3c4447157de46e2a2222bee23aeb1a677"

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
