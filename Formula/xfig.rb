class Xfig < Formula
  desc "Interactive drawing tool for X"
  homepage "https://mcj.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mcj/xfig-3.2.8.tar.xz"
  sha256 "dc2f4fb8d3fc119da5c9d4db89cd1607c49fad74436965253612d80e2eaeeab3"

  livecheck do
    url :stable
    regex(%r{url=.*?/xfig[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  depends_on "fig2dev"
  depends_on "ghostscript"
  depends_on "jpeg"
  depends_on "libx11"
  depends_on "libxaw3d"
  depends_on "libxt"

  def install
    args = %W[
      # LDFLAGS="-ljpeg"
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    # Patches one makefile using implicitely libjpeg on macOS
    inreplace "src/Makefile", "-lXpm", "-lXpm -ljpeg" 
    system "make", "install"
  end

  test do
    assert_match "Xfig #{version}", shell_output("#{bin}/xfig -v 2>&1")
  end
end
