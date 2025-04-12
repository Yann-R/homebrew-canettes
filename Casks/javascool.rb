cask "javascool" do
  version "4.0.1329,2017-06-10"
  sha256 "7553816eba2c2a65117a0be3d98168b8e176e7782b9984be7c9e10fddc09f96c"

  # url "http://javascool.gforge.inria.fr/javascool-proglets.jar" # Official no longer available
  url  "https://web.archive.org/web/20170621094236/http://javascool.gforge.inria.fr:80/javascool-proglets.jar"
  name "Java's Cool 4"
  # see description "https://www.enseignementsup-recherche.gouv.fr/ressources-pedagogiques/notice/view/INRIA-Javascool"
  desc "Java-based Macro-language and ressources to learn Programming and Algorithms"
  # homepage "http://javascool.gforge.inria.fr" # Official no longer available
  homepage "https://web.archive.org/web/20190319204320/http://javascool.gforge.inria.fr/index.php?page=run"
  # homepage "https://wiki.inria.fr/wikis/sciencinfolycee/index.php?search=javascool"

  shimscript = "#{staged_path}/javascool.sh"
  app "javascool-proglets.jar"
  binary shimscript, target: "javascool"

  preflight do
    # Adds a command-line script to launch Java's Cool.
    IO.write shimscript, <<~EOS
      #!/bin/sh
      java -jar "#{appdir}/javascool-proglets.jar"
    EOS
  end
  
  postflight do
    # Hides extension in Finder to look like an application.
    system_command "SetFile", 
                   args: [
                     "-a",
                     "E",
                     "#{appdir}/javascool-proglets.jar",
                   ]
  end

  zap trash: "~/Library/Application Support/javascool"
  
  caveats do
    license "https://wiki.inria.fr/sciencinfolycee/JavaScool:Licence"
    depends_on_java
  end
end
