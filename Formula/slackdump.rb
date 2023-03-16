class Slackdump < Formula
  arch = Hardware::CPU.arm? ? "arm64" : "x86_64"

  desc "Slack Dumper for messages, users, files and emojis"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/releases/download/v2.3.0/slackdump_macOS_#{arch}.tar.gz"
  if Hardware::CPU.arm?
    sha256 "525d4732a03ab98853bc689acb8f2ff4820a9b63e209d3927524d724500315c6"
  else # Hardware::CPU.intel?
    sha256 "66b4cca6afd7dbbd4ecb0dd68acd147e25fd1b74f3bd93e318b90f595044b04c"
  end
  version "2.3.0"
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
