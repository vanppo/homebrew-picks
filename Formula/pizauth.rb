class Pizauth < Formula
  desc "OAuth2 token requester daemon"
  homepage "https://github.com/ltratt/pizauth"
  url "https://github.com/ltratt/pizauth/archive/refs/tags/pizauth-1.1.0.tar.gz"
  sha256 "1e7219795937160f74fabfe98e948818a1fa28cfc9dc9b7bcfb6853bce5fb72d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^pizauth[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "pizauth.1"
    man5.install "pizauth.conf.5"
    bash_completion.install "share/bash/completion.bash"
    fish_completion.install "share/fish/pizauth.fish"
    zsh_completion.install "share/zsh/_pizauth"
    pkgshare.install "examples/pizauth.conf"
  end

  service do
    run [opt_bin/"pizauth", "server", "-d"]
    keep_alive true
    log_path var/"log/pizauth.log"
    error_log_path var/"log/pizauth.log"
  end

  test do
    touch testpath/"pizauth.conf"
    assert_match "pizauth version", shell_output("#{bin}/pizauth info -c #{testpath}/pizauth.conf")
  end
end
