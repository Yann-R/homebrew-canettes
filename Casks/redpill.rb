cask "redpill" do
  version "2.1.1"
  sha256 "32ea5ebd2c08e78b11236eb7e0f32cf54ce5ab9dada8f63302f84d4ecd0ba924"

  url "https://github.com/lpar/RedPill/releases/download/v#{version}/RedPill-#{version}-64bit.dmg"
  name "RedPill"
  desc "3D OpenGL Matrix screensaver"
  homepage "https://github.com/lpar/RedPill"

  livecheck do
    url :url
    strategy :github_latest
  end

  screen_saver "RedPill.saver"
end
