class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "https://jugit.fz-juelich.de/mlz/libcerf"
  url "https://jugit.fz-juelich.de/mlz/libcerf/-/archive/v1.15/libcerf-v1.16.tar.gz"
  sha256 "5adf85560f7c2d44e5062c69af99251cc8a9ae9fba66d1a46592902fcf68dab7"
  license "MIT"
  version_scheme 1
  head "https://jugit.fz-juelich.de/mlz/libcerf.git"

  livecheck do
    url "https://jugit.fz-juelich.de/api/v4/projects/269/releases"
    regex(/libcerf[._-]v?((?!2\.0)\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "12b0794891c9fb76a5e0ce84d693e9a4f344809211b3b829a36f6dd08eb6f599"
    sha256 cellar: :any,                 big_sur:       "76b3640332901e939eb60a0b4d765ffa0007b889b875f12966c3184970916085"
    sha256 cellar: :any,                 catalina:      "54ab9a449d9a6309bf92c6feabd7bed33c30173878905135855280deaa429721"
    sha256 cellar: :any,                 mojave:        "3f594f4f8692aabda12cdd37fd2d6af5e66ab12635d8e032ec8f181221a4162b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25b2badb09c066dd6ac3bfd66209b70c167aaab2189a10eb0fa6d51197aa456d"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cerf.h>
      #include <complex.h>
      #include <math.h>
      #include <stdio.h>
      #include <stdlib.h>

      int main (void) {
        double _Complex a = 1.0 - 0.4I;
        a = cerf(a);
        if (fabs(creal(a)-0.910867) > 1.e-6) abort();
        if (fabs(cimag(a)+0.156454) > 1.e-6) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcerf", "-o", "test"
    system "./test"
  end
end
