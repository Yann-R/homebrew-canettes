cask "un-mutemic" do
  version "1.4.2"
  sha256 "96ec84d4da2db21a573af3c61448f76275870b170135ce1445e250506d049fbc"

  url "https://github.com/CocoaHeadsBrasil/MuteUnmuteMic/releases/download/#{version}/Un.MuteMic.zip"
  name "[Un]MuteMic"
  desc "Mute & Unmute the input volume of your microphone"
  homepage "https://github.com/CocoaHeadsBrasil/MuteUnmuteMic"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "[Un]MuteMic"

  zap trash: "~/Library/Preferences/br.com.cocoaheads.MuteUnmuteMic.plist"
end
