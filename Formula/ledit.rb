class Ledit < Formula
  desc "Line editor for interactive commands"
  homepage "http://pauillac.inria.fr/~ddr/ledit/"
  url "https://github.com/chetmurthy/ledit/archive/ledit-2-05.tar.gz"
  version "2.05"
  sha256 "493ee6eae47cc92f1bee5f3c04a2f7aaa0812e4bdf17e03b32776ab51421392c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^ledit[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.gsub("-", ".") }.compact
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "06141836398681d2250bf04d1bba965038f5f707482f0ecab1cc464c8a95bcfb"
    sha256 cellar: :any_skip_relocation, big_sur:       "2d404ace597c8a7062fbe96e15e9e7d1226ec5ca97e0c8981062c77fef10b4eb"
    sha256 cellar: :any_skip_relocation, catalina:      "158141ebf4edc253de428b8789d77eae0b19fdd4d8002e9910cf4c2486a12bb6"
    sha256 cellar: :any_skip_relocation, mojave:        "463dd47cebd8510a630e39008b001e52659f64f1bcda7503bdc8a0f28e55adfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "465cf6febb5757b297e99e358da97614f10b9c9685dec3e44a2f646ab42ade40"
  end

  depends_on "camlp5"
  depends_on "ocaml"

  def install
    # like camlp5, this build fails if the jobs are parallelized
    ENV.deparallelize
    args = %W[BINDIR=#{bin} LIBDIR=#{lib} MANDIR=#{man}]
    system "make", *args
    system "make", "install", *args
  end

  test do
    history = testpath/"history"
    pipe_output("#{bin}/ledit -x -h #{history} bash", "exit\n", 0)
    assert_predicate history, :exist?
    assert_equal "exit\n", history.read
  end
end
