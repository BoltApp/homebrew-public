class Protobuf < Formula
  desc "Install a specific version (v3.21.0) of Protocol buffers currently supported at Bolt."
  homepage "https://github.com/protocolbuffers/protobuf/"
  license "BSD-3-Clause"

  on_macos do
    url "https://github.com/protocolbuffers/protobuf/releases/download/v21.0/protoc-21.0-osx-universal_binary.zip"
    sha256 "e94c66607768c8c47e8864b91e835d50cbe7e18241b34de3c30a4503cc51c36d"

    def install
      bin.install "bin/protoc" => "protoc"
      include.install "include/google"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/protocolbuffers/protobuf/releases/download/v21.0/protoc-21.0-linux-aarch_64.zip"
      sha256 "72f063d96e4616995dfd24ba2c545ef741b7bf4b25e6077b86f19b41553b79e5"

      def install
        bin.install "bin/protoc" => "protoc"
        include.install "include/google"
      end
    end
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/protocolbuffers/protobuf/releases/download/v21.0/protoc-21.0-linux-x86_64.zip"
      sha256 "a2a92003da7b8c0c08aab530a3c1967d377c2777723482adb9d2eb38c87a9d5f"

      def install
        bin.install "bin/protoc" => "protoc"
        include.install "include/google"
      end
    end
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system bin/"protoc", "test.proto", "--cpp_out=."
  end
end
