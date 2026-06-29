class Mochiflow < Formula
  desc "Spec-driven development engine that drives AI coding agents through discuss, plan, build, and ship."
  homepage "https://github.com/ELUNOX/mochiflow"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.2.0/mochiflow-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8844891d9d47c41c4b1071c3023645f6c800ce4d25e62609f83df83c2fae9b45"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.2.0/mochiflow-cli-x86_64-apple-darwin.tar.xz"
      sha256 "807e13532e5557bd7eca71616bf0de41bf8a0752ef576db06b4c1c91c878cdde"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.2.0/mochiflow-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "cfb5cbd1bda20a8100f8599b595ad1ac7ab7d41491b1c9a83e99518381022e46"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ELUNOX/mochiflow/releases/download/v1.2.0/mochiflow-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "e34e9e36f35f57e1076323611baca6c1f58c62f1ede0f5f2ebd35843a93d342d"
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
