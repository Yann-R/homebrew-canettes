class RarUnrar < Formula
  arch = Hardware::CPU.arm? ? "arm" : "x64"

  desc "Archive manager for RAR and other formats (with man pages)"
  homepage "http://www.rarlab.com/"
  url "https://www.rarlab.com/rar/rarmacos-#{arch}-610.tar.gz"
  if Hardware::CPU.arm?
    sha256 "64eefac221a5e5f93934360114e5e0f1f750606e0e5d7823c780887f6630c13c"
  else # Hardware::CPU.intel?
    sha256 "5c68d6b55e483e498d1b2851ff293098a5b537ca8676dc5bb561d05abcd57664"
  end
  license "40-Day-Trial(rar) Freeware(unrar)" # See help in binaries, and order.htm in doc

  livecheck do
    url "https://www.rarlab.com/download.htm"
    strategy :page_match
    regex(/rarmacos-#{arch}-(\d+(:?\.\S+)*)\.t/i)
    # e.g. rarmacos-arm-6.0.2b1.tar.gz
  end

  head do # To get the most recent beta version
    url "https://web.archive.org/web/20220117015742/https://www.rarlab.com/rar/rarmacos-#{arch}-610b3.tar.gz"
    if Hardware::CPU.arm?
      sha256 "06ebdb216c2518e5314d15f76255d50c45d0ec45943a74253a357c23a73d5508"
    else # Hardware::CPU.intel?
      sha256 "1a63006cb8fc80a76cdb8fc3774c4ba0348c1a6264013e8186ca75d769a06077"
    end
  end

  # bottle :unneeded	# Calling bottle :unneeded is deprecated! There is no replacement.

  option "without-unrar", "Don't install unrar (but keep unrar-version)"
  # option "with-version",  "Add version number as suffix of executables"

  # conflicts_with formula: "unrar" # Removed by https://github.com/Homebrew/homebrew-core/pull/66609
  # conflicts_with cask: "rar"

  resource "man-rar" do
    url "http://manned.org/rar/e007f5f2/src"
    sha256 "5f928ea6eccd51457df128bc8d87cc0676e47e7d48bb6d9591b1d24b8dcf492b"
  end

  resource "man-unrar" do
    url "http://manned.org/unrar/d8cf29d7/src"
    sha256 "82847c9a39c13d852c6b540750a763ed9cf9ca791cceef0651332e2ec5eb114f"
  end

  def install
    # Renames binaries with version numbers to avoid conflicts
    File.rename "rar", "rar-#{version}"
    File.rename "unrar", "unrar-#{version}"

    # Creates convenience symlinks
    File.symlink "rar-#{version}", "rar"
    File.symlink "unrar-#{version}", "unrar"

    # Installs each command
    bin.install "rar-#{version}", "unrar-#{version}" # Avoids any conflict
    bin.install "rar"
    bin.install "unrar" if build.with? "unrar"

    # Installs documentations and license informations
    # doc.install Dir["*.*"] # Replaced by following lines, more selective
    lib.install "default.sfx"
    etc.install "rarfiles.lst" # As recommended in rar.txt
    doc.install "acknow.txt", "license.txt", "order.htm", "rar.txt", "readme.txt", "whatsnew.txt"

    # Installs man pages (from Debian)
    resource("man-rar").stage { man1.install "src" => "rar.1" }
    resource("man-unrar").stage { man1.install "src" => "unrar.1" }
    inreplace "#{man1}/rar.1", "/usr/share/doc/rar", "#{HOMEBREW_PREFIX}/share/doc/#{name}"
  end

  test do
    cp test_fixtures("test.wav"), "test_orig.wav"
    system bin/"rar", "a", "test.rar", "test_orig.wav"
    system bin/"rar", "rn", "test.rar", "test_orig.wav", "test.wav"
    assert_match "test.wav", shell_output("#{bin}/rar l test.rar")
    system bin/"rar", "x", "test.rar"
    cmp "test.wav", "test_orig.wav"
  end
end
