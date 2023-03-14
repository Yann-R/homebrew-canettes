class Mmetl < Formula
  arch = Hardware::CPU.arm? ? "arm" : "amd"

  desc "CLI to transform an export file from some providers to be Mattermost compatible"
  homepage "https://github.com/mattermost/mmetl"
  url "https://github.com/mattermost/mmetl/releases/download/v0.1.1/darwin_#{arch}64.tar.gz"
  if Hardware::CPU.arm?
    sha256 "98f68921163dbbc14bf404b24a5463807ebd8fced26def235eff1ff4495ca6f8"
  else # Hardware::CPU.intel?
    sha256 "9dbdcd0a991fad53ef9f445804a03ba95bcc898a84ea82d511ac01c309539be8"
  end
  version "0.1.1"
  license "Apache-2.0" # As for mmctl

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install "mmetl"
  end

  test do
    output = pipe_output("#{bin}/mmetl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmetl \[command\].*/, output)
  end
end
