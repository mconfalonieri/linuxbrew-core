class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.13.0.tar.gz"
  sha256 "5d3c64011ac7d58652a8c7645643b8ddb6b51838c2f06455ba44e4f133e43254"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9aa545ba7986b90d384a61055a955200a7f43d5033199f3e374ac411d3ea1f4e"
    sha256 cellar: :any_skip_relocation, big_sur:       "685779abcb6eac015f29951c5ed4d47ff20a40ec4672a75e1637777b6816fdc7"
    sha256 cellar: :any_skip_relocation, catalina:      "d1941d932430ee327cb74ea78ae61e80fc9e3d4cde5220d6dae038a073896991"
    sha256 cellar: :any_skip_relocation, mojave:        "fbaee812f21bc982b51f034eb1383836f32231cea8f900bb5ff0fa4738bd2c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20d174096f65aa68e209ddb941f15e60688a9b82f23b3e92fbacb68162cb8146"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    touch "test.rb"
    assert_match "Failed to load your local Kubeconfig",
      shell_output("echo | #{bin}/okteto init --overwrite --file test.yml 2>&1")
  end
end
