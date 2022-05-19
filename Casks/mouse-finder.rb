cask "mouse-finder" do
  version "1.0"
  sha256 "8eb2cf4d25f63eaf47f3783a4436f24e503cb19351049234a7ad66f15cb0050e"

  url "https://github.com/neilsardesai/Mouse-Finder/releases/download/v#{version}/Finder.zip"
  name "Mouse Finder"
  desc "Replacement for the system Finder dock icon, with eyes following your mouse pointer"
  homepage "https://github.com/neilsardesai/Mouse-Finder"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Finder.app", target: "Mouse Finder.app"
end
