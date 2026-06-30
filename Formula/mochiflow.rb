class Mochiflow < Formula
  desc "Spec-driven development engine that drives AI coding agents through discuss, plan, build, and ship."
  homepage "https://github.com/ELUNOX/mochiflow"
  version "1.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.2.1/mochiflow-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c07b0fb0e6d92fa7d84187e050882825066bac28bb01f572e007f1fc7341ea38"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.2.1/mochiflow-cli-x86_64-apple-darwin.tar.xz"
      sha256 "13bb2aba8ece7bf07cb0607e32f277974fa08ecbacb88b8a5af76b44a3ac6c73"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.2.1/mochiflow-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "119453a97fa6f705e366af2f3dc4a2f1495542fe1c1e6da0e6213b4c4ccee21e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.2.1/mochiflow-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "311d7a570e08a5dc1f0559486ed5af7e40a184feca0e5302ca006aa1b4f8e546"
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
