class EclipseClpAT6 < Formula
  desc "Open-source system for Constraint Logic Programming (CLP)"
  homepage "http://eclipseclp.org/"
  url "http://eclipseclp.org/Distribution/CurrentRelease/6.1_164%20x86_64_macosx%20Intel-64bit-MacOS/eclipse_basic.tgz"
  version "6.1-164" # Manual def, necessary to have the third numbering
  sha256 "3946b7a3b3ed2f94b6cafe26e323ed848e4032da814cc7bd303d0d48ed326e69"

  livecheck do
    url "http://eclipseclp.org/Distribution/CurrentRelease/"
    regex(/(\d+\.\d+_\d+).*MacOS/i)
    # e.g. 6.1_164 x86_64_macosx Intel-64bit-MacOS
    # and put '-' instead of '_' (not accepted by brew in versions)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.sub("_", "-") }
    end
  end

  bottle :unneeded

  resource "eclipse-doc" do
    url "http://eclipseclp.org/Distribution/CurrentRelease/6.1_164%20x86_64_macosx%20Intel-64bit-MacOS/eclipse_doc.tgz"
    sha256 "064b1e46d83150953af259346e2e3f97a0f96e3f1493829eea72978577dc6a2c"
  end

  def install
    input = "echo"      # to accept arch
    input << "; echo"   # to accept current working dir
    input << "; echo #{bin}; echo" # to set install dir for executables
    input << "; echo a" # to accept Tcl/Tk config
    input << "; echo #{`/usr/libexec/java_home`}".chomp! # to set default java home

    # Builds the executable scripts & Installs to #{bin}
    system "(#{input})|./RUNME"

    # Corrects paths & names
    inreplace "#{bin}/eclipse", buildpath, libexec
    inreplace "#{bin}/jeclipse", buildpath, libexec
    inreplace "#{bin}/tkeclipse", buildpath, libexec
    inreplace "#{bin}/tktools", buildpath, libexec
    add_suffix "#{bin}/eclipse", version.major
    add_suffix "#{bin}/jeclipse", version.major
    add_suffix "#{bin}/tkeclipse", version.major
    add_suffix "#{bin}/tktools", version.major

    # Installs auxiliary stuff
    libexec.install "lib"
    libexec.install "lib_tcl"
    include.install "include/x86_64_macosx/" => name # In a formula-name subdirectory
    doc.install Dir["README*"]
    doc.install "legal"
    resource("eclipse-doc").stage do
      inreplace "man/manl/eclipse.l", "In $ECLIPSEDIR/doc/", "In #{HOMEBREW_PREFIX}/share/doc/#{name}/doc/"
      inreplace "man/manl/tkeclipse.l", "In $ECLIPSEDIR/doc/", "In #{HOMEBREW_PREFIX}/share/doc/#{name}/doc/"
      inreplace "man/manl/tktools.l", "In $ECLIPSEDIR/doc/", "In #{HOMEBREW_PREFIX}/share/doc/#{name}/doc/"
      add_suffix "man/manl/eclipse.l", version.major
      add_suffix "man/manl/tkeclipse.l", version.major
      add_suffix "man/manl/tktools.l", version.major
      man.install Dir["man/*"]
      doc.install "doc"
    end
  end

  def add_suffix(file, suffix)
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}/#{base}-#{suffix}#{ext}"
  end

  test do
    system bin/"eclipse-#{version.major}", "-e", "true"
  end
end
