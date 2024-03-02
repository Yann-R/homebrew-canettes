cask "webarchive-extractor" do
  version "1.1"
  sha256 "6af8a053512de058643462fea10ddc6d7ef729d862eb3552cd6c295e248e9fde"

  url "https://github.com/robrohan/WebArchiveExtractor/releases/download/v#{version}/WebArchiveExtractor.tar.zip"
  name "WebArchiveExtractor"
  desc "Un-archive Apple .webarchive files"
  homepage "http://robrohan.github.io/WebArchiveExtractor"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "WebArchiveExtractor.app"

  zap trash: [
    "~/Library/Preferences/com.robrohan.WebArchiveExtractor.plist",
    "~/Library/Saved Application State/com.robrohan.WebArchiveExtractor.savedState",
  ]
end
