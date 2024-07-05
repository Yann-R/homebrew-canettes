cask "javascool" do
  version "4"
  sha256 "051190db7b54f583011c3ffe2b1c4e3063db7d47877f2dbdc9044d248ed4c1b4"

  # url "http://javascool.gforge.inria.fr/javascool-proglets.jar" # Official no longer available
  url  "https://web.archive.org/web/20170418223738/http://javascool.gforge.inria.fr/javascool-proglets.jar"
  name "Java's Cool 4"
  # see description "https://www.enseignementsup-recherche.gouv.fr/ressources-pedagogiques/notice/view/INRIA-Javascool"
  desc "Java-based Macro-language and ressources to learn Programming and Algorithms"
  # homepage "http://javascool.gforge.inria.fr" # Official no longer available
  homepage "https://wiki.inria.fr/wikis/sciencinfolycee/index.php?search=javascool"

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
