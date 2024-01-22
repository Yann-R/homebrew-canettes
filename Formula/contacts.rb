class Contacts < Formula
  desc "Command-line tool to access macOS's Contacts (formerly 'Address Book')"
  homepage "https://gnufoo.org/contacts/contacts.html"
  # No releases or tags, then use a particular commit:
  url "https://github.com/shanecelis/contacts/archive/466cde5ca750a173b6022bd5e78d0f490365b9b8.tar.gz"
  version "2022-05-04" # date of the commit
  sha256 "12ef66e95b0a7df204612b517fd8ccceda7ef139f14c4cb0ca37d4031c42e92d"
  license "GPL-2.0-only"
  head "https://github.com/shanecelis/contacts.git"

  livecheck do
    url "https://github.com/shanecelis/contacts/commits.atom"
    regex(/<updated>(.+)T.+Z</i)
    # e.g. <title>Recent Commits to contacts:master</title> <updated>2022-05-04T07:57:40Z</updated>
    strategy :page_match
  end

  def install
    system "make"
    bin.install "contacts"
    man1.install Utils::Gzip.compress("contacts.1")
  end

  test do
    output = shell_output("#{bin}/contacts -h 2>&1", 2)
    assert_match "displays contacts from the AddressBook database", output
  end
end
