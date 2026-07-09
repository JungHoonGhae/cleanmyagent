class Cleanmyagent < Formula
  include Language::Python::Shebang

  desc "Audit what your coding agents' skills/plugins/MCP cost vs how much you use them"
  homepage "https://github.com/JungHoonGhae/cleanmyagent"
  url "https://github.com/JungHoonGhae/cleanmyagent/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "817b7e5ec97e22748b21510be8a0c72d4bd15a75bb51d38225e9205a0bbb09af"
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
