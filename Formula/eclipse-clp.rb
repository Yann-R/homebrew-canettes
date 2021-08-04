class EclipseClp < Formula
  desc "Open-source system for Constraint Logic Programming (CLP)"
  homepage "http://eclipseclp.org/"
  url "https://eclipseclp.org/Distribution/Builds/7.0_55/src/eclipse_src.tgz"
  version "7.0-55" # Manual def, necessary to have the third numbering
  sha256 "3f0f292edf3a3847898cc8bf258c927cffb90449914ee54738df07518ab8a8bf"
  license "MPL-1.1"

  livecheck do
    url "https://eclipseclp.org/Distribution/Builds/"
    regex(%r{href="(\d+\.\d+_\d+)/"}i)
    # e.g. href="7.0_54/"
    # and put '-' instead of '_' (not accepted by brew in versions)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.sub("_", "-") }
    end
  end

  vers = "#{version}".sub("-", "_")
  resource "eclipse-doc" do
    url "https://eclipseclp.org/Distribution/Builds/#{vers}/common/eclipse_doc.tgz"
    sha256 "041358bd262e304174379fed767ccab1fb42b8f77626636101dec11a9a1847a4"
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

    # Corrects paths of executable scripts
    %w[eclipse jeclipse tkeclipse tktools].each do |file|
      inreplace "#{bin}/#{file}", buildpath, libexec
    end

    # Installs auxiliary stuff
    libexec.install "lib"
    libexec.install "lib_public"
    libexec.install "lib_tcl"
    include.install Dir["include/x86_64_macosx/*"]
    doc.install Dir["README*"]
    doc.install "legal"
    resource("eclipse-doc").stage do
      doc.install "doc"
      %w[eclipse.l tkeclipse.l tktools.l].each do |file|
        inreplace "man/manl/#{file}",
                  "In $ECLIPSEDIR/doc/", "In #{HOMEBREW_PREFIX}/share/doc/#{name}/doc/"
      end
      man.install Dir["man/*"]
    end
  end

  test do
    system bin/"eclipse", "-e", "true"
  end
end
