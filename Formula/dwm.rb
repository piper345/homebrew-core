class Dwm < Formula
  desc "Dynamic window manager"
  homepage "https://dwm.suckless.org/"
  url "https://dl.suckless.org/dwm/dwm-6.1.tar.gz"
  sha256 "c2f6c56167f0acdbe3dc37cca9c1a19260c040f2d4800e3529a21ad7cce275fe"
  head "https://git.suckless.org/dwm", :using => :git

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ffdfc837189fa59c0087c1c3c9eb5914ecf258f4b68943f90ba3a17cea88bbbd" => :sierra
    sha256 "1fd177390281018b874b3adb348307b58c80519ad21ca0f54973608d6e4611eb" => :el_capitan
    sha256 "0cfba9b0ef84f3f412cf3d5ffd820f5296360e6d1b0bfc9c2bb1325c04ee9583" => :yosemite
  end

  depends_on :x11
  depends_on "dmenu" => :optional

  def install
    # The dwm default quit keybinding Mod1-Shift-q collides with
    # the Mac OS X Log Out shortcut in the Apple menu.
    inreplace "config.def.h",
    "{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },",
    "{ MODKEY|ControlMask,           XK_q,      quit,           {0} },"
    inreplace "dwm.1", '.B Mod1\-Shift\-q', '.B Mod1\-Control\-q'
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats; <<-EOS.undent
    In order to use the Mac OS X command key for dwm commands,
    change the X11 keyboard modifier map using xmodmap (1).

    e.g. by running the following command from $HOME/.xinitrc
    xmodmap -e 'remove Mod2 = Meta_L' -e 'add Mod1 = Meta_L'&

    See also https://gist.github.com/311377 for a handful of tips and tricks
    for running dwm on Mac OS X.
    EOS
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/dwm -v 2>&1", 1)
  end
end
