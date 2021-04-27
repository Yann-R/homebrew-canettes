class EclipseClp < Formula
  desc "Open-source system for Constraint Logic Programming (CLP)"
  homepage "http://eclipseclp.org/"
  url "http://eclipseclp.org/Distribution/CurrentRelease/6.1_164%20x86_64_macosx%20Intel-64bit-MacOS/eclipse_basic.tgz"
  version "6.1-164"
  sha256 "3946b7a3b3ed2f94b6cafe26e323ed848e4032da814cc7bd303d0d48ed326e69"

  livecheck do
    url "http://eclipseclp.org/Distribution/CurrentRelease/"
    regex(%r{(\d+\.\d+_\d+).*MacOS}i)
    # e.g. 6.1_164 x86_64_macosx Intel-64bit-MacOS
    # and put '-' instead of '_' (not accepted by brew in versions)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.sub("_", "-") }
    end
  end

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
    # input << "echo /Library/Java/Home; " # to set default java home from link to current

    # Builds the executables & Installs to #{bin}
    system "(#{input})|./RUNME"

    inreplace "#{bin}/eclipse", buildpath, libexec
    inreplace "#{bin}/jeclipse", buildpath, libexec
    inreplace "#{bin}/tkeclipse", buildpath, libexec
    inreplace "#{bin}/tktools", buildpath, libexec

    # Installs auxiliary stuff
    libexec.install "lib"
    libexec.install "lib_tcl"
    include.install Dir["include/x86_64_macosx/*"]
    doc.install Dir["README*"]
    doc.install "legal"
    resource("eclipse-doc").stage do
      man.install Dir["man/*"]
      doc.install "doc"
    end
  end

  test do
    system bin/"eclipse", "-e", "true"
  end
end
