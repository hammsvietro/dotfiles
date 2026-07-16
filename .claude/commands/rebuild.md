---
description: Rebuild this NixOS host from the flake
---

Rebuild the current machine with the flake.

The two hosts are `fractal` (desktop) and `mandelbrot` (laptop); the system
`hostname` matches the flake attribute. Run:

```
sudo nixos-rebuild switch --flake ~/dotfiles#$(hostname)
```

Report whether the switch succeeded and surface any evaluation or build errors.
Nix changes only take effect after this runs.
