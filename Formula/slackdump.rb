class Slackdump < Formula
  arch = Hardware::CPU.arm? ? "arm64" : "x86_64"

  desc "Slack Dumper for messages, users, files and emojis"
  homepage "https://github.com/rusq/slackdump"
  version "2.3.3"
  url "https://github.com/rusq/slackdump/releases/download/v#{version}/slackdump_macOS_#{arch}.tar.gz"
  if Hardware::CPU.arm?
    sha256 "5348b0a834e3431a5d5b8d4b8fd9237c9991247c09667f093f5401f249711876"
  else # Hardware::CPU.intel?
    sha256 "198e6d2aaa5c9c7aaf0c18c92c962b2c093441f2d3ebc3067f43b9529ce00fdb"
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
