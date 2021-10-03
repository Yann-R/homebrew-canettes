cask "solstice" do
  version "5.3.4"
  sha256 "0c1941756960741de95de3147673782c462ebeeabcf1ade7a9f64e07f3e7262e"

  url "https://www.mersive.com/files/41693/"
  name "Mersive Solstice"
  desc "Connect, share content, and collaborate freely on a Solstice display"
  homepage "https://www.mersive.com/download/"

  livecheck do
    url :homepage
    regex(/www.mersive.com\/files\/(?<num>\d+)\/.+Download for macOS/i)
    # e.g. href="https://www.mersive.com/files/41693/" class="btn btn-primary ntm-download-btn">Download for macOS Laptop (dmg)
    strategy :page_match do |page, regex|
      match = page.match(regex)
      "#{match[:num]}" == "41693" ? version : "new"
    end
  end

  app "Mersive Solstice.app"

  zap trash: [
    "~/Library/Application Support/Solstice",
    "~/Library/Preferences/ByHost/com.mersive.solstice.client.*.plist",
    "~/Library/Preferences/com.mersive.solstice.client.plist",
  ]
end
