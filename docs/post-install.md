# Post-install
## Install neovim packages
Simply open up neovim. All packages/dependencies will be auto-installed.

## Set up the web browsers (brave + firefox)
- Set dark mode
- Set the default search engine
- Change the download folder
- Customize the start page
- Change default fonts (go to `brave://settings/fonts`)

## Set up GitHub ssh
Follow the instructions at https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

## Clone this repo to $HOME
```bash
cd $HOME
git clone git@github.com:toh995/.dotfiles-nix.git
cd .dotfiles-nix
# copy the hardware config file
# NOTE: may need to rework this, if we expand to multiple machines!!!
cp /etc/nixos/hardware-configuration.nix ./modules/hardware-config.nix
```

## Clone neovim config
```bash
cd $HOME/.config
git clone git@github.com:toh995/nvim.git
```

## Clone secrets to $XDG_DATA_HOME
