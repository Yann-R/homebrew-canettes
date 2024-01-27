class Slackdump < Formula
  arch = Hardware::CPU.arm? ? "arm64" : "x86_64"

  desc "Slack Dumper for messages, users, files and emojis"
  homepage "https://github.com/rusq/slackdump"
  version "2.5.3"
  url "https://github.com/rusq/slackdump/releases/download/v#{version}/slackdump_macOS_#{arch}.tar.gz"
  if Hardware::CPU.arm?
    sha256 "557dc1ad06008d29cc992e7f86ff34b5f352ed47019794aac10a3e8a8b2f83e1"
  else # Hardware::CPU.intel?
    sha256 "de6bef96521eb27c618aaa0d3faffeb100e29257dae0263b46b7e474893cb7d3"
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
