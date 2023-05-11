class Slackdump < Formula
  arch = Hardware::CPU.arm? ? "arm64" : "x86_64"

  desc "Slack Dumper for messages, users, files and emojis"
  homepage "https://github.com/rusq/slackdump"
  version "2.3.4"
  url "https://github.com/rusq/slackdump/releases/download/v#{version}/slackdump_macOS_#{arch}.tar.gz"
  if Hardware::CPU.arm?
    sha256 "7505265fefebd4b7cbbd89c927f20c28826099f5d3cf84ee4a14cff5d8d6a4bd"
  else # Hardware::CPU.intel?
    sha256 "63b0d12e4c4fcb45d518f3cba80bfcecd4669c1958ba3e88477a50f4c2400114"
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
