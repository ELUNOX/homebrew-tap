class Mochiflow < Formula
  desc "Spec-driven development engine that drives AI coding agents through discuss, plan, build, and ship."
  homepage "https://github.com/ELUNOX/mochiflow"
  version "1.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.2.2/mochiflow-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3329df7834e55d21e4a45cbce162de77687d07b9234459e326378d64d213b984"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.2.2/mochiflow-cli-x86_64-apple-darwin.tar.xz"
      sha256 "17634eeced47353a02cfc0a758b4e592853bc3e2c70cd60274128ab09c8e1166"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.2.2/mochiflow-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "647e026a4745349814e1ff4ac6c5f6305ce22de1a5a6e71bb3a27a33561921b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.2.2/mochiflow-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "e6d0b24f4ff7575b9d09e89beb4276bbb4ebb2d2e327e6498ddbaee5ee9b11b6"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "mochiflow" if OS.mac? && Hardware::CPU.arm?
    bin.install "mochiflow" if OS.mac? && Hardware::CPU.intel?
    bin.install "mochiflow" if OS.linux? && Hardware::CPU.arm?
    bin.install "mochiflow" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
