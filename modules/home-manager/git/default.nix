{
  # If we enable git, then home-manager will try creating
  # a git config file, which will conflict with our
  # custom config file.
  #
  # So let's disable git here.
  programs.git.enable = false;

  # Locally use the filename `.gitconfig`, to ensure that neovim
  # detects and sets the correct filetype, for syntax highlighting, etc.
  # See: https://github.com/neovim/neovim/blob/7a8402ac31aa2e155baafbc925c48527511c1e92/runtime/lua/vim/filetype.lua#L1462
  #
  # However, git READs a different config file... see:
  # https://wiki.archlinux.org/title/git#Using_git-config
  home.file.".config/git/config".source = ./.gitconfig;
}
