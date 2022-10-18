cask "displaylink-manager" do
  version :latest
  sha256 :no_check

  url "https://www.synaptics.com/products/displaylink-graphics"
  name "DisplayLink Manager & Login Screen Extension"
  desc "Cask to install full DisplayLink Manager (App & Extension)"
  homepage "https://www.synaptics.com/products/displaylink-graphics"

  livecheck do
    skip "This cask only installs 2 depending casks"
  end

  depends_on macos: ">= :big_sur"
  depends_on cask: "displaylink-manager-app"
  depends_on cask: "displaylink-login-screen-ext"

  stage_only true

  uninstall_preflight do
    system_command "#{HOMEBREW_PREFIX}/bin/brew", args: ["uninstall", "--force", "displaylink-login-screen-ext"]
    system_command "#{HOMEBREW_PREFIX}/bin/brew", args: ["uninstall", "--force", "displaylink-manager-app"]
  end
end
