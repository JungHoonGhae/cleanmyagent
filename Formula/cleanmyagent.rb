class Cleanmyagent < Formula
  include Language::Python::Shebang

  desc "Audit what your coding agents' skills/plugins/MCP cost vs how much you use them"
  homepage "https://github.com/JungHoonGhae/cleanmyagent"
  url "https://github.com/JungHoonGhae/cleanmyagent/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "6a7ad104fe1a537a17067230b5981e84d954e80f6729eb8a097f31eec16c15fc"
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
