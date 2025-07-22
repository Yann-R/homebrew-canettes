cask "oracle-jdk8" do
  arch arm: "aarch64", intel: "x64"

  version "1.8.0_461" # Java 8 Update 461
  sha256 arm:   "4035e7f00c8a2591e3210d7ea998206975ba7ae6abc117b6787b44d9a249c415",
         intel: "1c9b1d6daf02fd0da0c7e5a9f10f1c6a10e43749dd750e943fe5c8ff83992110"
  
  # version in brew = major.minor.patch, then extract java update number from inside the patch version
  java_update = version.patch.sub(%r{.*_(\d+).*}, '\1') # e.g. 172 for version 1.8.0_172-b10
  java_release = version.minor+"u"+java_update # e.g. 8u172
  # Official URL, requires registering e-mail ID
  #   e.g. https://download.oracle.com/otn/java/jdk/8u401-b10/4d245f941845490c91360409ecffb3b4/jdk-8u401-macosx-x64.dmg
  # url "https://download.oracle.com/otn/java/jdk/#{java_release}-b10/4d245f941845490c91360409ecffb3b4/jdk-#{java_release}-macosx-#{arch}.dmg"
  #
  # Mirror URL, thanks to https://gist.github.com/wavezhang/ba8425f24a968ec9b2a8619d7c2d86a6
  #   giving mirror-links page https://helpx.adobe.com/coldfusion/kb/coldfusion-downloads.html#downloads3
  url "https://cfdownload.adobe.com/pub/adobe/coldfusion/java/java8/java#{java_release}/jdk/jdk-#{java_release}-macosx-#{arch}.dmg"
  name "Oracle JDK SE 8"
  desc "Oracle Java Standard Edition Development Kit (JDK SE & Internet Plug-in) version 8"
  # homepage "https://www.oracle.com/technetwork/java/javase/overview/index.html"
  homepage "https://www.oracle.com/java/technologies/downloads/#java8-mac" # More direct page (linked from the previous page)

  livecheck do
    # Uses the Security Baseline page, recommended by Oracle to list all the latest versions
    url "https://javadl-esd-secure.oracle.com/update/baseline.version"
    strategy :page_match
    regex(/(1.8.*)/i)
  end
  
  pkg "JDK #{version.minor} Update #{java_update}.pkg"
  # pkg "JDK " + java_release.sub("u"," Update ") + ".pkg" # e.g. "JDK 8 Update 172.pkg"

  # uninstall pkgutil: "com.oracle.jdk#{java_release}"
  uninstall pkgutil:   [
                         "com.oracle.jdk#{java_release}",
                         'com.oracle.jre',
                       ],
            launchctl: [
                         'com.oracle.java.Helper-Tool',
                         'com.oracle.java.Java-Updater',
                       ],
            quit:      [
                         'com.oracle.java.Java-Updater',
                         'net.java.openjdk.cmd', # Java Control Panel
                       ],
            delete:    [
                         '/Library/Internet Plug-Ins/JavaAppletPlugin.plugin',
                         "/Library/Java/JavaVirtualMachines/jdk-#{version.major_minor}.jdk/Contents",
                         '/Library/PreferencePanes/JavaControlPanel.prefPane',
                         '/Library/Java/Home',
                       ],
            rmdir:     "/Library/Java/JavaVirtualMachines/jdk-#{version.major_minor}.jdk"  # e.g. 1.8 for 1.8.0_172-b10
  #         rmdir:     "/Library/Java/JavaVirtualMachines/jdk#{version.split('-')[0]}.jdk" # e.g. 1.8.0_172 for 1.8.0_172-b10

  zap trash: [
               '~/Library/Application Support/Java/',
               '~/Library/Application Support/Oracle/Java',
               '~/Library/Caches/com.oracle.java.Java-Updater',
               '~/Library/Caches/Oracle.MacJREInstaller',
               '~/Library/Caches/net.java.openjdk.cmd',
               '~/Library/Preferences/com.oracle.java.Java-Updater.plist',
               '~/Library/Preferences/com.oracle.java.JavaAppletPlugin.plist',
               '~/Library/Preferences/com.oracle.javadeployment.plist',
             ],
      rmdir: '~/Library/Application Support/Oracle/'

  caveats do
    license "https://www.oracle.com/technetwork/java/javase/terms/license/javase-license.html"
  end
end
