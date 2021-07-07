class Rar < Formula
  desc "Archive manager for RAR and other file formats (with man pages)"
  homepage "http://www.rarlab.com/"
  url "https://www.rarlab.com/rar/rarosx-6.0.2.tar.gz"
  sha256 "6da67bd6f617206b36e5fecf274ba3a0652bb166519852e1bc32342a8564b6c8"
  license "Trial(rar) Freeware(unrar)"

  head do
    url "https://www.rarlab.com/rar/rarosx-6.0.2b1.tar.gz"
    sha256 "3c968cc4b77a71fff955bfb2e31ec71fec688ca4fb7b8fd791f6e057809b808d"
  end

  bottle :unneeded

  # conflicts_with formula: "unrar" # Removed https://github.com/Homebrew/homebrew-core/pull/66609
  conflicts_with cask: "rar"

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

    # Installs each command (only not conflicting)
    bin.install "rar-#{version}", "unrar-#{version}"
    # Installs each command
    bin.install "rar", "unrar"

    # Installs documentations and licence informations
    # doc.install Dir["*.*"] # Replaced by following lines, more selective
    lib.install "default.sfx"
    etc.install "rarfiles.lst"
    doc.install "acknow.txt", "license.txt", "order.htm", "rar.txt", "readme.txt", "whatsnew.txt"
    resource("man-rar").stage { man1.install "src" => "rar.1" }
    resource("man-unrar").stage { man1.install "src" => "unrar.1" }
    inreplace "#{man1}/rar.1", "/usr/share/doc/rar", "#{HOMEBREW_PREFIX}/share/doc/rar"
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
