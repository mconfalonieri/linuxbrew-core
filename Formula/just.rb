class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/0.9.6.tar.gz"
  sha256 "22897039e2f787dc53c83c353655594f23f9fecdada1bce5daf2e40fb75a0db4"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "35e6da7ed1aeea539ad520e45acb4ecd616959447938a00f8604112fb60cf839"
    sha256 cellar: :any_skip_relocation, big_sur:       "e8ba3bc587ed000cbd6ce0e7a1c502262405e42c5ce9b30eca18fcc78afb1a60"
    sha256 cellar: :any_skip_relocation, catalina:      "ed6381bac7f38e20caff27147d55a52fd2590271ab7206e2c1e474d540da5183"
    sha256 cellar: :any_skip_relocation, mojave:        "81aef64b0d8770ab1ab052f848d3cc0e66d792d8d7e8246076b091a656593345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97fb2045ca48eb93db81581fdafe637bdb7d62e19323d07da4b786f010d0debe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "man/just.1"
    bash_completion.install "completions/just.bash" => "just"
    fish_completion.install "completions/just.fish"
    zsh_completion.install "completions/just.zsh" => "_just"
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
