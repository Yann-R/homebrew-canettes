cask "displaylink-login-screen-ext" do
  version "1.8.0"
  # version "2021-02" according to livecheck strategy :header_match
  # version "5.7.120" according to details in pkg obtained with app Suspicious Package
  sha256 "67f653f331e2e4d182325ded51a00701879d5f9af3da025684f2889777f6d597"

  url "https://www.displaylink.com/downloads/macos_extension"
  name "Login Screen Extension for DisplayLink Manager Graphics Connectivity"
  desc "DisplayLink screens available prior to the user login and the app loading"
  homepage "https://support.displaylink.com/knowledgebase/articles/1932214-displaylink-manager-app-for-macos-introduction-in#other"

  livecheck do
    url :url
    strategy :extract_plist
    # strategy :header_match
    # regex(%r{https://.*exe_files/(.*)/macOS.*\.dmg}i)
    # e.g. Location: https://www.synaptics.com/sites/default/files/exe_files/2021-02/macOS%20App%20LoginExtension-EXE.dmg
  end

  depends_on macos: ">= :big_sur"
  depends_on cask: "displaylink-manager-app"

  conflicts_with cask: "displaylink-login-extension"	# From homebrew/cask-drivers

  pkg "DisplayLinkLoginScreenExtension.pkg"

  uninstall script:  {
              executable: "#{staged_path}/DisplayLink Software Uninstaller.app/Contents/MacOS/DisplayLink Software Uninstaller",
              sudo:       false,
            },
            pkgutil: [
              "com.displaylink.displaylinkloginscreenext",
              "com.displaylink.displayloginscreenext",
            ],
            launchctl: "com.displaylink.loginscreen"

  zap trash: [
    "~/Library/Application Scripts/com.displaylink.DisplayLinkLoginHelper",
    "~/Library/Containers/com.displaylink.DisplayLoginHelper",
  ]
end
