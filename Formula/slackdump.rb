class Slackdump < Formula
  arch = Hardware::CPU.arm? ? "arm64" : "x86_64"

  desc "Slack Dumper for messages, users, files and emojis"
  homepage "https://github.com/rusq/slackdump"
  version "2.5.10"
  url "https://github.com/rusq/slackdump/releases/download/v#{version}/slackdump_macOS_#{arch}.tar.gz"
  if Hardware::CPU.arm?
    sha256 "df04dade95169b9a8b5c013c7eb288f702409141e5621caf36ddec4bda3d6489"
  else # Hardware::CPU.intel?
    sha256 "846566c9ad662ccfd386dc6070cbfb51390076cb139a0b8581168413f674baeb"
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
