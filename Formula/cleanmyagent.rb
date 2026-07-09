class Cleanmyagent < Formula
  include Language::Python::Shebang

  desc "Audit what your coding agents' skills/plugins/MCP cost vs how much you use them"
  homepage "https://github.com/JungHoonGhae/cleanmyagent"
  url "https://github.com/JungHoonGhae/cleanmyagent/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "c2a813fe25115294df7eacd1d204c4bac7bbd7a66218d1f653da8958b794a45c"
  license "MPL-2.0"

  depends_on "python@3.13"

  def install
    rewrite_shebang detected_python_shebang, "cleanmyagent"
    bin.install "cleanmyagent"
  end

  test do
    assert_match "skills", shell_output("#{bin}/cleanmyagent --json")
  end
end
