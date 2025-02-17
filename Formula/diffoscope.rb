class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/11/cd/36502685783f4c2878e6adb856354a332460eb2b67e1c5521978691c3a2d/diffoscope-218.tar.gz"
  sha256 "68056e6d5382bfe16662c60d47bf710aa7b0ef43bfde1172fad694bc487279e3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3302a42dc3bc9a779cae29df409f3fc2f507b5527aa8562828a341b3ec1e1d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7b636b7c12680f9727e16cae8f94598733459351325a48ac096f3e245d8cf88"
    sha256 cellar: :any_skip_relocation, monterey:       "e687e8cee7d7737aba2ec01f415b661ef02e6742f6ae5bf8702128629ca8b03e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8aa4eeacd01e05e00fed50c464a02a1c3adf0d3be59009303e33ec5472b7e470"
    sha256 cellar: :any_skip_relocation, catalina:       "83d99e36c97fdeeb5738dff8bbbf19a280a277c6da20b30d375de2575065cf1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e22178443a5f0e22246cb3b827789fe03d51f95290b0cd6db9941ac11ea09b4"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.10"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/93/c4/d8fa5dfcfef8aa3144ce4cfe4a87a7428b9f78989d65e9b4aa0f0beda5a8/libarchive-c-4.0.tar.gz"
    sha256 "a5b41ade94ba58b198d778e68000f6b7de41da768de7140c984f71d7fa8416e5"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = Formula["libarchive"].opt_lib/shared_library("libarchive")
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system "#{bin}/diffoscope", "--progress", "test1", "test2"
  end
end
