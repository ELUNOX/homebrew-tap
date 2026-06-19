class Mochiflow < Formula
  desc "Spec-driven development engine that drives AI coding agents through discuss, plan, build, and ship."
  homepage "https://github.com/ELUNOX/mochiflow"
  version "1.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.1.2/mochiflow-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e9ed29fd5f5f0767913873782e41f5d56ac4261ad2069c94804f68d3a49b92cb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.1.2/mochiflow-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e5ba188712c8cd5666ec791dbd013dfc4bcd9bb5143b67071b1ae1a414dcfdb0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.1.2/mochiflow-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "4fb1eba23edad9ea4d510d1e0578247f8c5af66d9bc549523220bc1750df3e38"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.1.2/mochiflow-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "7fd001c645bf32a5fcce170ce59ce1df9968bc63022b22dd80d0915ce78032b2"
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
