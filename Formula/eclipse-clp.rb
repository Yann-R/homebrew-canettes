class EclipseClp < Formula
  desc "Open-source system for Constraint Logic Programming (CLP)"
  homepage "http://eclipseclp.org/"
  url "https://eclipseclp.org/Distribution/Builds/7.0_63/src/eclipse_src.tgz"
  version "7.0-63" # Manual def, necessary to have the third numbering
  sha256 "4341520c8224671deef18489cb1cdb884749cab0604d5e0dd73e472b04b6d1cd"
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
    sha256 "dff7b910c5c2eb675efad209ae5280c0f7cf3d060a4c42e7486678a602ffbe5f"
  end

  def install
    ENV.deparallelize
    arch = `./ARCH`.chomp! # script used for the makefile name: Intel -> x86_64_macosx, Arm -> unknown
    inreplace "configure", 'TCL_REQUIRED="8.6 8.5 8.4 8.3', 'TCL_REQUIRED="8.5'
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
    %w[eclipse tkeclipse].each do |file|
      inreplace "#{bin}/#{file}", "JRE_HOME:-", "JRE_HOME:-`/usr/libexec/java_home`"
    end

    # Corrects paths of executable scripts
    %w[eclipse tkeclipse tktools].each do |file|
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
