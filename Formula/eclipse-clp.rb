class EclipseClp < Formula
  desc "Open-source system for Constraint Logic Programming (CLP)"
  homepage "http://eclipseclp.org/"
  url "https://eclipseclp.org/Distribution/Builds/7.0_57/src/eclipse_src.tgz"
  version "7.0-57" # Manual def, necessary to have the third numbering
  sha256 "9cd221f0d16223c0029dc6c58e7037d510b30e481354d3d6d0b82a972634488c"
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

  vers = version.to_s.sub("-", "_")
  resource "eclipse-doc" do
    url "https://eclipseclp.org/Distribution/Builds/#{vers}/common/eclipse_doc.tgz"
    sha256 "d48186c0d15d4d5918d455e355cb40d67b9c159ee76f4e56b446830598ecd192"
  end

  def install
    ENV.deparallelize
    arch = `./ARCH`.chomp! # script used for the makefile name: Intel -> x86_64_macosx, Arm -> unknown
    system "./configure", "ECLIPSEARCH=#{arch}"
    system "make", "-if", "Makefile.#{arch}", "ECLIPSEARCH=#{arch}"
    # -i necessary above to ignore errors on auxiliary stuff

    # Installs after compilation by using RUNME as recommended in INSTALL
    input = "echo"      # to accept arch
    input << "; echo"   # to accept current working dir
    input << "; echo #{bin}; echo" # to set install dir for executables
    input << "; echo a" # to accept Tcl/Tk config
    # input << "; echo #{`/usr/libexec/java_home`}".chomp! # to set default java home
    input << "; echo s" # to skip java home, not hard-coded but replaced at run below

    # Builds the executable scripts & Installs to #{bin}
    system "(#{input})|./RUNME"

    # Sets env. var to suppress warning at launch of Tcl-Tk scripts in bin
    %w[tkeclipse tktools].each do |file|
      inreplace "#{bin}/#{file}", "exec", "export TK_SILENCE_DEPRECATION=1\nexec"
    end

    # Defines JRE_HOME for java at launch time in scripts (instead of hard-coded)
    %w[eclipse jeclipse tkeclipse].each do |file|
      inreplace "#{bin}/#{file}", "JRE_HOME:-", "JRE_HOME:-`/usr/libexec/java_home`"
    end

    # Corrects paths of executable scripts
    %w[eclipse jeclipse tkeclipse tktools].each do |file|
      inreplace "#{bin}/#{file}", buildpath, libexec
    end

    # Corrects relative paths not supported in tcl script in lib
    inreplace "lib_tcl/eclipse.tcl", "join . tkexdr", "join . #{libexec}/lib/x86_64_macosx/tkexdr"
    inreplace "lib_tcl/eclipse.tcl", "join . tkeclipse", "join . #{libexec}/lib/x86_64_macosx/tkeclipse"

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
