class EclipseClp < Formula
  desc "Open-source system for Constraint Logic Programming (CLP)"
  homepage "http://eclipseclp.org/"
  url "https://eclipseclp.org/Distribution/Builds/7.0_54/src/eclipse_src.tgz"
  version "7.0-54" # Manual def, necessary to have the third numbering
  sha256 "486aba056f530f1f2ca3924bf43b96614930d30613ac2e44f92535678ac6ad71"

  livecheck do
    url "https://eclipseclp.org/Distribution/Builds/"
    regex(%r{href="(\d+\.\d+_\d+)/"}i)
    # e.g. href="7.0_54/"
    # and put '-' instead of '_' (not accepted by brew in versions)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.sub("_", "-") }
    end
  end

  resource "eclipse-doc" do
    url "https://eclipseclp.org/Distribution/Builds/7.0_54/common/eclipse_doc.tgz"
    sha256 "b792eeb5914c56c7d01151cbedea28a8f4da37ad6762b593b0a3ede6eaf0ef22"
  end

  def install
    ENV.deparallelize
    arch = "ECLIPSEARCH=x86_64_macosx"
    system "./configure", arch
    system "make", "-if", "Makefile.x86_64_macosx", arch
    # -i necessary above to ignore errors on auxiliary stuff

    # Installs after compilation by using RUNME as recommended in INSTALL
    input = "echo"      # to accept arch
    input << "; echo"   # to accept current working dir
    input << "; echo #{bin}; echo" # to set install dir for executables
    input << "; echo a" # to accept Tcl/Tk config
    input << "; echo #{`/usr/libexec/java_home`}".chomp! # to set default java home

    # Builds the executable scripts & Installs to #{bin}
    system "(#{input})|./RUNME"

	# Corrects paths
    inreplace "#{bin}/eclipse", buildpath, libexec
    inreplace "#{bin}/jeclipse", buildpath, libexec
    inreplace "#{bin}/tkeclipse", buildpath, libexec
    inreplace "#{bin}/tktools", buildpath, libexec

    # Installs auxiliary stuff
    libexec.install "lib"
    libexec.install "lib_public"
    libexec.install "lib_tcl"
    include.install Dir["include/x86_64_macosx/*"]
    doc.install Dir["README*"]
    doc.install "legal"
    resource("eclipse-doc").stage do
      inreplace "man/manl/tkeclipse.l", "In $ECLIPSEDIR/doc/", "In #{HOMEBREW_PREFIX}/share/doc/eclipse-clp/doc/"
      man.install Dir["man/*"]
      doc.install "doc"
    end
  end

  test do
    system bin/"eclipse", "-e", "true"
  end
end
