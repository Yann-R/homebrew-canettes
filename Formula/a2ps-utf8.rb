class A2psUtf8 < Formula
  desc "Wrapper around a2ps to accept input files in UTF-8 (using iconv to convert)"
  homepage "https://matthieu-moy.fr/utils/"
  url "https://matthieu-moy.fr/utils/a2ps-utf8"
  version "2005.1.21"
  sha256 "84e43a23b2abe23cf4c46cf393e0d9afa1a36dbb7eb827cbde16ab9524fb6f41"

  depends_on "a2ps"
  uses_from_macos "iconv"

  def install
    bin.install "a2ps-utf8"
  end

  test do
    (testpath/"test.txt").write("Hello World!\n")
    system bin/"a2ps-utf8", "test.txt", "-o", "test.ps"
    assert File.read("test.ps").start_with?("%!PS-Adobe")
  end
end
