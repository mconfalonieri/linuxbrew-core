class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2021/sqlite-src-3360000.zip"
  version "3.36.0"
  sha256 "25a3b9d08066b3a9003f06a96b2a8d1348994c29cc912535401154501d875324"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "21de15f86c125a02389a2dca0a7d53dc3dd01dddd6bcc38ceb7d322597a093de"
    sha256 cellar: :any_skip_relocation, big_sur:       "90601ff9aed7b0638b959e765878f42e38430dead627adbb7d6b68530ecb0915"
    sha256 cellar: :any_skip_relocation, catalina:      "8ccda1604107c379c4072127825ac3a1c042ad03ccb8d6f763335403ca01790c"
    sha256 cellar: :any_skip_relocation, mojave:        "470d541de3685a5b7ba46a997e493e6a69faf1ff69d29b15dbbed0c1e10fd166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d4152b7daec60f5864e9e17c8d91f17de3bb5ffcdd81375fcf1351a7a7fd027"
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "sqldiff"
    bin.install "sqldiff"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged",
                 shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end
