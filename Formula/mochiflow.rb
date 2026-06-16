class Mochiflow < Formula
  desc "Spec-driven development engine that drives AI coding agents through discuss, plan, build, and ship."
  homepage "https://github.com/ELUNOX/mochiflow"
  version "1.0.0-alpha.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.0.0-alpha.1/mochiflow-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3329841f131de710189a1571aae6e82a34889c6351b393e01d8e3ece8a69367e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.0.0-alpha.1/mochiflow-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5d72d6c20763f7312611ca569e686ee05826410e341c9b1debbcb42796dbbf50"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.0.0-alpha.1/mochiflow-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "5c35da578872934364ceae2bcb407492efef5759a3de85a19ce762f99aec3f20"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.0.0-alpha.1/mochiflow-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "74929e38b4fa7c7d61212023809994964d3ab5725661aaa0e0d0cd47d336a04e"
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
