class Slackdump < Formula
  arch = Hardware::CPU.arm? ? "arm64" : "x86_64"

  desc "Slack Dumper for messages, users, files and emojis"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/releases/download/v2.3.2/slackdump_macOS_#{arch}.tar.gz"
  if Hardware::CPU.arm?
    sha256 "e2521af5025664d54aac1dec5cd82428944ba4fbb12819b0936ac2905c99d5d5"
  else # Hardware::CPU.intel?
    sha256 "95fc43f4e852b71fc709653d9ff51cc2579a18545739e3d7bffa6c4cf69f44af"
  end
  version "2.3.2"
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
