class BashCompletionAT2 < Formula
  desc "Programmable completion for Bash 4.2+"
  homepage "https://github.com/scop/bash-completion"
  url "https://github.com/scop/bash-completion/releases/download/2.11/bash-completion-2.11.tar.xz"
  sha256 "73a8894bad94dee83ab468fa09f628daffd567e8bef1a24277f1e9a0daf911ac"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "336f04248a6da8c65291ef74c35430f843ae10b5c29d092ab463803fa14b2014"
    sha256 cellar: :any_skip_relocation, big_sur:       "27ccf1267d18fcd3e6018ec80363d003d07f750182bdef61150371532100bfc9"
    sha256 cellar: :any_skip_relocation, catalina:      "3fe7e4021769be9a92eac055496e6189996c3527270db1dfdd4b0eb8cd7b4192"
    sha256 cellar: :any_skip_relocation, mojave:        "3fe7e4021769be9a92eac055496e6189996c3527270db1dfdd4b0eb8cd7b4192"
    sha256 cellar: :any_skip_relocation, high_sierra:   "3fe7e4021769be9a92eac055496e6189996c3527270db1dfdd4b0eb8cd7b4192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c782153690c494c7cbd82fdbec5d7579dae5b9b7453f6670644ebba7df83377f"
  end

  head do
    url "https://github.com/scop/bash-completion.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  keg_only :versioned_formula

  depends_on "bash"

  conflicts_with "bash-completion",
    because: "each are different versions of the same formula"

  def install
    inreplace "bash_completion" do |s|
      s.gsub! "readlink -f", "readlink"
      # Automatically read Homebrew's existing v1 completions
      s.gsub! ":-/etc/bash_completion.d", ":-#{etc}/bash_completion.d"
    end

    system "autoreconf", "-i" if build.head?
    system "./configure", "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your ~/.bash_profile:
        [[ -r "#{etc}/profile.d/bash_completion.sh" ]] && . "#{etc}/profile.d/bash_completion.sh"
    EOS
  end

  test do
    system "test", "-f", "#{share}/bash-completion/bash_completion"
  end
end
