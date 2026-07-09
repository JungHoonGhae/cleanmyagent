class Cleanmyagent < Formula
  include Language::Python::Shebang

  desc "Audit what your coding agents' skills/plugins/MCP cost vs how much you use them"
  homepage "https://github.com/JungHoonGhae/cleanmyagent"
  url "https://github.com/JungHoonGhae/cleanmyagent/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "b363267d7dffcdbffc8e17a20647b13a94a778c434b73af8dc0407b2301ea603"
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
