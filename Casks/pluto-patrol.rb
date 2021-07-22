cask "pluto-patrol" do
  version "1.0.1"
  sha256 "256e96fc32142547ea39452ceb77b4df8e65f8e261165e52089ea632fd5bb272"

  url "https://erikhinterbichler.com/blog/wp-content/uploads/software/PlutoPatrol.zip?v=1.0.1"
  name "Pluto Patrol"
  desc "Retro arcade homage to the classic Moon Patrol (freeware)"
  homepage "https://erikhinterbichler.com/apps/pluto-patrol/"

  livecheck do
    url :homepage
    strategy :page_match
    regex(/PlutoPatrol.zip\?v=(\d+(?:\.\d+)*)/i)
    # e.g. PlutoPatrol.zip?v=1.0.1
  end

  app "Pluto Patrol.app"
end
