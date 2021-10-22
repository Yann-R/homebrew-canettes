class Xfig < Formula
  desc "Interactive drawing tool for X"
  homepage "https://mcj.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mcj/xfig-3.2.8b.tar.xz"
  sha256 "b2cc8181cfb356f6b75cc28771970447f69aba1d728a2dac0e0bcf1aea7acd3a"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{url=.*?/xfig[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  depends_on "fig2dev"
  depends_on "ghostscript"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxaw3d"
  depends_on "libxi"
  depends_on "libxpm"
  depends_on "libxt"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --with-appdefaultdir=#{etc}/X11/app-defaults
    ]

    system "./configure", *args
    # "LDFLAGS" argument can be deleted the next release after 3.2.8a. See discussion at
    # https://sourceforge.net/p/mcj/discussion/general/thread/36ff8854e8/#fa9d.
    system "make", "LDFLAGS=-ltiff -ljpeg -lpng", "install-strip"
    # Patches one makefile using implicitely libjpeg on macOS
    #inreplace "src/Makefile", "-lXpm", "-lXpm -ljpeg"
    #system "make", "install"
  end

  test do
    assert_match "Xfig #{version}", shell_output("#{bin}/xfig -v 2>&1")
  end
end
