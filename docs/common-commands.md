Rebuild
```bash
sudo nixos-rebuild switch --flake . --upgrade-all
```

Clean nix store
```bash
nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory|/proc)"
```
