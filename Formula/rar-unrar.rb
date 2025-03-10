class RarUnrar < Formula
  arch = Hardware::CPU.arm? ? "arm" : "x64"

  desc "Archive manager for RAR and other formats (with man pages)"
  homepage "http://www.rarlab.com/"
  url "https://www.rarlab.com/rar/rarmacos-#{arch}-710.tar.gz"
  if Hardware::CPU.arm?
    sha256 "81b6c5ca75583d5b0e340e0683c045a7327fe08c8d8424ff286855d6f8ed2054"
  else # Hardware::CPU.intel?
    sha256 "cd835c92bc4e02e82c34510d8cd4466859866856eb46fef78e911e4e6425a3c0"
  end
  license "40-Day-Trial(rar) Freeware(unrar)" # See help in binaries, and order.htm in doc

  livecheck do
    url "https://www.rarlab.com/download.htm"
    strategy :page_match
    regex(/rarmacos-#{arch}-(\d+(:?[.b]\d+)*)\.t/i)
    # e.g. rarmacos-arm-6.0.2b1.tar.gz
  end

  head do # To get the most recent (beta) version
    $headversion = "711b1"	# To avoid having only HEAD in #{version}
    url "https://www.rarlab.com/rar/rarmacos-#{arch}-#{$headversion}.tar.gz"
    if Hardware::CPU.arm?
      sha256 "c08f454b65b71dd6420727d4215e743275fe28243de21ca604a69c90f150df10"
    else # Hardware::CPU.intel?
      sha256 "5e7793f0128bd2fbd78cecf16c88b30e7361d4bb907fc982402a261c68968ef9"
    end
  end

  # bottle :unneeded	# Calling bottle :unneeded is deprecated! There is no replacement.

  option "without-rar", "Don't install rar (but keep unrar-version)"
  option "without-unrar", "Don't install unrar (but keep unrar-version)"

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
    number = build.head? ? $headversion : version

    # Renames binaries with version numbers to avoid conflicts
    File.rename "rar", "rar-#{number}"
    File.rename "unrar", "unrar-#{number}"

    # Creates convenience symlinks
    File.symlink "rar-#{number}", "rar"
    File.symlink "unrar-#{number}", "unrar"

    # Installs each command
    bin.install "rar-#{number}", "unrar-#{number}" # Avoids any conflict
    bin.install "rar" if build.with? "rar"
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
