# Recovery

If for some reason, you're unable to boot into the system, try this.

First, boot into a live USB for the nixOS ISO.

Log in as root:
```bash
sudo -i
```

Decrypt the root partition:
```bash
lsblk # list current partitions
cryptsetup open /dev/nvme0n1p2 root # decrypt
```

Mount the partitions:
```bash
# Root partition
mount /dev/disk/by-label/NIXROOT /mnt

# Boot partition
mkdir -p /mnt/boot
mount /dev/disk/by-label/NIXBOOT /mnt/boot
```

Enter the system, logged in as root
```bash
nixos-enter --root /mnt
```

After entering in, you can also log in as the user account using:
```bash
su - toh995
```
