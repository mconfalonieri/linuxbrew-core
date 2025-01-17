class Newlisp < Formula
  desc "Lisp-like, general-purpose scripting language"
  homepage "http://www.newlisp.org/"
  url "http://www.newlisp.org/downloads/newlisp-10.7.5.tgz"
  sha256 "dc2d0ff651c2b275bc4af3af8ba59851a6fb6e1eaddc20ae75fb60b1e90126ec"

  livecheck do
    url "http://www.newlisp.org/index.cgi?Downloads"
    regex(/href=.*?newlisp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "24b3c02002fa7c832d9a817c552b19bd520ae06f82ab526b8e993ae0a3d77d99"
    sha256 big_sur:       "509f6892a0eabf53cebe424f2f2163ded090b7942e8fe8e43047f43781b0535e"
    sha256 catalina:      "62fd116459d24ab0db976221fb16fd83a7a7db5447298bcc7f8b0dbf9a55f91f"
    sha256 mojave:        "179146b49c20011f3da4dbdb9b66a6ed66d5dd9f15d07aeca9b8717219a62eeb"
    sha256 high_sierra:   "5a0d4085a0e7fc364b3165be7e92a9dfeb2f4882e1971663ac74c70348a5c4a4"
    sha256 x86_64_linux:  "cf8de711e794fa5b226a3bca90f3200e2ecfbb5917e8a3e9f3fee10c8bad505f"
  end

  depends_on "readline"

  def install
    # Required to use our configuration
    ENV.append_to_cflags "-DNEWCONFIG -c"

    system "./configure-alt", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  def caveats
    <<~EOS
      If you have brew in a custom prefix, the included examples
      will need to be be pointed to your newlisp executable.
    EOS
  end

  test do
    path = testpath/"test.lsp"
    path.write <<~EOS
      (println "hello")
      (exit 0)
    EOS

    assert_equal "hello\n", shell_output("#{bin}/newlisp #{path}")
  end
end
