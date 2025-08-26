## Nix-darwin Setup
```bash
# Install xcode developer tools (installs git, etc.)
xcode-select --install
softwareupdate --install-rosetta

# Download and set up config files
mkdir -p ~/code
cd ~/code
git clone https://github.com/toh995/.dotfiles-nix.git

sudo mkdir -p /etc/nix-darwin
sudo chown $(id -nu):$(id -ng) /etc/nix-darwin
ln ~/code/.dotfiles-nix/darwin-flake.nix /etc/nix-darwin/flake.nix

# IMPORTANT: Ensure that the flake.nix file has the correct host
# (example host name "toh995s-Mac-mini")
# Use the following command, to get the current host name
scutil --get LocalHostName

# Install nix itself, via determinate installer. 
# Do NOT install determinate itself.
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# Go to Settings => Privacy & Security => Full Disk Access, and allow access for Terminal
# 
# We need to restart the terminal for two reasons:
# 1. Grant Full Disk Access
# 2. Get `nix` into the $PATH

# Install the flake
sudo nix run nix-darwin/master#darwin-rebuild -- switch
```

## Reboot
Reboot, to see latest changes

## Arrange monitors

## Setup 3rd Party apps
### Rectangle
- Set to boot on login

### Mouse assisstant
- Set the back/forward buttons for Safari, to `Command + [` and `Command + ]`

### Safari
- Open Vimari to activate it
- Download ad block https://github.com/uBlockOrigin/uBOL-home
- Configure extensions in safari settings

## Github ssh, change remote
- Set up github ssh https://docs.github.com/en/authentication/connecting-to-github-with-ssh/checking-for-existing-ssh-keys
- Change git remote from HTTPS to SSH
```bash
git remote set-url origin git@github.com:toh995/.dotfils-nix.git
```
