cask "star-wars-scroll" do
  version "1.2.1"
  sha256 "17f982705ea250f1bee118c815b4cf71a112aaf26b9d62e10d83c0417f645e6c"

  url "https://www.killerrobots.com/starwarsscroll/StarWarsScroll.zip"
  name "StarWarsScroll"
  desc "Star Wars screensaver"
  homepage "https://www.killerrobots.com/starwarsscroll/"

  livecheck do
    url :homepage
    strategy :page_match
    regex(/Version (\d+(?:\.\d+)*)/i)
    # e.g. Version 1.2.1 (For Mac OS X 10.7 and later
  end

  screen_saver "StarWarsScroll v#{version}/StarWarsScroll.saver"
end
