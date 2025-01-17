class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.26.10.tar.gz"
  sha256 "0e5311fb51b257965cc933dd803144112113f0e4a8c4d145f24fd8bb143acdb7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f2ff2f54aade0f443b782515d26a5c5decc7fbed8036f396672aeaa1a75ae4e7"
    sha256 cellar: :any_skip_relocation, big_sur:       "36ec0b0d4607ab9dfe30e8507ee4323a7c3df5e1e1b7e075372ed828ed406bb1"
    sha256 cellar: :any_skip_relocation, catalina:      "6a38b9f40e824b11dfae564d385f5b2ee1f8abe024917e7d1b7b414716b2a4aa"
    sha256 cellar: :any_skip_relocation, mojave:        "359511fe09c906dc774e9845cc0fd7c13e5477f762d357e96ee0220701ffbeca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10401c1b43eef61233bed98cbf111ef09e642c72550b755aee87d88b2b4674cc"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt", "./cmd/git-dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt-smudge", "./cmd/git-dolt-smudge"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
