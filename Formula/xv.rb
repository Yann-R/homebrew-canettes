class Xv < Formula
  desc "Interactive image manipulation program for the X Window System"
  # homepage "http://www.trilon.com/xv/"          	# Discontinued
  homepage "https://github.com/jasper-software/xv"	# Revival
  url "https://github.com/jasper-software/xv/releases/download/v6.1.0/xv-3.10a-js-6.1.0.tar.gz"
  sha256 "bfd0df563a7d5e6632fd22a4789d6a2e5ec24c83027d058a563eebc6dc74ca9c"
  # license "shareware for personal use only"
  head "https://github.com/jasper-software/xv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "cmake" => :build
  depends_on "ghostscript" => :build # for ps2pdf
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libice" # Implied by libxt
  depends_on "libpng"
  depends_on "libsm"  # Implied by libxt
  depends_on "libtiff"
  depends_on "libx11" # Implied by libxt
  depends_on "libxrandr"
  depends_on "libxt"
  depends_on "webp"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "tmp_cmake", *std_cmake_args # Create makefile
    system "cmake", "--build", "tmp_cmake", "--target", "install" # Build & Install

    # Following man5 install disabled (kept in doc) due to man conflict with netpbm
    # man5.install Dir["#{doc}/formats/*.5"]    # Move *.5 from doc to man pages
    Utils::Gzip.compress(*Dir["#{man}/**/*.*"]) # All dirs, recursively
    system "ps2pdf", "#{doc}/manuals/xvtitle.ps", "#{doc}/manuals/xvtitle.pdf"
    File.unlink "#{doc}/manuals/xvdocs.ps"  if File.exist? "#{doc}/manuals/xvdocs.pdf"
    File.unlink "#{doc}/manuals/xvtitle.ps" if File.exist? "#{doc}/manuals/xvtitle.pdf"
  end

  test do
    # Just call xv to show the help text
    system "#{bin}/xv", "-help"
  end
end
