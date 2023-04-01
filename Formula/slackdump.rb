class Slackdump < Formula
  arch = Hardware::CPU.arm? ? "arm64" : "x86_64"

  desc "Slack Dumper for messages, users, files and emojis"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/releases/download/v2.3.1/slackdump_macOS_#{arch}.tar.gz"
  if Hardware::CPU.arm?
    sha256 "9e9803478de33d21fb87d718573d62673f9221a4b728aee0387eba053e6f4f65"
  else # Hardware::CPU.intel?
    sha256 "569bc7e28b2a98a6346c465b097c3924249bb6f3e56c2eb900bee0a098e3a66b"
  end
  version "2.3.1"
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
