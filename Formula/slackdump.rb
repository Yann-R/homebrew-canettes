class Slackdump < Formula
  arch = Hardware::CPU.arm? ? "arm64" : "x86_64"

  desc "Slack Dumper for messages, users, files and emojis"
  homepage "https://github.com/rusq/slackdump"
  version "2.5.7"
  url "https://github.com/rusq/slackdump/releases/download/v#{version}/slackdump_macOS_#{arch}.tar.gz"
  if Hardware::CPU.arm?
    sha256 "08fbd55a5e308cd8ec5722973e100bc84e4cbe128bb80514d111f57a54fb5718"
  else # Hardware::CPU.intel?
    sha256 "4875d08a443a01e2e40ecd1bcbe876967ada74568980710c119e99aa051a37d4"
  end
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install "slackdump"
    doc.install "LICENSE"
    doc.install "README.rst"
  end

  test do
    system "#{bin}/slackdump", "-V"
  end
end
