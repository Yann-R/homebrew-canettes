class EclipseClpAT6 < Formula
  desc "Open-source system for Constraint Logic Programming (CLP)"
  homepage "http://eclipseclp.org/"
  url "http://eclipseclp.org/Distribution/CurrentRelease/6.1_164%20x86_64_macosx%20Intel-64bit-MacOS/eclipse_basic.tgz"
  version "6.1-164" # Manual def, necessary to have the third numbering
  sha256 "3946b7a3b3ed2f94b6cafe26e323ed848e4032da814cc7bd303d0d48ed326e69"
  license "MPL-1.1"

  livecheck do
    url "http://eclipseclp.org/Distribution/CurrentRelease/"
    regex(/(\d+\.\d+_\d+).*MacOS/i)
    # e.g. 6.1_164 x86_64_macosx Intel-64bit-MacOS
    # and put '-' instead of '_' (not accepted by brew in versions)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.sub("_", "-") }
    end
  end

  # bottle :unneeded	# Calling bottle :unneeded is deprecated! There is no replacement.

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

    # Sets env. var to suppress warning at launch of Tcl-Tk scripts in bin
    %w[tkeclipse tktools].each do |file|
      inreplace "#{bin}/#{file}", "exec", "export TK_SILENCE_DEPRECATION=1\nexec"
    end
    # Corrects paths & names of executable scripts in bin
    %w[eclipse jeclipse tkeclipse tktools].each do |file|
      inreplace "#{bin}/#{file}", buildpath, libexec
      add_suffix "#{bin}/#{file}", version.major
    end
    
    # Corrects relative paths not supported in tcl script in lib
    inreplace "lib_tcl/eclipse.tcl", "join . tkexdr", "join . #{libexec}/lib/x86_64_macosx/tkexdr"
    inreplace "lib_tcl/eclipse.tcl", "join . tkeclipse", "join . #{libexec}/lib/x86_64_macosx/tkeclipse"
    # Corrects (non existing) absolute path to 3rd-party lib and other details
    tool = "/usr/bin/install_name_tool"
    Dir["lib/x86_64_macosx/*.dylib"].each do |file|
      system tool, "-change", "/Users/kish/thirdparty/mpir/x86_64_macosx/lib/libgmp.8.dylib", 
             "libgmp.8.dylib", file # could also change to absolute path in libexec as hereunder
    end
    system tool, "-change", "/Users/kish/thirdparty/mpir/x86_64_macosx/lib/libgmp.8.dylib", 
           "#{libexec}/lib/x86_64_macosx/libgmp.8.dylib", "lib/x86_64_macosx/eclipse.exe"
    system tool, "-change", "libeclipse.dylib", 
           "#{libexec}/lib/x86_64_macosx/libeclipse.dylib", "lib/x86_64_macosx/eclipse.exe"
    system tool, "-change", "x86_64_macosx/bitmap.dylib", "bitmap.dylib", "lib/x86_64_macosx/ic.dylib"

    # Installs auxiliary stuff
    libexec.install "lib"
    libexec.install "lib_tcl"
    include.install "include/x86_64_macosx/" => name # rename as formula subdirectory
    doc.install Dir["README*"]
    doc.install "legal"
    resource("eclipse-doc").stage do
      %w[eclipse.l tkeclipse.l tktools.l].each do |file|
        inreplace "man/manl/#{file}",
                  "In $ECLIPSEDIR/doc/", "In #{HOMEBREW_PREFIX}/share/doc/#{name}/doc/"
        add_suffix "man/manl/#{file}", version.major
      end
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
