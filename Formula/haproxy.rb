class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.4/src/haproxy-2.4.1.tar.gz"
  sha256 "1b2458b05e923d70cdc00a2c8e5579c2fcde9df16bbed8955f3f3030df14e62e"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "57ebcece910b552a942096bd38c7030c113518995328750defcf5b17089c9a0f"
    sha256 cellar: :any,                 big_sur:       "8d69924b9bf52d2f5a336576730c0156eacab2199ece608c2b57a8bdd456366d"
    sha256 cellar: :any,                 catalina:      "5cd0e0293559bc6d380d4c7247bbedc7a81a13382410a93bd9c058fcd1aed9bd"
    sha256 cellar: :any,                 mojave:        "7196ac5e06d00ebb40e3a7ec3de8464f11ab784f42bbd17596cdd2a3a264a5db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ace23d21d6772a0809d471911acb62f4368a3ebf4778b3451de6e1502854e0aa"
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    args = %w[
      USE_POLL=1
      USE_PCRE=1
      USE_OPENSSL=1
      USE_THREAD=1
      USE_ZLIB=1
      ADDLIB=-lcrypto
    ]
    on_macos do
      args << "TARGET=generic"
      # BSD only:
      args << "USE_KQUEUE=1"
    end
    on_linux do
      args << "TARGET=linux-glibc"
    end

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end

  plist_options manual: "haproxy -f #{HOMEBREW_PREFIX}/etc/haproxy.cfg"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/haproxy</string>
            <string>-f</string>
            <string>#{etc}/haproxy.cfg</string>
          </array>
          <key>StandardErrorPath</key>
          <string>#{var}/log/haproxy.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/haproxy.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    system bin/"haproxy", "-v"
  end
end
