class Cleanmyagent < Formula
  include Language::Python::Shebang

  desc "Audit what your coding agents' skills/plugins/MCP cost vs how much you use them"
  homepage "https://github.com/JungHoonGhae/cleanmyagent"
  url "https://github.com/JungHoonGhae/cleanmyagent/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "04dc14229559fe04a05cd24ea24921295eb15016cd53b9a07b080a2fe8d27670"
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
