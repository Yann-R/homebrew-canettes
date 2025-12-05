cask "toshiba-mono-mfp" do
  version "7.119.4.0,21840"
  sha256 "ee57f969fae215485755a5dfb7e396182f76f9977a05568f9ac7c66643d9432a"

  url "https://business.toshiba.com/downloads/KB/f1Ulds/#{version.csv.second}/TOSHIBA_MonoMFP.dmg.gz"
  name "Toshiba MonoMFP Drivers"
  desc "Drivers (Duplex mode) for Multi-Function Printer Toshiba e-STUDIO Series"
  homepage "https://business.toshiba.com/product/e-studio9029a#downloads"

  livecheck do
    url "https://business.toshiba.com/support/downloads/GetDownloads.jsp?model=e-studio9029a"
    strategy :json do |json|
      json["drivers"]&.map do |item|
        next unless item["name"]&.include?("MacDM")

        id = item["id"]
        version = item["versionName"]
        #next if id.blank? || version.blank?

        "#{version},#{id}"
      end
    end
  end

  pkg "TOSHIBA MonoMFP.pkg"

  uninstall pkgutil: "com.toshiba.pde.x7.monomfp",
            delete:  [
              "/Library/Printers/PPDs/Contents/Resources/TOSHIBA_MonoMFP*.gz",
              "/Library/Printers/toshiba",
            ]

  # No zap stanza required
end
