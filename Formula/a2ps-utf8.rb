class A2psUtf8 < Formula
  desc "Wrapper around a2ps to accept input files in UTF-8 (using iconv to convert)"
  homepage "https://matthieu-moy.fr/utils/"
  url "https://matthieu-moy.fr/utils/a2ps-utf8"
  version "2005.1.21"
  sha256 "84e43a23b2abe23cf4c46cf393e0d9afa1a36dbb7eb827cbde16ab9524fb6f41"

  livecheck do
    url :homepage # NOTE: this page is not encoded in UTF-8
    regex(/Derni.re mise . jour : (?<dofw>\S*) (?<day>\d{1,2}) (?<month>\S+) (?<year>\d{4,4})/i)
    # e.g. Dernière mise à jour : vendredi 21 janvier 2005.
    strategy :page_match do |page, regex|
      # Converts date-based version from French texts to YYYY.M.D
      page.match(regex) do |match|
        nofm = match[:month].to_s
                            .sub(/jan\S*/, "1").sub(/f.v\S*/, "2").sub(/mar\S*/, "3")
                            .sub(/avr\S*/, "4").sub(/mai\S*/, "5").sub(/juin\S*/, "6")
                            .sub(/juil\S*/, "7").sub(/ao\S*/, "8").sub(/sep\S*/, "9")
                            .sub(/oct\S*/, "10").sub(/nov\S*/, "11").sub(/d.c\S*/, "12")
        "#{match[:year]}.#{nofm}.#{match[:day]}"
      end
    end
  end

  depends_on "a2ps"
  uses_from_macos "libiconv"

  def install
    bin.install "a2ps-utf8"
  end

  test do
    (testpath/"test.txt").write("Hello World!\n")
    system bin/"a2ps-utf8", "test.txt", "-o", "test.ps"
    assert File.read("test.ps").start_with?("%!PS-Adobe")
  end
end
