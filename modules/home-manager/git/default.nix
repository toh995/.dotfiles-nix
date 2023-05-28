{
  # Locally use the filename `.gitconfig`, to ensure that neovim
  # detects and sets the correct filetype, for syntax highlighting, etc.
  # See: https://github.com/neovim/neovim/blob/7a8402ac31aa2e155baafbc925c48527511c1e92/runtime/lua/vim/filetype.lua#L1462
  #
  # However, git READs a different config file... see:
  # https://wiki.archlinux.org/title/git#Using_git-config
  xdg.configFile."git/config".source = ./.gitconfig;
}
