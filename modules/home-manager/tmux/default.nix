{
  xdg.configFile = {
    "tmux/tmux.conf".source = ./tmux.conf;
    "tmux/catppuccin".source = builtins.fetchGit {
      url = "https://github.com/catppuccin/tmux.git";
      rev = "a0119d25283ba2b18287447c1f86720a255fb652"; # commit SHA
    };
  };
}
