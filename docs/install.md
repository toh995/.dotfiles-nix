# Installation

Sources:
- [NixOS Manual](https://nixos.org/manual/nixos/stable/index.html#sec-installation-manual)
- [NixOS Wiki](https://nixos.wiki/wiki/NixOS_Installation_Guide)

Boot into the installation media via UEFI if possible

Log in as root:
```bash
sudo -i
```

## Create Partitions

Find the disk to install nixOS onto
```bash
lsblk
```

Assuming we are using UEFI, create two partitions - one for boot, and one for root
(can optionally add a third partition for swap)

```bash
fdisk /dev/nvme0n1
```

Within fdisk:
```bash
g # format the disk to use GPT

# create the boot partition
n # new partition
1 # (partition number [1/128])
2048 # first sector
+500M # last sector (boot partition is 500MB large)
t # reformat boot partition
1 # (EFI System)

# create the root partition
n
2
default (fill up partition)
default (fill up partition)

# finally, write
w (write)
```

Verify the new partition names, using `lsblk`

## Encrypt the root partition
Based on the [Arch Wiki on encryption](https://wiki.archlinux.org/title/dm-crypt/Encrypting_an_entire_system#Preparing_non-boot_partitions)

```bash
# set an encryption password for the root partition
cryptsetup luksFormat /dev/nvme0n1p2

# decrypt the root partition, and mount it at /dev/mapper/root
cryptsetup open /dev/nvme0n1p2 root
```

## Format the partitions
```bash
# format the boot partition, giving it the label NIXBOOT
mkfs.fat -F 32 -n NIXBOOT /dev/nvme0n1p1

# format the decrypted root partition, giving it the label NIXROOT
mkfs.ext4 -L NIXROOT /dev/mapper/root
```

## Mount the partitions to `/mnt`
```bash
# mount the root partition
mount /dev/disk/by-label/NIXROOT /mnt

# mount the boot partition
mkdir -p /mnt/boot
mount /dev/disk/by-label/NIXBOOT /mnt/boot
```

## Generate the initial config files
```bash
# this will generate two files:
# 1. /mnt/etc/nixos/configuration.nix
# 2. /mnt/etc/nixos/hardware-configuration.nix
nixos-generate-config --root /mnt
```

## Double-check the generated config files
Run `vim /mnt/etc/nixos/hardware-configuration.nix`, and check that we have appropriate decryption instructions:
```
boot.initrd.luks.devices.root.device = "/dev/disk/by-uuid/3f6b0024-3a44-4fde-a43a-767b872abe5d";
fileSystems."/".device = "/dev/mapper/root";
```

## Set up the flake for installation
```bash
# enter a shell with git and flakes
nix-shell -p git nixFlakes

# clone this repo
cd /tmp
git clone https://github.com/toh995/.dotfiles-nix.git

# copy the hardware-config file
# NOTE: may need to rework this, if we are using multiple machines!!!
cd .dotfiles-nix
cp /mnt/etc/nixos/hardware-configuration.nix ./modules/hardware-config.nix

# start tracking the hardware-config file, so the flake can read it
git add .
```

## Install
NOTE: May need to revisit, if we are using multiple machines!!!
```bash
# change to unstable channel
nix-channel --add https://nixos.org/channels/nixos-unstable nixos

# update the most recent unstable channel
nix-channel --update

# install!
nixos-install --root /mnt --flake .#nixos --cores 0
```

## Set up passwords
As the last step, `nixos-install` will ask to set the password for the root user.

Now, set up the user password:
```bash
nixos-enter --root /mnt --command "passwd toh995"
```

## Reboot
Run `reboot`
