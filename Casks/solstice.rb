cask "solstice" do
  version "6.2"
  sha256 "145a06cd939a32ac00baaa9f8f152153dc84c81a9291acefe189a3bfd4f1f84c"

  url "https://www.mersive.com/files/41693/"
  name "Mersive Solstice"
  desc "Connect, share content, and collaborate freely on a Solstice display"
  homepage "https://www.mersive.com/download/"

  livecheck do
    url :url # Note: URL /files/41693/ remained the same over versions
    strategy :header_match
  end

  app "Mersive Solstice.app"

  zap trash: [
    "~/Library/Application Support/Solstice",
    "~/Library/Preferences/ByHost/com.mersive.solstice.client.*.plist",
    "~/Library/Preferences/com.mersive.solstice.client.plist",
  ]
end
