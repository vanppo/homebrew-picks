class Pizauth < Formula
  desc "OAuth2 token requester daemon"
  homepage "https://github.com/ltratt/pizauth"
  url "https://github.com/ltratt/pizauth/archive/refs/tags/pizauth-1.1.1.tar.gz"
  sha256 "0640ed4e3199f451de956c56f1bff420275daa3d4a4a25be4dab76d3a39f7659"
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
