
cask "bonzaiboost" do
  version "1.6.4"
  sha256 "be7bc20ab567de92a80d18dc46ee61a55537748374f568ee3775ba7ef3b98276"

  url "http://bonzaiboost.gforge.inria.fr/bonzaiboost-macosx-v#{version}"
  name "bonzaiboost classifier"
  desc "Machine-learning program building a classifier (based on a decision tree)"
  homepage "http://bonzaiboost.gforge.inria.fr/"

  livecheck do
    url :homepage
    strategy :page_match
    regex(/bonzaiboost v(\d+(?:\.\d+)*)/i)
  end

  depends_on formula: "gcc"
  # depends on formula: "libomp" # In fact uses libgomp included with GCC (not libomp/LLVM)

  binary "bonzaiboost-macosx-v#{version}", target: "bonzaiboost"

  postflight do
    # Makes required dynamic libs relocatable
    %w[libstdc++.6 libgomp.1 libgcc_s.1].each do |lib|
      system_command "/usr/bin/install_name_tool",
                     args: %W[
                       -change
                       /usr/local/lib/#{lib}.dylib
                       @rpath/#{lib}.dylib
                       #{staged_path}/bonzaiboost-macosx-v#{version}
                     ]
    end

    # Adds gcc dir (from homebrew) as relocation dir to find required libs
    system_command "/usr/bin/install_name_tool",
                   args: %W[
                     -add_rpath
                     #{HOMEBREW_PREFIX}/opt/gcc/lib/gcc/#{Formula["gcc"].version.major}
                     #{staged_path}/bonzaiboost-macosx-v#{version}
                   ]
  end

  caveats <<-EOS
    More information about command-line options available at
    http://bonzaiboost.gforge.inria.fr/#x1-30002
  EOS
end
