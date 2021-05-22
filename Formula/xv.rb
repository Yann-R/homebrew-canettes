class Xv < Formula
  desc "Interactive image manipulation program for the X Window System"
  homepage "http://www.trilon.com/xv/"
  # David Griffith's repository is one of the most interesting sources for John Bradley's xv:
  # - integrates Greg Roelofs's jumbo patch http://www.gregroelofs.com/greg_xv.html
  # - and adds many more https://gitlab.com/DavidGriffith/xv/-/issues/4
  url "https://gitlab.com/DavidGriffith/xv.git",
      revision: "c704ea045d1243a19d97ffd0eb74997c413b89d6",
      shallow:  false
  version "3.10a-20190926"
  # license "shareware for personnal use only"
  head "https://gitlab.com/DavidGriffith/xv.git"

  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxrandr"
  depends_on "libxt"
  depends_on "webp"
  # depends on "zlib", uses macOS version

  def install
    # Adapt the source files for macOS
    # inreplace "vdcomp.c", "__DARWIN__", "__APPLE__"
    inreplace "xv.h", "extern char *sys_errlist[];", ""
    inreplace "xv.h", "#include <stdio.h>", "#include <stdio.h>\n#include <limits.h>"
    inreplace "xvjp2k.c", "jas_memdump(FILE *fp,void *data,size_t len)",
              "jas_memdump(FILE *fp,const void *data,size_t len)"

    # Adapt the source files for brewing
    inreplace "xv.h", "#define REVDATE   \"version 3.10a-jumboFix+Enh of 20081216 (interim!)\"",
              "#define REVDATE   \"version #{version}-jumboFix+Enh of 20081216 (David Griffith\'s release)\""
    inreplace "Makefile", "/usr/X11R6/lib", "#{HOMEBREW_PREFIX}/lib"
    # To add X11 include as last, avoids imposing its embedded png includes
    inreplace "Makefile", '-DXVEXECPATH=\"$(LIBDIR)\"', 
              '-DXVEXECPATH=\"$(LIBDIR)\"' + " -I#{HOMEBREW_PREFIX}/include"
    inreplace "Makefile", "TIFFDIR = /usr", "TIFFDIR = #{HOMEBREW_PREFIX}"
    inreplace "Makefile", "JPEGDIR = /usr", "JPEGDIR = #{HOMEBREW_PREFIX}"
    inreplace "Makefile", "PNGDIR = /usr", "PNGDIR = #{HOMEBREW_PREFIX}"
    #inreplace "Makefile", "ZLIBDIR = /usr", "ZLIBDIR = #{HOMEBREW_PREFIX}" # Uses macOS version
    # To enable Jpeg 2000
    inreplace "Makefile", "#JP2K    = -DDOJP2K", "JP2K    = -DDOJP2K"
    inreplace "Makefile", "#JP2KDIR = /usr/local/lib", "JP2KDIR = #{HOMEBREW_PREFIX}"
    inreplace "Makefile", "#JP2KINC = -I$(JP2KDIR)", "JP2KINC = -I$(JP2KDIR)/include"
    inreplace "Makefile", "#JP2KLIB = -L$(JP2KDIR) -ljasper", "JP2KLIB = -L$(JP2KDIR)/lib -ljasper"
    # To set install directory (Makefile notes to update code for that with old K&R compilers)
    inreplace "Makefile", "PREFIX = /usr/local", "PREFIX = #{prefix}"
    # To avoid big ps documentation (but keep pdf version)
    inreplace "Makefile", "docs/xvdocs.ps", ""
    inreplace "Makefile", "$(DESTDIR)$(DOCDIR)/xvdocs.ps", ""

    # Make & Install
    system "make", "install"
  end

  test do
    # Just call xv to show the help text
    system "#{bin}/xv", "-help"
  end
end
