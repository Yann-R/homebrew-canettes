class EclipseClp < Formula
  desc "Open-source system for Constraint Logic Programming (CLP)"
  homepage "http://eclipseclp.org/"
  license "MPL-1.1"

  stable do
    version "7.0_63" # Manual def, necessary to have the third numbering
    # vers = version.to_s.sub("-", "_") # _ in version was not recommended by brew
    vers = version.to_s
    url "https://eclipseclp.org/Distribution/Builds/#{vers}/src/eclipse_src.tgz"
    sha256 "4341520c8224671deef18489cb1cdb884749cab0604d5e0dd73e472b04b6d1cd"
    resource "eclipse-doc" do
      url "https://eclipseclp.org/Distribution/Builds/#{vers}/common/eclipse_doc.tgz"
      sha256 "dff7b910c5c2eb675efad209ae5280c0f7cf3d060a4c42e7486678a602ffbe5f"
    end
  end

  livecheck do
    url "https://eclipseclp.org/Distribution/Builds/" # Not equivalent to url :stable
    regex(%r{href="(\d+\.\d+_\d+)/"})
    # e.g. href="7.0_54/"
  end

  head do # unfrozen version in http://eclipseclp.org/relnotes/index.html
    headversion = "7.1_13"
    url "https://eclipseclp.org/Distribution/Builds/#{headversion}/src/eclipse_src.tgz"
    sha256 "c3696032683b0c95fd4cfa805692ffbe780f79f4b6a252cf9c105165c02ec872"
    resource "eclipse-doc" do
      url "https://eclipseclp.org/Distribution/Builds/#{headversion}/common/eclipse_doc.tgz"
      sha256 "ce10d6e2776fd519f006acb9c38dedb680926d521093cd786741a082a3eb0ad7"
    end
  end

  def install
    # arch = `./ARCH`.chomp! # script used for the makefile name: Intel -> x86_64_macosx, Arm -> unknown
    if Hardware::CPU.intel?
      arch = "x86_64_macosx"
    else # Hardware::CPU.arm? # Not yet handled by upstream sources, unlike x86_64_macosx
      arch = "aarch64_macosx"
      inreplace "configure", "x86_64-*-darwin*)", "aarch64-*-darwin*)" # To avoid direct exit as unknown architecture
      inreplace "configure" do |s|
        s.gsub! "x86_64_macosx", arch # To build in correctly named subdirs (better but not necessary)
      end
    end
    inreplace "configure", 'TCL_REQUIRED="8.6 8.5 8.4 8.3', 'TCL_REQUIRED="8.5'

    # Builds the software
    system "./configure"
    ENV.deparallelize
    system "make", "-if", "Makefile.#{arch}"
    # -i necessary above to ignore errors on auxiliary stuff

    # Installs after build by using RUNME as recommended in INSTALL
    input = "echo #{arch}; echo"    # to set and confirm arch
    input << "; echo"               # to accept current working dir
    input << "; echo #{bin}; echo"  # to set install dir for executables
    input << "; echo a"             # to accept Tcl/Tk config
    # input << "; echo #{`/usr/libexec/java_home`}".chomp! # to set default java home
    input << "; echo s" # to skip java home, not hard-coded but replaced at run below

    # Creates the executable scripts & Installs to #{bin}
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
    include.install Dir["include/#{arch}/*"]
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
